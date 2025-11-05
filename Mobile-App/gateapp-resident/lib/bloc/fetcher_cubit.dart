import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/models/amenity.dart';
import 'package:gateapp_user/models/amenity_appointment.dart';
import 'package:gateapp_user/models/amenity_appointment_update_request.dart';
import 'package:gateapp_user/models/announcement.dart';
import 'package:gateapp_user/models/base_list_response.dart';
import 'package:gateapp_user/models/comment_data.dart';
import 'package:gateapp_user/models/complaint.dart';
import 'package:gateapp_user/models/complaint_request.dart';
import 'package:gateapp_user/models/complaint_update_request.dart';
import 'package:gateapp_user/models/flat_residents.dart';
import 'package:gateapp_user/models/media_data.dart';
import 'package:gateapp_user/models/payment_request.dart';
import 'package:gateapp_user/models/post_request.dart';
import 'package:gateapp_user/models/resident_building.dart';
import 'package:gateapp_user/models/resident_flat.dart';
import 'package:gateapp_user/models/category.dart' as my_cat;
//import 'package:gateapp_user/models/payment_method.dart' as my_payment_method;

import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/models/resident_profile_update_request.dart';
import 'package:gateapp_user/models/resident_project.dart';
import 'package:gateapp_user/models/service_booking.dart';
import 'package:gateapp_user/models/service_booking_request.dart';
import 'package:gateapp_user/models/support_request.dart';
import 'package:gateapp_user/models/update_user_request.dart';
import 'package:gateapp_user/models/user_data.dart';
import 'package:gateapp_user/models/user_notification.dart';
import 'package:gateapp_user/models/visitor_log.dart';
import 'package:gateapp_user/models/visitor_log_request.dart';
import 'package:gateapp_user/network/remote_repository.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';

import 'payment_cubit.dart';

part 'fetcher_state.dart';

class FetcherCubit extends Cubit<FetcherState> {
  final RemoteRepository _repository = RemoteRepository();

  FetcherCubit() : super(const FetcherInitial());

  initFetchProfileMe({bool forceFresh = false}) async {
    emit(const ResidentProfileLoading());
    try {
      ResidentProfile? residentProfileMe;
      if (!forceFresh) {
        residentProfileMe = await LocalDataLayer().getResidentProfileMe();
      }
      if (residentProfileMe == null) {
        if (kDebugMode) {
          print("initFetchProfileMe: Fetching Fresh");
        }
        residentProfileMe = await _repository.getResidentProfileMe();
        await LocalDataLayer().setResidentProfileMe(residentProfileMe);
      }
      emit(ResidentProfileLoaded(residentProfileMe));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchProfileMe: $e");
      }
      emit(ResidentProfileFail("Something went wrong", "something_wrong"));
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

  initUpdateResidentProfile(
      ResidentProfileUpdateRequest residentProfileUpdateRequest) async {
    emit(const ResidentProfileUpdateLoading());
    try {
      ResidentProfile residentProfile =
          await _repository.updateResidentProfile(residentProfileUpdateRequest);
      await LocalDataLayer().setResidentProfileMe(residentProfile);
      emit(ResidentProfileUpdateLoaded(residentProfile));
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateResidentProfile: $e");
      }
      emit(
          ResidentProfileUpdateFail("Something went wrong", "something_wrong"));
    }
  }

  Future<void> initFetchResidents(int pageNo) async {
    emit(const ResidentsLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      BaseListResponse<FlatResidents> baseListResponse =
          await _repository.getResidents(residentProfile!.project_id!, pageNo);
      baseListResponse.data.removeWhere((element) => element.residents == null);
      for (FlatResidents fr in baseListResponse.data) {
        fr.residents!.removeWhere(
            (element) => element.user_id == residentProfile.user_id);
      }
      baseListResponse.data
          .removeWhere((element) => element.residents!.isEmpty);
      for (FlatResidents fr in baseListResponse.data) {
        for (ResidentProfile rp in fr.residents!) {
          rp.setup();
        }
      }
      emit(ResidentsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchResidents: $e");
      }
      emit(ResidentsFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchVisitorLogs(
      {int? pageNo, String? status, String? type, String? code}) async {
    emit(const VisitorLogsLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      BaseListResponse<VisitorLog> baseListResponse =
          await _repository.getVisitorLogs(
              flatId: residentProfile!.flat_id,
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

  initCreateVisitorLog(VisitorLogRequest visitorLogRequest) async {
    emit(const CreateVisitorLogLoading());
    try {
      VisitorLog visitorLog =
          await _repository.createVisitorLog(visitorLogRequest);
      emit(CreateVisitorLogLoaded(visitorLog));
    } catch (e) {
      if (kDebugMode) {
        print("initCreateVisitorLog: $e");
      }
      emit(CreateVisitorLogFail("Something went wrong", "something_wrong"));
    }
  }

  initDeleteVisitorLog(int visitorLogId, String? type) async {
    emit(const DeleteVisitorLogLoading());
    try {
      await _repository.deleteVisitorLog(visitorLogId);
      emit(DeleteVisitorLogLoaded(visitorLogId, type));
    } catch (e) {
      if (kDebugMode) {
        print("initDeleteVisitorLog: $e");
      }
      emit(DeleteVisitorLogFail("Something went wrong", "something_wrong"));
    }
  }

  initCreateComplaint(ComplaintRequest complaintRequest) async {
    emit(const CreateUpdateComplaintLoading());
    try {
      Complaint complaint = await _repository.createComplaint(complaintRequest);
      complaint.setup();
      emit(CreateUpdateComplaintLoaded(complaint));
      _addComplaintToFirebase(complaint);
    } catch (e) {
      if (kDebugMode) {
        print("initCreateComplaint: $e");
      }
      emit(
          CreateUpdateComplaintFail("Something went wrong", "something_wrong"));
    }
  }

  initUpdateComplaint(
      int complaintId, ComplaintUpdateRequest complaintUpdateRequest) async {
    emit(const CreateUpdateComplaintLoading());
    try {
      Complaint complaint = await _repository.updateComplaint(
          complaintId, complaintUpdateRequest);
      complaint.setup();
      emit(CreateUpdateComplaintLoaded(complaint));
      _addComplaintToFirebase(complaint);
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateComplaint: $e");
      }
      emit(
          CreateUpdateComplaintFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchComplaints(int pageNo) async {
    emit(const ComplaintsLoading());
    try {
      BaseListResponse<Complaint> baseListResponse =
          await _repository.getComplaints(pageNo);
      for (Complaint complaint in baseListResponse.data) {
        complaint.setup();
      }
      emit(ComplaintsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchComplaints: $e");
      }
      emit(ComplaintsFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchCategoriesWithScope(String scope) async {
    emit(const CategoriesLoading());
    try {
      List<my_cat.Category> categories =
          await _repository.getCategoriesWithScope(scope);
      for (my_cat.Category cat in categories) {
        cat.setup();
      }
      emit(CategoriesLoaded(categories));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchCategoriesWithScope: $e");
      }
      emit(CategoriesFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchAmenities() async {
    emit(const AmenitiesLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      List<Amenity> amenities =
          await _repository.getAmenities(residentProfile!.project_id!);
      for (Amenity amenity in amenities) {
        amenity.setup();
      }
      emit(AmenitiesLoaded(amenities));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchAmenities: $e");
      }
      emit(AmenitiesFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchAmenityAppointments(int pageNo) async {
    emit(const AmenityAppointmentsLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      BaseListResponse<AmenityAppointment> baseListResponse =
          await _repository.getAmenityAppointments(residentProfile!.id, pageNo);
      baseListResponse.data.removeWhere((element) =>
          (element.resident == null ||
              element.amenity == null ||
              element.payment == null));
      for (AmenityAppointment amenityAppointment in baseListResponse.data) {
        amenityAppointment.setup();
      }
      emit(AmenityAppointmentsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchAmenityAppointments: $e");
      }
      emit(AmenityAppointmentsFail("Something went wrong", "something_wrong"));
    }
  }

  initUpdateAmenityAppointment(int amenityAppointmentId,
      AmenityAppointmentUpdateRequest amenityAppointmentUpdateRequest) async {
    emit(const CreateUpdateAmenityAppointmentLoading());
    try {
      AmenityAppointment amenityAppointment =
          await _repository.updateAmenityAppointment(
              amenityAppointmentId, amenityAppointmentUpdateRequest);
      amenityAppointment.setup();
      emit(CreateUpdateAmenityAppointmentLoaded(amenityAppointment, null));
    } catch (e) {
      if (kDebugMode) {
        print("initUpdateAmenityAppointment: $e");
      }
      emit(CreateUpdateAmenityAppointmentFail(
          "Something went wrong", "something_wrong"));
    }
  }

  initUpdateUserMe(String? name, String? imageUrl) async {
    emit(const UserMeUpdating());
    try {
      UserData? updatedUser = await _repository
          .updateUser(UpdateUserRequest(name, imageUrl).toJson());
      if (updatedUser != null) {
        await LocalDataLayer().setUserMe(updatedUser);

        ResidentProfile? residentProfile =
            await LocalDataLayer().getResidentProfileMe();
        if (residentProfile != null) {
          residentProfile.user = updatedUser;
          residentProfile.user_id = updatedUser.id;
          await LocalDataLayer().setResidentProfileMe(residentProfile);
        }
        emit(UserMeLoaded(updatedUser, residentProfile));
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
          SupportRequest(userData!.name, userData.email, supportMsg));
      emit(const SupportLoaded());
    } catch (e) {
      if (kDebugMode) {
        print("initSupportSubmit: $e");
      }
      emit(SupportLoadFail("Something went wrong", "something_wrong"));
    }
  }

  Future<void> initFetchPosts(bool minePosts, int pageNo) async {
    emit(const PostsLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      BaseListResponse<MediaData> baseListResponse = await _repository.getPosts(
        projectId: residentProfile!.project_id!,
        pageNo: pageNo,
        userId: minePosts ? residentProfile.user_id : null,
      );

      for (MediaData md in baseListResponse.data) {
        md.setup();
      }
      emit(PostsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchPosts: $e");
      }
      emit(PostsFail("Something went wrong", "something_wrong"));
    }
  }

  initCreatePost(PostRequest postRequest) async {
    emit(const PostCreateLoading());
    try {
      MediaData mediaData = await _repository.createPost(postRequest);
      mediaData.setup();
      emit(PostCreateLoaded(mediaData));
    } catch (e) {
      if (kDebugMode) {
        print("initCreatePost: $e");
      }
      emit(PostCreateFail("Something went wrong", "something_wrong"));
    }
  }

  initTogglePostLike(int postId) async {
    emit(PostLikeToggleLoading(postId));
    try {
      await _repository.togglePostLike(postId);
      emit(PostLikeToggleLoaded(postId));
    } catch (e) {
      if (kDebugMode) {
        print("initTogglePostLike: $e");
      }
      emit(PostLikeToggleFail(
          "Something went wrong", "something_wrong", postId));
    }
  }

  Future<void> initFetchPostComments(int postId, int pageNo) async {
    emit(const PostCommentsLoading());
    try {
      BaseListResponse<CommentData> baseListResponse =
          await _repository.getPostComments(postId, pageNo);
      for (CommentData cd in baseListResponse.data) {
        cd.setup();
      }
      emit(PostCommentsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchPostComments: $e");
      }
      emit(PostCommentsFail("Something went wrong", "something_wrong"));
    }
  }

  initCreatePostComment(int postId, String comment) async {
    emit(const PostCommentCreateLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      CommentData commentData = await _repository.createPostComment(postId, {
        "comment": comment,
        "meta": jsonEncode({
          "project_id": residentProfile?.project_id,
          "flat_id": residentProfile?.flat_id,
          "flat_title": residentProfile?.flat?.title,
        })
      });
      commentData.setup();
      emit(PostCommentCreateLoaded(commentData));
    } catch (e) {
      if (kDebugMode) {
        print("initCreatePostComment: $e");
      }
      emit(PostCommentCreateFail("Something went wrong", "something_wrong"));
    }
  }

  Future<void> initFetchServiceBookings(int pageNo) async {
    emit(const ServiceBookingsLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      BaseListResponse<ServiceBooking> baseListResponse = await _repository
          .getServiceBookings(residentProfile!.flat_id!, pageNo);
      for (ServiceBooking sb in baseListResponse.data) {
        sb.setup();
      }
      emit(ServiceBookingsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchServiceBookings: $e");
      }
      emit(ServiceBookingsFail("Something went wrong", "something_wrong"));
    }
  }

  initCreateServiceBooking(ServiceBookingRequest serviceBookingRequest) async {
    emit(const ServiceBookingCreateLoading());
    try {
      ServiceBooking serviceBooking =
          await _repository.createServiceBooking(serviceBookingRequest);
      serviceBooking.setup();
      emit(ServiceBookingCreateLoaded(serviceBooking));
    } catch (e) {
      if (kDebugMode) {
        print("initCreateServiceBooking: $e");
      }
      emit(ServiceBookingCreateFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchPaymentRequests(int pageNo) async {
    emit(const PaymentRequestsLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      BaseListResponse<PaymentRequest> baseListResponse = await _repository
          .getPaymentRequests(residentProfile!.flat_id!, pageNo);
      for (PaymentRequest pr in baseListResponse.data) {
        pr.setup();
      }
      emit(PaymentRequestsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchPaymentRequests: $e");
      }
      emit(PaymentRequestsFail("Something went wrong", "something_wrong"));
    }
  }

  initFetchAnnouncements(int pageNo) async {
    emit(const AnnouncementsLoading());
    try {
      ResidentProfile? residentProfile =
          await LocalDataLayer().getResidentProfileMe();
      BaseListResponse<Announcement> baseListResponse = await _repository
          .getAnnouncements(residentProfile!.project_id!, pageNo);
      for (Announcement a in baseListResponse.data) {
        a.setup();
      }
      emit(AnnouncementsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchAnnouncements: $e");
      }
      emit(AnnouncementsFail("Something went wrong", "something_wrong"));
    }
  }

  initToggleAnnouncementLike(int announcementId) async {
    emit(AnnouncementLikeToggleLoading(announcementId));
    try {
      await _repository.toggleAnnouncementLike(announcementId);
      emit(AnnouncementLikeToggleLoaded(announcementId));
    } catch (e) {
      if (kDebugMode) {
        print("initToggleAnnouncementLike: $e");
      }
      emit(AnnouncementLikeToggleFail(
          "Something went wrong", "something_wrong", announcementId));
    }
  }

  initSubmitAnnouncementPoll(int announcementId, int optionId) async {
    emit(SubmitAnnouncementPollLoading(announcementId));
    try {
      Announcement announcement =
          await _repository.postAnnouncementPoll(announcementId, optionId);
      announcement.setup();
      emit(SubmitAnnouncementPollLoaded(announcement));
    } catch (e) {
      if (kDebugMode) {
        print("initSubmitAnnouncementPoll: $e");
      }
      emit(SubmitAnnouncementPollFail(
          "Something went wrong", "something_wrong", announcementId));
    }
  }

  initFetchUserNotifications(int pageNo,
      {bool isUpcoming = false, bool isPast = false}) async {
    emit(const UserNotificationsLoading());
    try {
      BaseListResponse<UserNotification> baseListResponse = await _repository
          .getUserNotifications(pageNo, isUpcoming: isUpcoming, isPast: isPast);
      for (UserNotification userNotification in baseListResponse.data) {
        userNotification.setup();
      }
      emit(UserNotificationsLoaded(baseListResponse));
    } catch (e) {
      if (kDebugMode) {
        print("initFetchUserNotifications: $e");
      }
      emit(UserNotificationsFail("Something went wrong", "something_wrong"));
    }
  }

  _addComplaintToFirebase(Complaint complaint) {
    try {
      var cr = jsonDecode(jsonEncode(complaint));
      FirebaseDatabase.instance
          .ref()
          .child(Constants.refBase)
          .child("flat")
          .child("${complaint.flat_id}")
          .child("complaint")
          .child("${complaint.id}")
          .set(cr);
      FirebaseDatabase.instance
          .ref()
          .child(Constants.refBase)
          .child("project")
          .child("${complaint.project_id}")
          .child("complaint")
          .child("${complaint.id}")
          .set(cr);
    } catch (e) {
      if (kDebugMode) {
        print("addVisitorLogToFirebase: $e");
      }
    }
  }
}
