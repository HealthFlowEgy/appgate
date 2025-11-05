import 'package:dio/dio.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/models/auth_request_check_existence.dart';
import 'package:gateapp_guard/models/auth_request_login.dart';
import 'package:gateapp_guard/models/auth_request_login_social.dart';
import 'package:gateapp_guard/models/auth_response.dart';
import 'package:gateapp_guard/models/base_list_response.dart';
import 'package:gateapp_guard/models/category.dart';
import 'package:gateapp_guard/models/complaint.dart';
import 'package:gateapp_guard/models/faq.dart';
import 'package:gateapp_guard/models/guard_profile.dart';
import 'package:gateapp_guard/models/resident_building.dart';
import 'package:gateapp_guard/models/resident_flat.dart';
import 'package:gateapp_guard/models/resident_profile.dart';
import 'package:gateapp_guard/models/resident_project.dart';
import 'package:gateapp_guard/models/setting.dart';
import 'package:gateapp_guard/models/support_request.dart';
import 'package:gateapp_guard/models/user_data.dart';
import 'package:gateapp_guard/models/visitor_log.dart';
import 'package:retrofit/retrofit.dart';

part 'remote_client.g.dart';

@RestApi(baseUrl: AppConfig.baseUrl)
abstract class RemoteClient {
  factory RemoteClient(Dio dio, {String? baseUrl}) = _RemoteClient;

  @POST("api/check-user")
  Future<void> checkUser(@Body() AuthRequestCheckExistence checkUser);

  @POST("api/register")
  Future<AuthResponse> registerUser(
      @Body() Map<String, dynamic> authRequestRegister);

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
      @Query("page") int? pageNo,
      @Query("status") String? status,
      @Query("type") String? type,
      @Query("code") String? code,
      @Query("waiting") int? waiting);

  @POST("api/gateapp/visitorlogs")
  Future<VisitorLog> createVisitorLog(
      @Header("Authorization") String? bearerToken,
      @Body() Map<String, dynamic> visitorLogRequest);

  @DELETE("api/gateapp/visitorlogs/{visitorLogId}")
  Future<void> deleteVisitorLog(@Header("Authorization") String? bearerToken,
      @Path("visitorLogId") int visitorLogId);

  @PUT("api/gateapp/visitorlogs/{visitorLogId}")
  Future<VisitorLog> updateVisitorLog(
      @Header("Authorization") String? bearerToken,
      @Path("visitorLogId") int visitorLogId,
      @Body() Map<String, dynamic> visitorLogUpdateRequest);

  @GET("api/gateapp/guards/myprofile")
  Future<GuardProfile> getGuardProfileMe(
      @Header("Authorization") String? bearerToken);

  @GET("api/gateapp/complaints")
  Future<BaseListResponse<Complaint>> getComplaints(
      @Header("Authorization") String? bearerToken,
      @Query("project_id") int? projectId,
      @Query("type") String type,
      @Query("page") int pageNo);
}
