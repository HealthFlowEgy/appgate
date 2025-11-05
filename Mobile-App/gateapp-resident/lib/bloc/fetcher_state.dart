part of 'fetcher_cubit.dart';

/// USERNOTIFICATIONSLIST STATES START
class UserNotificationsLoading extends FetcherLoading {
  const UserNotificationsLoading();
}

class UserNotificationsLoaded extends FetcherLoaded {
  final BaseListResponse<UserNotification> notificationssResponse;
  const UserNotificationsLoaded(this.notificationssResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserNotificationsLoaded &&
        other.notificationssResponse == notificationssResponse;
  }

  @override
  int get hashCode => notificationssResponse.hashCode;
}

class UserNotificationsFail extends FetcherFail {
  UserNotificationsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// USERNOTIFICATIONSLIST STATES END

/// SubmitAnnouncementPOLL STATES START
class SubmitAnnouncementPollLoading extends FetcherLoading {
  final int announcementId;
  const SubmitAnnouncementPollLoading(this.announcementId);
}

class SubmitAnnouncementPollLoaded extends FetcherLoaded {
  final Announcement announcement;
  const SubmitAnnouncementPollLoaded(this.announcement);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubmitAnnouncementPollLoaded &&
        other.announcement == announcement;
  }

  @override
  int get hashCode => announcement.hashCode;
}

class SubmitAnnouncementPollFail extends FetcherFail {
  final int announcementId;
  SubmitAnnouncementPollFail(
      String message, String messageKey, this.announcementId)
      : super(message, messageKey);
}

/// SubmitAnnouncementPOLL STATES END

/// ANNOUNCEMENTLIKETOGGLE STATES START
class AnnouncementLikeToggleLoading extends FetcherLoading {
  final int announcementId;
  const AnnouncementLikeToggleLoading(this.announcementId);
}

class AnnouncementLikeToggleLoaded extends FetcherLoaded {
  final int announcementId;
  const AnnouncementLikeToggleLoaded(this.announcementId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnouncementLikeToggleLoaded &&
        other.announcementId == announcementId;
  }

  @override
  int get hashCode => announcementId.hashCode;
}

class AnnouncementLikeToggleFail extends FetcherFail {
  final int announcementId;
  AnnouncementLikeToggleFail(
      String message, String messageKey, this.announcementId)
      : super(message, messageKey);
}

/// ANNOUNCEMENTLIKETOGGLE STATES END

/// ANNOUNCEMENTLIST STATES START
class AnnouncementsLoading extends FetcherLoading {
  const AnnouncementsLoading();
}

class AnnouncementsLoaded extends FetcherLoaded {
  final BaseListResponse<Announcement> announcementsResponse;
  const AnnouncementsLoaded(this.announcementsResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnnouncementsLoaded &&
        other.announcementsResponse == announcementsResponse;
  }

  @override
  int get hashCode => announcementsResponse.hashCode;
}

class AnnouncementsFail extends FetcherFail {
  AnnouncementsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// ANNOUNCEMENTLIST STATES END

/// PAYMENTREQUESTSLIST STATES START
class PaymentRequestsLoading extends FetcherLoading {
  const PaymentRequestsLoading();
}

class PaymentRequestsLoaded extends FetcherLoaded {
  final BaseListResponse<PaymentRequest> paymentRequestsResponse;
  const PaymentRequestsLoaded(this.paymentRequestsResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentRequestsLoaded &&
        other.paymentRequestsResponse == paymentRequestsResponse;
  }

  @override
  int get hashCode => paymentRequestsResponse.hashCode;
}

class PaymentRequestsFail extends FetcherFail {
  PaymentRequestsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// PAYMENTREQUESTSLIST STATES END

/// SERVICEBOOKINGCREATE STATES START
class ServiceBookingCreateLoading extends FetcherLoading {
  const ServiceBookingCreateLoading();
}

class ServiceBookingCreateLoaded extends FetcherLoaded {
  final ServiceBooking serviceBooking;
  const ServiceBookingCreateLoaded(this.serviceBooking);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceBookingCreateLoaded &&
        other.serviceBooking == serviceBooking;
  }

  @override
  int get hashCode => serviceBooking.hashCode;
}

class ServiceBookingCreateFail extends FetcherFail {
  ServiceBookingCreateFail(String message, String messageKey)
      : super(message, messageKey);
}

/// SERVICEBOOKINGCREATE STATES END

/// SERVICEBOOKINGLIST STATES START
class ServiceBookingsLoading extends FetcherLoading {
  const ServiceBookingsLoading();
}

class ServiceBookingsLoaded extends FetcherLoaded {
  final BaseListResponse<ServiceBooking> serviceBookingsResponse;
  const ServiceBookingsLoaded(this.serviceBookingsResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceBookingsLoaded &&
        other.serviceBookingsResponse == serviceBookingsResponse;
  }

  @override
  int get hashCode => serviceBookingsResponse.hashCode;
}

class ServiceBookingsFail extends FetcherFail {
  ServiceBookingsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// SERVICEBOOKINGLIST STATES END

/// POSTCOMMENTCREATE STATES START
class PostCommentCreateLoading extends FetcherLoading {
  const PostCommentCreateLoading();
}

class PostCommentCreateLoaded extends FetcherLoaded {
  final CommentData comment;
  const PostCommentCreateLoaded(this.comment);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostCommentCreateLoaded && other.comment == comment;
  }

  @override
  int get hashCode => comment.hashCode;
}

class PostCommentCreateFail extends FetcherFail {
  PostCommentCreateFail(String message, String messageKey)
      : super(message, messageKey);
}

/// POSTCOMMENTCREATE STATES END

/// POSTCOMMENTSLIST STATES START
class PostCommentsLoading extends FetcherLoading {
  const PostCommentsLoading();
}

class PostCommentsLoaded extends FetcherLoaded {
  final BaseListResponse<CommentData> commentsResponse;
  const PostCommentsLoaded(this.commentsResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostCommentsLoaded &&
        other.commentsResponse == commentsResponse;
  }

  @override
  int get hashCode => commentsResponse.hashCode;
}

class PostCommentsFail extends FetcherFail {
  PostCommentsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// POSTCOMMENTSLIST STATES END

/// POSTLIKETOGGLE STATES START
class PostLikeToggleLoading extends FetcherLoading {
  final int postId;
  const PostLikeToggleLoading(this.postId);
}

class PostLikeToggleLoaded extends FetcherLoaded {
  final int postId;
  const PostLikeToggleLoaded(this.postId);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostLikeToggleLoaded && other.postId == postId;
  }

  @override
  int get hashCode => postId.hashCode;
}

class PostLikeToggleFail extends FetcherFail {
  final int postId;
  PostLikeToggleFail(String message, String messageKey, this.postId)
      : super(message, messageKey);
}

/// POSTLIKETOGGLE STATES END

/// POSTSCREATE STATES START
class PostCreateLoading extends FetcherLoading {
  const PostCreateLoading();
}

class PostCreateLoaded extends FetcherLoaded {
  final MediaData post;
  const PostCreateLoaded(this.post);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostCreateLoaded && other.post == post;
  }

  @override
  int get hashCode => post.hashCode;
}

class PostCreateFail extends FetcherFail {
  PostCreateFail(String message, String messageKey)
      : super(message, messageKey);
}

/// POSTSCREATE STATES END

/// POSTSLIST STATES START
class PostsLoading extends FetcherLoading {
  const PostsLoading();
}

class PostsLoaded extends FetcherLoaded {
  final BaseListResponse<MediaData> postsResponse;
  const PostsLoaded(this.postsResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostsLoaded && other.postsResponse == postsResponse;
  }

  @override
  int get hashCode => postsResponse.hashCode;
}

class PostsFail extends FetcherFail {
  PostsFail(String message, String messageKey) : super(message, messageKey);
}

/// POSTSLIST STATES END

/// RESIDENTS STATES START
class ResidentsLoading extends FetcherLoading {
  const ResidentsLoading();
}

class ResidentsLoaded extends FetcherLoaded {
  final BaseListResponse<FlatResidents> flatsResponse;
  const ResidentsLoaded(this.flatsResponse);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResidentsLoaded && other.flatsResponse == flatsResponse;
  }

  @override
  int get hashCode => flatsResponse.hashCode;
}

class ResidentsFail extends FetcherFail {
  ResidentsFail(String message, String messageKey) : super(message, messageKey);
}

/// RESIDENTS STATES END

/// DELETEVISITORLOG STATES START
class DeleteVisitorLogLoading extends FetcherLoading {
  const DeleteVisitorLogLoading();
}

class DeleteVisitorLogLoaded extends FetcherLoaded {
  final int visitorLogId;
  final String? type;
  const DeleteVisitorLogLoaded(this.visitorLogId, this.type);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DeleteVisitorLogLoaded &&
        other.visitorLogId == visitorLogId &&
        other.type == type;
  }

  @override
  int get hashCode => visitorLogId.hashCode ^ type.hashCode;
}

class DeleteVisitorLogFail extends FetcherFail {
  DeleteVisitorLogFail(String message, String messageKey)
      : super(message, messageKey);
}

/// DELETEVISITORLOG STATES END

/// SUPPORT STATES START
class SupportLoading extends FetcherLoading {
  const SupportLoading();
}

class SupportLoaded extends FetcherLoaded {
  const SupportLoaded();
}

class SupportLoadFail extends FetcherFail {
  SupportLoadFail(String message, String messageKey)
      : super(message, messageKey);
}

/// SUPPORT STATES END

/// USERME STATES START
class UserMeLoading extends FetcherLoading {
  const UserMeLoading();
}

class UserMeUpdating extends FetcherLoading {
  const UserMeUpdating();
}

class UserMeLoaded extends FetcherLoaded {
  final UserData userMe;
  final ResidentProfile? residentProfile;

  UserMeLoaded(this.userMe, this.residentProfile) {
    userMe.setup();
    residentProfile?.setup();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserMeLoaded &&
          runtimeType == other.runtimeType &&
          userMe == other.userMe &&
          residentProfile == other.residentProfile;

  @override
  int get hashCode => userMe.hashCode ^ residentProfile.hashCode;
}

class UserMeError extends FetcherFail {
  UserMeError(String message, String messageKey) : super(message, messageKey);
}

/// USERME STATES END

/// CREATEUPDATEAMENITYAPPOINTMENT STATES START
class CreateUpdateAmenityAppointmentLoading extends FetcherLoading {
  const CreateUpdateAmenityAppointmentLoading();
}

class CreateUpdateAmenityAppointmentLoaded extends FetcherLoaded {
  final AmenityAppointment amenityAppointment;
  final PaymentData? paymentData;
  const CreateUpdateAmenityAppointmentLoaded(
      this.amenityAppointment, this.paymentData);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateUpdateAmenityAppointmentLoaded &&
        other.amenityAppointment == amenityAppointment;
  }

  @override
  int get hashCode => amenityAppointment.hashCode;
}

class CreateUpdateAmenityAppointmentFail extends FetcherFail {
  CreateUpdateAmenityAppointmentFail(String message, String messageKey)
      : super(message, messageKey);
}

/// CREATEUPDATEAMENITYAPPOINTMENT STATES END

/// AMENITYAPPOINTMENTS STATES START
class AmenityAppointmentsLoading extends FetcherLoading {
  const AmenityAppointmentsLoading();
}

class AmenityAppointmentsLoaded extends FetcherLoaded {
  final BaseListResponse<AmenityAppointment> amenityAppointments;
  const AmenityAppointmentsLoaded(this.amenityAppointments);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AmenityAppointmentsLoaded &&
        other.amenityAppointments == amenityAppointments;
  }

  @override
  int get hashCode => amenityAppointments.hashCode;
}

class AmenityAppointmentsFail extends FetcherFail {
  AmenityAppointmentsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// AMENITYAPPOINTMENTS STATES END

/// AMENITY STATES START
class AmenitiesLoading extends FetcherLoading {
  const AmenitiesLoading();
}

class AmenitiesLoaded extends FetcherLoaded {
  final List<Amenity> amenities;
  const AmenitiesLoaded(this.amenities);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AmenitiesLoaded &&
        foundation.listEquals(other.amenities, amenities);
  }

  @override
  int get hashCode => amenities.hashCode;
}

class AmenitiesFail extends FetcherFail {
  AmenitiesFail(String message, String messageKey) : super(message, messageKey);
}

/// AMENITY STATES END

/// CATEGORIES STATES START
class CategoriesLoading extends FetcherLoading {
  const CategoriesLoading();
}

class CategoriesLoaded extends FetcherLoaded {
  final List<my_cat.Category> categories;
  const CategoriesLoaded(this.categories);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoriesLoaded &&
        foundation.listEquals(other.categories, categories);
  }

  @override
  int get hashCode => categories.hashCode;
}

class CategoriesFail extends FetcherFail {
  CategoriesFail(String message, String messageKey)
      : super(message, messageKey);
}

/// CATEGORIES STATES END

/// COMPLAINTS STATES START
class ComplaintsLoading extends FetcherLoading {
  const ComplaintsLoading();
}

class ComplaintsLoaded extends FetcherLoaded {
  final BaseListResponse<Complaint> complaints;
  const ComplaintsLoaded(this.complaints);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ComplaintsLoaded && other.complaints == complaints;
  }

  @override
  int get hashCode => complaints.hashCode;
}

class ComplaintsFail extends FetcherFail {
  ComplaintsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// COMPLAINTS STATES END

/// CREATEUPDATECOMPLAINT STATES START
class CreateUpdateComplaintLoading extends FetcherLoading {
  const CreateUpdateComplaintLoading();
}

class CreateUpdateComplaintLoaded extends FetcherLoaded {
  final Complaint complaint;
  const CreateUpdateComplaintLoaded(this.complaint);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateUpdateComplaintLoaded && other.complaint == complaint;
  }

  @override
  int get hashCode => complaint.hashCode;
}

class CreateUpdateComplaintFail extends FetcherFail {
  CreateUpdateComplaintFail(String message, String messageKey)
      : super(message, messageKey);
}

/// CREATEUPDATECOMPLAINT STATES END

/// CREATEVISITORLOG STATES START
class CreateVisitorLogLoading extends FetcherLoading {
  const CreateVisitorLogLoading();
}

class CreateVisitorLogLoaded extends FetcherLoaded {
  final VisitorLog visitorLog;
  const CreateVisitorLogLoaded(this.visitorLog);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateVisitorLogLoaded && other.visitorLog == visitorLog;
  }

  @override
  int get hashCode => visitorLog.hashCode;
}

class CreateVisitorLogFail extends FetcherFail {
  CreateVisitorLogFail(String message, String messageKey)
      : super(message, messageKey);
}

/// CREATEVISITORLOG STATES END

/// VISITORLOGS STATES START
class VisitorLogsLoading extends FetcherLoading {
  const VisitorLogsLoading();
}

class VisitorLogsLoaded extends FetcherLoaded {
  final BaseListResponse<VisitorLog> visitorLogs;
  final String? status;
  final String? type;
  final String? code;
  const VisitorLogsLoaded(
      {required this.visitorLogs, this.status, this.type, this.code});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VisitorLogsLoaded &&
        other.visitorLogs == visitorLogs &&
        other.status == status &&
        other.type == type &&
        other.code == code;
  }

  @override
  int get hashCode =>
      visitorLogs.hashCode ^ status.hashCode ^ type.hashCode ^ code.hashCode;
}

class VisitorLogsFail extends FetcherFail {
  final String? type;
  VisitorLogsFail(String message, String messageKey, this.type)
      : super(message, messageKey);
}

/// VISITORLOGS STATES END

/// RESIDENTPROFILEUPDATE STATES START
class ResidentProfileUpdateLoading extends FetcherLoading {
  const ResidentProfileUpdateLoading();
}

class ResidentProfileUpdateLoaded extends FetcherLoaded {
  final ResidentProfile profile;
  const ResidentProfileUpdateLoaded(this.profile);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResidentProfileUpdateLoaded && other.profile == profile;
  }

  @override
  int get hashCode => profile.hashCode;
}

class ResidentProfileUpdateFail extends FetcherFail {
  ResidentProfileUpdateFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTPROFILEUPDATE STATES END

/// RESIDENTFLAT STATES START
class ResidentFlatsLoading extends FetcherLoading {
  const ResidentFlatsLoading();
}

class ResidentFlatsLoaded extends FetcherLoaded {
  final List<ResidentFlat> flats;
  const ResidentFlatsLoaded(this.flats);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResidentFlatsLoaded &&
        foundation.listEquals(other.flats, flats);
  }

  @override
  int get hashCode => flats.hashCode;
}

class ResidentFlatsFail extends FetcherFail {
  ResidentFlatsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTFLAT STATES END

/// RESIDENTBUILDING STATES START
class ResidentBuildingsLoading extends FetcherLoading {
  const ResidentBuildingsLoading();
}

class ResidentBuildingsLoaded extends FetcherLoaded {
  final List<ResidentBuilding> buildings;
  const ResidentBuildingsLoaded(this.buildings);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResidentBuildingsLoaded &&
        foundation.listEquals(other.buildings, buildings);
  }

  @override
  int get hashCode => buildings.hashCode;
}

class ResidentBuildingsFail extends FetcherFail {
  ResidentBuildingsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTBUILDING STATES END

/// RESIDENTPROJECT STATES START
class ResidentProjectsLoading extends FetcherLoading {
  const ResidentProjectsLoading();
}

class ResidentProjectsLoaded extends FetcherLoaded {
  final List<ResidentProject> projects;
  const ResidentProjectsLoaded(this.projects);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ResidentProjectsLoaded &&
        foundation.listEquals(other.projects, projects);
  }

  @override
  int get hashCode => projects.hashCode;
}

class ResidentProjectsFail extends FetcherFail {
  ResidentProjectsFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTPROJECT STATES END

/// RESIDENTPROFILE STATES START
class ResidentProfileLoading extends FetcherLoading {
  const ResidentProfileLoading();
}

class ResidentProfileLoaded extends FetcherLoaded {
  final ResidentProfile profile;
  const ResidentProfileLoaded(this.profile);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResidentProfileLoaded && other.profile == profile;
  }

  @override
  int get hashCode => profile.hashCode;
}

class ResidentProfileFail extends FetcherFail {
  ResidentProfileFail(String message, String messageKey)
      : super(message, messageKey);
}

/// RESIDENTPROFILE STATES END

/// BASE STATES START
abstract class FetcherState {
  const FetcherState();
}

class FetcherInitial extends FetcherState {
  const FetcherInitial();
}

class FetcherLoading extends FetcherState {
  const FetcherLoading();
}

class FetcherLoaded extends FetcherState {
  const FetcherLoaded();
}

class FetcherFail extends FetcherState {
  final String message, messageKey;

  const FetcherFail(this.message, this.messageKey);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FetcherFail &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          messageKey == other.messageKey;

  @override
  int get hashCode => message.hashCode ^ messageKey.hashCode;
}
/// BASE STATES END