import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gateapp_guard/models/base_list_response.dart';
import 'package:gateapp_guard/models/guard_profile.dart';
import 'package:gateapp_guard/models/resident_building.dart';
import 'package:gateapp_guard/models/resident_flat.dart';
import 'package:gateapp_guard/models/resident_project.dart';
import 'package:gateapp_guard/models/support_request.dart';
import 'package:gateapp_guard/models/update_user_request.dart';
import 'package:gateapp_guard/models/user_data.dart';
import 'package:gateapp_guard/models/visitor_log.dart';
import 'package:gateapp_guard/network/remote_repository.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';

part 'fetcher_state.dart';

class FetcherCubit extends Cubit<FetcherState> {
  final RemoteRepository _repository = RemoteRepository();

  FetcherCubit() : super(const FetcherInitial());

  initUpdateUserMe(String? name, String? imageUrl) async {
    emit(const UserMeUpdating());
    try {
      UserData? updatedUser = await _repository
          .updateUser(UpdateUserRequest(name, imageUrl).toJson());
      if (updatedUser != null) {
        await LocalDataLayer().setUserMe(updatedUser);

        GuardProfile? guardProfile = await LocalDataLayer().getGuardProfileMe();
        if (guardProfile != null) {
          guardProfile.user = updatedUser;
          guardProfile.user_id = updatedUser.id;
          await LocalDataLayer().setGuardProfileMe(guardProfile);
        }
        emit(UserMeLoaded(updatedUser, guardProfile));
      } else {
        emit(UserMeError("Something went wrong", "something_wrong"));
      }
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateUserMe: $e");
      }
      emit(UserMeError("Something went wrong", "something_wrong"));
    }
  }

  initSupportSubmit(String supportMsg) async {
    emit(const SupportLoading());
    try {
      UserData? userData = await LocalDataLayer().getUserMe();
      await _repository.postSupport(
          SupportRequest(userData!.name, userData.email!, supportMsg));
      emit(const SupportLoaded());
    } catch (e) {
      if (kDebugMode) {
        print("initSupportSubmit: $e");
      }
      emit(SupportLoadFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchResidentProjects() async {
    emit(const ResidentProjectsLoading());
    try {
      List<ResidentProject> residentProjects =
          await _repository.getResidentProjects();
      emit(ResidentProjectsLoaded(residentProjects));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchResidentProjects: $e");
      }
      emit(ResidentProjectsFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchResidentBuildings(int projectId) async {
    emit(const ResidentBuildingsLoading());
    try {
      List<ResidentBuilding> residentBuildings =
          await _repository.getResidentBuildings(projectId);
      emit(ResidentBuildingsLoaded(residentBuildings));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchResidentBuildings: $e");
      }
      emit(ResidentBuildingsFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchResidentFlats(int buildingId) async {
    emit(const ResidentFlatsLoading());
    try {
      List<ResidentFlat> residentFlats =
          await _repository.getResidentFlats(buildingId);
      emit(ResidentFlatsLoaded(residentFlats));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchResidentFlats: $e");
      }
      emit(ResidentFlatsFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchVisitorLogs(
      {int? projectId,
      int? buildingId,
      int? flatId,
      int? pageNo,
      String? status,
      String? type,
      String? code}) async {
    emit(const VisitorLogsLoading());
    try {
      BaseListResponse<VisitorLog> baseListResponse =
          await _repository.getVisitorLogs(
              projectId: projectId,
              buildingId: buildingId,
              pageNo: pageNo,
              status: status,
              type: type,
              code: code);
      emit(VisitorLogsLoaded(
          visitorLogs: baseListResponse,
          status: status,
          type: type,
          code: code));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchVisitorLogs: $e");
      }
      emit(VisitorLogsFail("Something went wrong", "something_wrong", type));
    }
  }
}
