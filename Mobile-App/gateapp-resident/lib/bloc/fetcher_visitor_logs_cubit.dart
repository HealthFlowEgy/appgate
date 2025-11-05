import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gateapp_user/models/base_list_response.dart';
import 'package:gateapp_user/models/remote_response_type.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/models/visitor_log.dart';
import 'package:gateapp_user/models/visitor_log_update_request.dart';
import 'package:gateapp_user/network/remote_repository.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';

part 'fetcher_visitor_logs_state.dart';

class FetcherVisitorLogsCubit extends Cubit<FetcherVisitorLogsState> {
  final List<RemoteResponseType<VisitorLog>> visitorTypes = [
    RemoteResponseType<VisitorLog>("waiting"),
    RemoteResponseType<VisitorLog>("inside")
  ];
  ResidentProfile? residentProfile;
  StreamSubscription<DatabaseEvent>? _addedStreamSubscription,
      _changedStreamSubscription;
  int _latestCreatedAtMillis = -1;
  List<RemoteResponseType<VisitorLog>> get getVisitorTypes => visitorTypes;

  FetcherVisitorLogsCubit() : super(const FetcherVisitorLogsInitial());

  @override
  Future<void> close() async {
    await _addedStreamSubscription?.cancel();
    await _changedStreamSubscription?.cancel();
    return super.close();
  }

  int initGetVisitorLogsCount({required String status}) {
    int visitorTypeIndex =
        visitorTypes.indexWhere((element) => element.type == status);
    return visitorTypeIndex == -1
        ? 0
        : visitorTypes[visitorTypeIndex]
            .data
            .where((element) => element.status == status)
            .length;
  }

  Future<void> initFetchVisitorLogs(
      {required String tabType, bool? paginate, bool? refresh}) async {
    int visitorTypeIndex =
        visitorTypes.indexWhere((element) => element.type == tabType);
    if (visitorTypeIndex == -1) return;
    if (refresh ?? false) visitorTypes[visitorTypeIndex].reset();
    if (visitorTypes[visitorTypeIndex].allDone ||
        visitorTypes[visitorTypeIndex].isLoading) return;

    residentProfile ??= await LocalDataLayer().getResidentProfileMe();
    visitorTypes[visitorTypeIndex].isLoading = true;
    emit(const FetcherVisitorLogsLoading());
    try {
      BaseListResponse<VisitorLog> baseListResponse =
          await RemoteRepository().getVisitorLogs(
        buildingId: residentProfile!.flat_id!,
        pageNo: (visitorTypes[visitorTypeIndex].page +
            ((paginate ?? false) ? 1 : 0)),
        status: visitorTypes[visitorTypeIndex].type,
      );
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

  Future<void> initUpdateVisitorLog(String tabType, int visitorLogId,
      VisitorLogUpdateRequest visitorLogUpdateRequest) async {
    emit(VisitorLogUpdateLoading(tabType, visitorLogId));
    try {
      VisitorLog visitorLog = await RemoteRepository()
          .updateVisitorLog(visitorLogId, visitorLogUpdateRequest);
      int indexWaitingTab =
          visitorTypes.indexWhere((element) => element.type == tabType);
      if (indexWaitingTab == -1) {
        indexWaitingTab = 0;
      }
      visitorTypes[indexWaitingTab]
          .data
          .removeWhere((element) => element.id == visitorLog.id);
      emit(VisitorLogsLoaded(visitorTypes[indexWaitingTab]));
      _addVisitorLogToFirebase(visitorLog);
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateVisitorLog: $e");
      }
      emit(VisitorLogUpdateFail(
          "Something went wrong", "something_wrong", tabType));
    }
  }

  _initFireUpdates() async {
    residentProfile ??= await LocalDataLayer().getResidentProfileMe();
    _addedStreamSubscription ??= FirebaseDatabase.instance
        .ref()
        .child(Constants.refBase)
        .child("flat")
        .child("${residentProfile!.flat_id}")
        .child("visitor_log")
        .onChildAdded
        .listen((DatabaseEvent event) => _handleFireAddedEvent(event));
    _changedStreamSubscription ??= FirebaseDatabase.instance
        .ref()
        .child(Constants.refBase)
        .child("flat")
        .child("${residentProfile!.flat_id}")
        .child("visitor_log")
        .onChildChanged
        .listen((DatabaseEvent event) => _handleFireChangedEvent(event));
  }

  _handleFireAddedEvent(DatabaseEvent event) {
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      try {
        if ((event.snapshot.value as Map)["flat_id"] ==
                residentProfile!.flat_id &&
            (event.snapshot.value as Map)["status"] == "waiting" &&
            DateTime.parse((event.snapshot.value as Map)["created_at"])
                    .millisecondsSinceEpoch >
                _latestCreatedAtMillis) {
          try {
            VisitorLog visitorLog = VisitorLog.fromJson(
                jsonDecode(jsonEncode(event.snapshot.value)));
            int visitorTypeIndex =
                visitorTypes.indexWhere((element) => element.type == "waiting");
            if (visitorTypeIndex != -1) {
              emit(const FetcherVisitorLogsLoading());
              visitorLog.setup();
              _latestCreatedAtMillis =
                  DateTime.parse(visitorLog.created_at).millisecondsSinceEpoch;
              visitorTypes[visitorTypeIndex].data.insert(0, visitorLog);
              emit(VisitorLogsLoaded(visitorTypes[visitorTypeIndex]));
            }
          } catch (e) {
            if (kDebugMode) {
              print("handleFireAddedEvent: $e");
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("handleFireAddedEvent-initialFail: $e");
        }
      }
    }
  }

  _handleFireChangedEvent(DatabaseEvent event) {
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      try {
        if ((event.snapshot.value as Map)["flat_id"] ==
            residentProfile!.flat_id) {
          try {
            VisitorLog visitorLog = VisitorLog.fromJson(
                jsonDecode(jsonEncode(event.snapshot.value)));
            visitorLog.setup();
            emit(VisitorLogUpdateLoaded(visitorLog));
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
}
