import 'package:dio/dio.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/models/amenity.dart';
import 'package:gateapp_user/models/amenity_appointment.dart';
import 'package:gateapp_user/models/announcement.dart';
import 'package:gateapp_user/models/auth_request_check_existence.dart';
import 'package:gateapp_user/models/auth_request_login.dart';
import 'package:gateapp_user/models/auth_request_login_social.dart';
import 'package:gateapp_user/models/auth_response.dart';
import 'package:gateapp_user/models/base_list_response.dart';
import 'package:gateapp_user/models/category.dart';
import 'package:gateapp_user/models/comment_data.dart';
import 'package:gateapp_user/models/complaint.dart';
import 'package:gateapp_user/models/faq.dart';
import 'package:gateapp_user/models/flat_residents.dart';
import 'package:gateapp_user/models/media_data.dart';
import 'package:gateapp_user/models/payment.dart';
import 'package:gateapp_user/models/payment_method.dart';
import 'package:gateapp_user/models/payment_request.dart';
import 'package:gateapp_user/models/payment_response.dart';
import 'package:gateapp_user/models/resident_building.dart';
import 'package:gateapp_user/models/resident_flat.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/models/resident_project.dart';
import 'package:gateapp_user/models/service_booking.dart';
import 'package:gateapp_user/models/setting.dart';
import 'package:gateapp_user/models/support_request.dart';
import 'package:gateapp_user/models/user_data.dart';
import 'package:gateapp_user/models/user_notification.dart';
import 'package:gateapp_user/models/visitor_log.dart';
import 'package:gateapp_user/models/wallet_balance.dart';
import 'package:retrofit/retrofit.dart';

part 'remote_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class RemoteClient {
  factory RemoteClient(Dio dio, {String? baseUrl}) = _RemoteClient;

  @POST("api/check-user")
  Future<void> checkUser(@Body() AuthRequestCheckExistence checkUser);

  @POST("api/register")
  Future<AuthResponse> registerUser(
      @Body() @Body() Map<String, dynamic> authRequestRegister);

  @POST("api/login")
  Future<AuthResponse> login(@Body() AuthRequestLogin loginRequest);

  @POST("api/social/login")
  Future<AuthResponse> socialLogin(
      @Body() AuthRequestLoginSocial socialLoginUser);

  @POST("api/support")
  Future<void> createSupport(@Body() SupportRequest support);

  @PUT("api/user")
  Future<UserData> updateUser(@Header("Authorization") String bearerToken,
      @Body() Map<String, dynamic> updateUserRequest);

  @GET("api/user")
  Future<UserData> getUser(@Header("Authorization") String bearerToken);

  @GET("api/settings")
  Future<List<Setting>> getSettings();

  @GET("api/faq")
  Future<List<Faq>> getFaqs();

  @POST("api/support")
  Future<dynamic> postSupport(@Header("Authorization") String? bearerToken,
      @Body() SupportRequest supportRequest);

  @DELETE("api/user")
  Future<void> deleteUser(@Header("Authorization") String? bearerToken);

  @POST("api/user/push-notification")
  Future<void> postNotification(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> notiData,
      @Query("message_title") String? messageTitle,
      @Query("message_body") String? messageBody);

  @GET("api/categories?pagination=0")
  Future<List<Category>> getCategoriesWithScope(@Query("scope") String scope);

  @GET("api/gateapp/residents/myprofile")
  Future<ResidentProfile> getResidentProfileMe(
      @Header("Authorization") String? bearerToken);

  @PUT("api/gateapp/residents/myprofile")
  Future<ResidentProfile> updateResidentProfile(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> residentProfileUpdateRequest);

  @GET("api/gateapp/residents/{userId}")
  Future<ResidentProfile> getResidentProfileByUserId(
      @Header("Authorization") String? bearerToken, @Path("userId") int userId);

  @GET("api/gateapp/projects/{projectId}/directory")
  Future<BaseListResponse<FlatResidents>> getResidents(
      @Header("Authorization") String? bearerToken,
      @Path("projectId") int projectId,
      @Query("page") int pageNo);

  @GET("api/gateapp/projects?pagination=0")
  Future<List<ResidentProject>> getResidentProjects(
      @Header("Authorization") String? bearerToken);

  @GET("api/gateapp/buildings?pagination=0")
  Future<List<ResidentBuilding>> getResidentBuildings(
      @Header("Authorization") String? bearerToken,
      @Query("project_id") int projectId);

  @GET("api/gateapp/flats?pagination=0")
  Future<List<ResidentFlat>> getResidentFlats(
      @Header("Authorization") String? bearerToken,
      @Query("building_id") int buildingId);

  @GET("api/gateapp/visitorlogs")
  Future<BaseListResponse<VisitorLog>> getVisitorLogs(
      @Header("Authorization") String? bearerToken,
      @Query("project_id") int? projectId,
      @Query("building_id") int? buildingId,
      @Query("flat_id") int? flatId,
      @Query("page") int pageNo,
      @Query("status") String? status,
      @Query("type") String? type,
      @Query("code") String? code);

  @POST("api/gateapp/visitorlogs")
  Future<VisitorLog> createVisitorLog(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> visitorLogRequest);

  @PUT("api/gateapp/visitorlogs/{visitorLogId}")
  Future<VisitorLog> updateVisitorLog(
      @Header("Authorization") String? bearerToken,
      @Path("visitorLogId") int visitorLogId,
      @Body() Map<String, dynamic> visitorLogUpdateRequest);

  @DELETE("api/gateapp/visitorlogs/{visitorLogId}")
  Future<void> deleteVisitorLog(@Header("Authorization") String? bearerToken,
      @Path("visitorLogId") int visitorLogId);

  @GET("api/gateapp/complaints")
  Future<BaseListResponse<Complaint>> getComplaints(
      @Header("Authorization") String? bearerToken, @Query("page") int pageNo);

  @POST("api/gateapp/complaints")
  Future<Complaint> createComplaint(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> complaintRequest);

  @PUT("api/gateapp/complaints/{complaintId}")
  Future<Complaint> updateComplaint(
      @Header("Authorization") String? bearerToken,
      @Path("complaintId") int complaintId,
      @Body() Map<String, dynamic> complaintRequest);

  @GET("api/gateapp/amenities")
  Future<List<Amenity>> getAmenities(
      @Header("Authorization") String? bearerToken,
      @Query("project_id") int projectId);

  @POST("api/gateapp/appointments/{amenityId}")
  Future<AmenityAppointment> createAmenityAppointment(
      @Header("Authorization") String? bearerToken,
      @Path("amenityId") int amenityId,
      @Body() Map<String, dynamic> amenityAppointmentRequest);

  @GET("api/gateapp/appointments")
  Future<BaseListResponse<AmenityAppointment>> getAmenityAppointments(
      @Header("Authorization") String? bearerToken,
      @Query("resident_id") int residentId,
      @Query("page") int pageNo);

  @PUT("api/gateapp/appointments/{amenityAppointmentId}")
  Future<AmenityAppointment> updateAmenityAppointment(
      @Header("Authorization") String? bearerToken,
      @Path("amenityAppointmentId") int amenityAppointmentId,
      @Body() Map<String, dynamic> amenityAppointmentUpdateRequest);

  @GET("api/payment/methods")
  Future<List<PaymentMethod>> getPaymentMethods();

  @GET("api/user/wallet/balance")
  Future<WalletBalance> getWalletBalance(
      @Header("Authorization") String? bearerToken);

  @POST("api/user/wallet/deposit")
  Future<Payment> depositWallet(@Header("Authorization") String? bearerToken,
      @Body() Map<String, String> map);

  @GET("api/payment/wallet/{paymentId}")
  Future<PaymentResponse> payThroughWallet(
      @Header("Authorization") String? bearerToken,
      @Path("paymentId") String paymentId);

  @GET("api/payment/stripe/{paymentId}")
  Future<PaymentResponse> payThroughStripe(
      @Header("Authorization") String? bearerToken,
      @Path("paymentId") String paymentId,
      @Query("token") String stripeToken);

  @GET("api/media?recent=1&is_parent=1")
  Future<BaseListResponse<MediaData>> getPosts(
      @Header("Authorization") String? bearerToken,
      @Query("meta[project_id]") int projectId,
      @Query("page") int pageNo);

  @GET("api/media")
  Future<BaseListResponse<MediaData>> getPostsMine(
      @Header("Authorization") String? bearerToken,
      @Query("meta[project_id]") int projectId,
      @Query("user") int userId,
      @Query("page") int pageNo);

  @POST("api/media")
  Future<MediaData> createPost(@Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> postRequest);

  @POST("api/media/likes/{postId}")
  Future<void> togglePostLike(
      @Header("Authorization") String? bearerToken, @Path("postId") int postId);

  @GET("api/media/comments/{postId}")
  Future<BaseListResponse<CommentData>> getPostComments(
      @Header("Authorization") String? bearerToken,
      @Path("postId") int postId,
      @Query("page") int pageNo);

  @POST("api/media/comments/{postId}")
  Future<CommentData> createPostComment(
      @Header("Authorization") String? bearerToken,
      @Path("postId") int postId,
      @Body() Map<String, dynamic> commentRequest);

  @GET("api/gateapp/servicebookings")
  Future<BaseListResponse<ServiceBooking>> getServiceBookings(
      @Header("Authorization") String? bearerToken,
      @Query("flat_id") int flatId,
      @Query("page") int pageNo);

  @POST("api/gateapp/servicebookings")
  Future<ServiceBooking> createServiceBooking(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> servicebookingRequest);

  @GET("api/gateapp/paymentrequests")
  Future<BaseListResponse<PaymentRequest>> getPaymentRequests(
      @Header("Authorization") String? bearerToken,
      @Query("flat_id") int flatId,
      @Query("page") int pageNo);

  @POST("api/gateapp/paymentrequests/{paymentRequestId}/create-payment")
  Future<PaymentRequest> createPayment(
      @Header("Authorization") String? bearerToken,
      @Path("paymentRequestId") int paymentRequestId,
      @Body() Map<String, dynamic> paymentRequest);

  @GET("api/gateapp/announcements")
  Future<BaseListResponse<Announcement>> getAnnouncements(
      @Header("Authorization") String? bearerToken,
      @Query("project_id") int projectId,
      @Query("page") int pageNo);

  @POST("api/gateapp/announcements/{announcementId}/like")
  Future<void> toggleAnnouncementLike(
      @Header("Authorization") String? bearerToken,
      @Path("announcementId") int announcementId);

  @POST("api/gateapp/announcements/{announcementId}/poll")
  Future<Announcement> postAnnouncementPoll(
      @Header("Authorization") String? bearerToken,
      @Path("announcementId") int announcementId,
      @Body() Map<String, dynamic> pollRequest);

  @GET("api/user/notifications")
  Future<BaseListResponse<UserNotification>> getUserNotifications(
      @Header("Authorization") String? bearerToken,
      @Query("page") int pageNo,
      @Query("type") String type,
      @Query("upcoming") int? isUpcoming,
      @Query("past") int? isPast);
}
