import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gateapp_guard/models/base_list_response.dart';
import 'package:gateapp_guard/models/guard_profile.dart';
import 'package:gateapp_guard/models/remote_response_type.dart';
import 'package:gateapp_guard/models/visitor_log.dart';
import 'package:gateapp_guard/models/visitor_log_request.dart';
import 'package:gateapp_guard/models/visitor_log_update_request.dart';
import 'package:gateapp_guard/network/remote_repository.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';

part 'fetcher_visitor_logs_state.dart';

class FetcherVisitorLogsCubit extends Cubit<FetcherVisitorLogsState> {
  final List<RemoteResponseType<VisitorLog>> visitorTypes = [
    RemoteResponseType<VisitorLog>("waiting"),
    RemoteResponseType<VisitorLog>("inside")
  ];
  GuardProfile? guardProfile;
  StreamSubscription<DatabaseEvent>? _changedStreamSubscription;
  int _latestCreatedAtMillis = -1;
  List<RemoteResponseType<VisitorLog>> get getVisitorTypes => visitorTypes;

  FetcherVisitorLogsCubit() : super(const FetcherVisitorLogsInitial());

  initCreateVisitorLog(VisitorLogRequest visitorLogRequest) async {
    emit(const CreateVisitorLogLoading());
    try {
      VisitorLog visitorLog =
          await RemoteRepository().createVisitorLog(visitorLogRequest);
      emit(CreateVisitorLogLoaded(visitorLog));
      _addVisitorLogToFirebase(visitorLog);
      _addVisitorLogToWaiting(visitorLog);
    } catch (e) {
      if (kDebugMode) {
        print("initCreateVisitorLog: $e");
      }
      emit(CreateVisitorLogFail("Something went wrong", "something_wrong"));
    }
  }

  Future<void> initFetchVisitorLogs(
      {required String tabType, bool? paginate, bool? refresh}) async {
    int visitorTypeIndex =
        visitorTypes.indexWhere((element) => element.type == tabType);
    if (visitorTypeIndex == -1) return;
    if (refresh ?? false) visitorTypes[visitorTypeIndex].reset();
    if (visitorTypes[visitorTypeIndex].allDone ||
        visitorTypes[visitorTypeIndex].isLoading) return;

    guardProfile = await LocalDataLayer().getGuardProfileMe();
    visitorTypes[visitorTypeIndex].isLoading = true;
    emit(const FetcherVisitorLogsLoading());
    try {
      BaseListResponse<VisitorLog> baseListResponse = await RemoteRepository()
          .getVisitorLogs(
              projectId: guardProfile!.project_id!,
              pageNo: (visitorTypes[visitorTypeIndex].page +
                  ((paginate ?? false) ? 1 : 0)),
              status: visitorTypes[visitorTypeIndex].type == "inside"
                  ? "inside"
                  : null,
              isWaiting: visitorTypes[visitorTypeIndex].type == "waiting"
                  ? true
                  : null);
      for (VisitorLog visitorLog in baseListResponse.data) {
        visitorLog.setup();
      }
      if (visitorTypes[visitorTypeIndex].type == "waiting" &&
          baseListResponse.data.isNotEmpty &&
          _latestCreatedAtMillis <
              DateTime.parse(baseListResponse.data.first.created_at)
                  .millisecondsSinceEpoch) {
        _latestCreatedAtMillis =
            DateTime.parse(baseListResponse.data.first.created_at)
                .millisecondsSinceEpoch;
        if (kDebugMode) {
          print("latestCreatedAtMillis: $_latestCreatedAtMillis");
        }
      }

      visitorTypes[visitorTypeIndex].isLoading = false;
      visitorTypes[visitorTypeIndex].page =
          baseListResponse.meta.current_page ?? 1;
      visitorTypes[visitorTypeIndex].allDone =
          baseListResponse.meta.current_page == baseListResponse.meta.last_page;
      if (visitorTypes[visitorTypeIndex].page == 1) {
        visitorTypes[visitorTypeIndex].data.clear();
      }
      visitorTypes[visitorTypeIndex].data.addAll(baseListResponse.data);
      emit(VisitorLogsLoaded(visitorTypes[visitorTypeIndex]));
      _initFireUpdates();
    } catch (e) {
      if (kDebugMode) {
        print("initFetchVisitorLogs: $e");
      }
      visitorTypes[visitorTypeIndex].isLoading = false;
      emit(VisitorLogsFail("Something went wrong", "something_wrong",
          visitorTypes[visitorTypeIndex].type));
    }
  }

  initUpdateVisitorLog(String? tabType, int visitorLogId,
      VisitorLogUpdateRequest visitorLogUpdateRequest) async {
    emit(VisitorLogUpdateLoading(tabType, visitorLogId));
    try {
      VisitorLog visitorLog = await RemoteRepository()
          .updateVisitorLog(visitorLogId, visitorLogUpdateRequest);
      _addVisitorLogToFirebase(visitorLog);
      emit(VisitorLogUpdateLoaded(visitorLog));
      if (visitorLog.status == "inside") {
        int indexWaitingTab =
            visitorTypes.indexWhere((element) => element.type == "waiting");
        if (indexWaitingTab == -1) {
          indexWaitingTab = 0;
        }
        visitorTypes[indexWaitingTab]
            .data
            .removeWhere((element) => element.id == visitorLog.id);
        emit(VisitorLogsLoaded(visitorTypes[indexWaitingTab]));
        emit(const VisitorLogUpdateLoading("inside", -1));
        int indexInsideTab =
            visitorTypes.indexWhere((element) => element.type == "inside");
        if (indexInsideTab == -1) {
          indexInsideTab = 1;
        }
        visitorTypes[indexInsideTab].data.insert(0, visitorLog);
        emit(VisitorLogsLoaded(visitorTypes[indexInsideTab]));
      } else if (visitorLog.status == "left") {
        int indexInsideTab =
            visitorTypes.indexWhere((element) => element.type == "inside");
        if (indexInsideTab == -1) {
          indexInsideTab = 1;
        }
        visitorTypes[indexInsideTab]
            .data
            .removeWhere((element) => element.id == visitorLog.id);
        emit(VisitorLogsLoaded(visitorTypes[indexInsideTab]));
      }
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateVisitorLog: $e");
      }
      emit(VisitorLogUpdateFail(
          "Something went wrong", "something_wrong", tabType));
    }
  }

  _addVisitorLogToFirebase(VisitorLog vl) {
    try {
      var vlr = jsonDecode(jsonEncode(vl));
      FirebaseDatabase.instance
          .ref()
          .child(Constants.refBase)
          .child("flat")
          .child("${vl.flat_id}")
          .child("visitor_log")
          .child("${vl.id}")
          .set(vlr);
      FirebaseDatabase.instance
          .ref()
          .child(Constants.refBase)
          .child("project")
          .child("${vl.project_id}")
          .child("visitor_log")
          .child("${vl.id}")
          .set(vlr);
    } catch (e) {
      if (kDebugMode) {
        print("addVisitorLogToFirebase: $e");
      }
    }
  }

  _addVisitorLogToWaiting(VisitorLog vl) {
    int visitorTypeIndex =
        visitorTypes.indexWhere((element) => element.type == "waiting");
    if (visitorTypeIndex == -1) {
      return;
    }

    if (DateTime.parse(vl.created_at).millisecondsSinceEpoch >
        _latestCreatedAtMillis) {
      emit(const FetcherVisitorLogsLoading());
      vl.setup();
      _latestCreatedAtMillis =
          DateTime.parse(vl.created_at).millisecondsSinceEpoch;
      visitorTypes[visitorTypeIndex].data.insert(0, vl);
      emit(VisitorLogsLoaded(visitorTypes[visitorTypeIndex]));
    }
  }

  _initFireUpdates() async {
    guardProfile ??= await LocalDataLayer().getGuardProfileMe();
    _changedStreamSubscription ??= FirebaseDatabase.instance
        .ref()
        .child(Constants.refBase)
        .child("project")
        .child("${guardProfile!.project_id}")
        .child("visitor_log")
        .onChildChanged
        .listen((DatabaseEvent event) => _handleFireChangedEvent(event));
  }

  _handleFireChangedEvent(DatabaseEvent event) {
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      try {
        if (((event.snapshot.value as Map)["status"] == "approved" ||
                (event.snapshot.value as Map)["status"] == "rejected") &&
            (event.snapshot.value as Map)["project_id"] ==
                guardProfile!.project_id) {
          try {
            VisitorLog visitorLog = VisitorLog.fromJson(
                jsonDecode(jsonEncode(event.snapshot.value)));
            int visitorTypeIndex =
                visitorTypes.indexWhere((element) => element.type == "waiting");
            if (visitorTypeIndex != -1) {
              emit(const FetcherVisitorLogsLoading());
              visitorLog.setup();

              int indexExisting =
                  visitorTypes[visitorTypeIndex].data.indexOf(visitorLog);
              if (visitorLog.status == "rejected") {
                visitorTypes[visitorTypeIndex].data.removeAt(indexExisting);
              } else {
                if (indexExisting == -1) {
                  visitorTypes[visitorTypeIndex].data.insert(0, visitorLog);
                } else {
                  visitorTypes[visitorTypeIndex].data[indexExisting] =
                      visitorLog;
                }
              }
              emit(VisitorLogsLoaded(visitorTypes[visitorTypeIndex]));
            }
          } catch (e) {
            if (kDebugMode) {
              print("handleFireChangedEvent: $e");
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("handleFireChangedEvent-initialFail: $e");
        }
      }
    }
  }
}
