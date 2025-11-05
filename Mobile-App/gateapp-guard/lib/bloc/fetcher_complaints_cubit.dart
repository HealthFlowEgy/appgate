import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/models/base_list_response.dart';
import 'package:gateapp_guard/models/complaint.dart';
import 'package:gateapp_guard/models/guard_profile.dart';
import 'package:gateapp_guard/models/remote_response_type.dart';
import 'package:gateapp_guard/network/remote_repository.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';

part 'fetcher_complaints_state.dart';

class FetcherComplaintsCubit extends Cubit<FetcherComplaintsState> {
  final RemoteRepository _repository = RemoteRepository();
  RemoteResponseType<Complaint> complaints =
      RemoteResponseType<Complaint>(Constants.complaintTypeMessageGuard);
  GuardProfile? guardProfile;
  StreamSubscription<DatabaseEvent>? _addedStreamSubscription,
      _changedStreamSubscription;
  int _latestCreatedAtMillis = -1;

  FetcherComplaintsCubit() : super(const FetcherComplaintsInitial());

  Future<void> initFetchComplaints({bool? paginate, bool? refresh}) async {
    if (refresh ?? false) complaints.reset();
    if (complaints.isLoading || complaints.allDone) return;
    try {
      guardProfile ??= await LocalDataLayer().getGuardProfileMe();
      complaints.isLoading = true;
      emit(const ComplaintsLoading());
      BaseListResponse<Complaint> baseListResponse =
          await _repository.getComplaints(
              guardProfile?.project_id,
              Constants.complaintTypeMessageGuard,
              (complaints.page + ((paginate ?? false) ? 1 : 0)));
      for (Complaint complaint in baseListResponse.data) {
        complaint.setup();
      }
      if (baseListResponse.data.isNotEmpty &&
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

      complaints.page = baseListResponse.meta.current_page ?? 1;
      complaints.allDone =
          baseListResponse.meta.current_page == baseListResponse.meta.last_page;
      if (complaints.page == 1) {
        complaints.data.clear();
      }
      complaints.data.addAll(baseListResponse.data);
      complaints.isLoading = false;
      emit(ComplaintsLoaded(complaints));
      _initFireUpdates();
    } catch (e) {
      if (kDebugMode) {
        print("initFetchComplaints: $e");
      }
      complaints.isLoading = false;
      emit(ComplaintsFail("Something went wrong", "something_wrong"));
    }
  }

  void _initFireUpdates() async {
    guardProfile ??= await LocalDataLayer().getGuardProfileMe();
    _addedStreamSubscription ??= FirebaseDatabase.instance
        .ref()
        .child(Constants.refBase)
        .child("project")
        .child("${guardProfile!.project_id}")
        .child("complaint")
        .onChildAdded
        .listen((DatabaseEvent event) => _handleFireAddedEvent(event));
    _changedStreamSubscription ??= FirebaseDatabase.instance
        .ref()
        .child(Constants.refBase)
        .child("project")
        .child("${guardProfile!.project_id}")
        .child("complaint")
        .onChildChanged
        .listen((DatabaseEvent event) => _handleFireChangedEvent(event));
  }

  _handleFireAddedEvent(DatabaseEvent event) {
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      try {
        if ((event.snapshot.value as Map)["type"] ==
                Constants.complaintTypeMessageGuard &&
            (event.snapshot.value as Map)["project_id"] ==
                guardProfile!.project_id &&
            DateTime.parse((event.snapshot.value as Map)["created_at"])
                    .millisecondsSinceEpoch >
                _latestCreatedAtMillis) {
          try {
            Complaint complaint = Complaint.fromJson(
                jsonDecode(jsonEncode(event.snapshot.value)));
            complaints.isLoading = true;
            emit(const ComplaintsLoading());
            complaint.setup();
            _latestCreatedAtMillis =
                DateTime.parse(complaint.created_at).millisecondsSinceEpoch;
            complaints.data.insert(0, complaint);
            complaints.isLoading = false;
            emit(ComplaintsLoaded(complaints));
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

  _handleFireChangedEvent(DatabaseEvent event) {
    if (event.snapshot.value != null && event.snapshot.value is Map) {
      try {
        if ((event.snapshot.value as Map)["type"] ==
                Constants.complaintTypeMessageGuard &&
            (event.snapshot.value as Map)["project_id"] ==
                guardProfile!.project_id) {
          try {
            Complaint complaint = Complaint.fromJson(
                jsonDecode(jsonEncode(event.snapshot.value)));

            int indexExisting = complaints.data.indexOf(complaint);
            if (indexExisting != -1) {
              complaints.isLoading = true;
              emit(const ComplaintsLoading());
              complaint.setup();
              complaints.data[indexExisting] = complaint;
              complaints.isLoading = false;
              emit(ComplaintsLoaded(complaints));
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
