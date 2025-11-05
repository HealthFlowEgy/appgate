import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:gateapp_guard/bloc/auth_cubit.dart';
import 'package:gateapp_guard/models/auth_request_check_existence.dart';
import 'package:gateapp_guard/models/auth_request_login.dart';
import 'package:gateapp_guard/models/auth_request_register.dart';
import 'package:gateapp_guard/models/auth_response.dart';
import 'package:gateapp_guard/models/base_list_response.dart';
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
import 'package:gateapp_guard/models/visitor_log_request.dart';
import 'package:gateapp_guard/models/visitor_log_update_request.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:gateapp_guard/models/category.dart' as my_cat;

import 'remote_client.dart';
import 'request_interceptor.dart';

class RemoteRepository {
  static RemoteRepository? _instance;

  final Dio dio;
  final RemoteClient client;
  String? _verificationId;
  int? _resendToken;
  RemoteRepository._(this.dio, this.client);

  factory RemoteRepository() {
    if (_instance == null) {
      Dio dio = Dio();
      dio.interceptors.add(RequestInterceptor());
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));
      RemoteClient client = RemoteClient(dio);
      _instance = RemoteRepository._(dio, client);
    }
    return _instance!;
  }

  /// AUTH STUFF START
  Future<void> logout() async {
    await LocalDataLayer().clearPrefs();
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      if (kDebugMode) {
        print("firebaseAuth.signOut: $e");
      }
    }
    // try {
    //   await _googleSignIn?.signOut();
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("googleSignIn.signOut: $e");
    //   }
    // }
    // try {
    //   await FacebookAuth.instance.logOut();
    // } catch (e) {
    //   if (kDebugMode) {
    //     print("facebookLogin.logOut: $e");
    //   }
    // }
  }

  Future<bool> isRegistered(String number) async {
    try {
      await client.checkUser(AuthRequestCheckExistence(number));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("isRegistered: $e");
      }
      return false;
    }
  }

  Future<AuthResponse> registerUser(AuthRequestRegister registerUser) {
    Map<String, dynamic> rr = registerUser.toJson();
    rr.removeWhere((key, value) => value == null);
    return client.registerUser(rr);
  }

  Future<AuthResponse> signInWithPhoneNumber(String fireToken) {
    return client.login(AuthRequestLogin(fireToken));
  }

  Future<void> otpSend(
      String phoneNumberFull, VerificationCallbacks verificationCallback) {
    _resendToken = -1;
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumberFull,
      verificationCompleted: (PhoneAuthCredential credential) {
        if (Platform.isAndroid) {
          verificationCallback.onCodeVerifying();
          _fireSignIn(credential, verificationCallback);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (kDebugMode) {
          print("FirebaseAuthException: $e");
          print("FirebaseAuthException_message: ${e.message}");
          print("FirebaseAuthException_code: ${e.code}");
          print("FirebaseAuthException_phoneNumber: ${e.phoneNumber}");
        }
        verificationCallback.onCodeSendError(_resendToken != -1);
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        verificationCallback.onCodeSent();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  otpVerify(String otp, VerificationCallbacks verificationCallback) {
    _fireSignIn(
        PhoneAuthProvider.credential(
            verificationId: _verificationId!, smsCode: otp),
        verificationCallback);
  }

  _fireSignIn(AuthCredential credential,
      VerificationCallbacks verificationCallback) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      try {
        var user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          verificationCallback.onCodeVerificationError("something_wrong");
          return;
        }
        var idToken = await user.getIdToken();

        final loggedInResponse = await signInWithPhoneNumber(idToken!);
        verificationCallback.onCodeVerified(loggedInResponse);
      } catch (e) {
        if (kDebugMode) {
          print("signInWithCredential: $e");
        }
        String errorToReturn = "something_wrong";
        if (e is DioException) {
          //signout of social accounts.
          try {
            logout();
          } catch (le) {
            if (kDebugMode) {
              print(le);
            }
          }
          if ((e).response != null && (e).response!.data != null) {
            Map<String, dynamic> errorResponse = (e).response!.data;
            if (errorResponse.containsKey("message")) {
              String errorMessage = errorResponse["message"] as String;
              if (kDebugMode) {
                print("errorMessage: $errorMessage");
              }
              if (errorMessage.toLowerCase().contains("role")) {
                errorToReturn = "role_exists";
              }
            }
          }
        }
        verificationCallback.onCodeVerificationError(errorToReturn);
      }
    } catch (e) {
      if (kDebugMode) {
        print("signInWithCredential - ${e.runtimeType}: $e");
      }
      verificationCallback.onCodeVerificationError("unable_otp_verification");
    }
  }

  // Future<AuthResponseSocial> signInWithGoogle() async {
  //   GoogleSignInAccount? googleUser;
  //   try {
  //     _googleSignIn ??= GoogleSignIn(scopes: <String>['email', 'profile']);
  //     googleUser = await _googleSignIn?.signIn();
  //     if (googleUser == null) return AuthResponseSocial(null, null, null, null);
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     AuthResponse authResponse = await client.socialLogin(
  //         AuthRequestLoginSocial("google", googleAuth.idToken!,
  //             Platform.isAndroid ? "android" : "ios"));
  //     return AuthResponseSocial(null, null, null, authResponse);
  //   } catch (e) {
  //     String? userName, userEmail, userImageUrl;

  //     try {
  //       if (e is DioException) {
  //         Response<dynamic>? response = (e).response;
  //         if (response == null) {
  //           return AuthResponseSocial(null, null, null, null);
  //         }
  //         if (response.statusCode == 404 && response.data != null) {
  //           Map<String, dynamic> errorResponse = response.data;
  //           if (errorResponse.containsKey("message")) {
  //             if (errorResponse.containsKey("name")) {
  //               userName = errorResponse["name"];
  //             } else if (googleUser != null && googleUser.displayName != null) {
  //               userName = googleUser.displayName;
  //             }

  //             if (errorResponse.containsKey("email")) {
  //               userName = errorResponse["email"];
  //             } else if (googleUser != null) {
  //               userEmail = googleUser.email;
  //             }

  //             if (errorResponse.containsKey("image_url")) {
  //               userName = errorResponse["image_url"];
  //             } else if (googleUser != null && googleUser.photoUrl != null) {
  //               userImageUrl = googleUser.photoUrl;
  //             }
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }

  //     try {
  //       logout();
  //     } catch (le) {
  //       if (kDebugMode) {
  //         print(le);
  //       }
  //     }

  //     return AuthResponseSocial(userName, userEmail, userImageUrl, null);
  //   }
  // }

  // Future<AuthResponseSocial> signInWithApple(
  //     AuthorizationCredentialAppleID credentialAppleId) async {
  //   try {
  //     if (kDebugMode) {
  //       print("credentialAppleId: $credentialAppleId");
  //       print("credentialAppleId.givenName: ${credentialAppleId.givenName}");
  //       print("credentialAppleId.familyName: ${credentialAppleId.familyName}");
  //     }
  //     final credential = OAuthProvider('apple.com').credential(
  //       idToken: credentialAppleId.identityToken,
  //       accessToken: credentialAppleId.authorizationCode,
  //     );
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     if (kDebugMode) {
  //       print(userCredential);
  //     }

  //     var user = FirebaseAuth.instance.currentUser;
  //     String token = "";
  //     if (user != null) token = (await user.getIdToken())!;
  //     if (token.isNotEmpty) {
  //       AuthResponse authResponse = await client.socialLogin(
  //           AuthRequestLoginSocial(
  //               "apple", token, Platform.isAndroid ? "android" : "ios"));
  //       return AuthResponseSocial(null, null, null, authResponse);
  //     } else {
  //       return AuthResponseSocial(null, null, null, null);
  //     }
  //   } catch (e) {
  //     String? userName, userEmail, userImageUrl;

  //     try {
  //       if (e is DioException) {
  //         Response<dynamic>? response = (e).response;
  //         if (response == null) {
  //           return AuthResponseSocial(null, null, null, null);
  //         }
  //         if (response.statusCode == 404 && response.data != null) {
  //           Map<String, dynamic> errorResponse = response.data;
  //           if (errorResponse.containsKey("message")) {
  //             if (errorResponse.containsKey("name")) {
  //               userName = errorResponse["name"];
  //             } else if (credentialAppleId.givenName != null) {
  //               userName = credentialAppleId.givenName!;
  //             }

  //             if (errorResponse.containsKey("email")) {
  //               userEmail = errorResponse["email"];
  //             } else if (credentialAppleId.email != null) {
  //               userEmail = credentialAppleId.email!;
  //             }

  //             if (errorResponse.containsKey("image_url")) {
  //               userImageUrl = errorResponse["image_url"];
  //             }
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }

  //     try {
  //       logout();
  //     } catch (le) {
  //       if (kDebugMode) {
  //         print(le);
  //       }
  //     }

  //     return AuthResponseSocial(userName, userEmail, userImageUrl, null);
  //   }
  // }

  // Future<AuthResponseSocial> signInWithFacebook() async {
  //   AccessToken? accessToken;
  //   try {
  //     final LoginResult result = await FacebookAuth.instance.login();
  //     if (result.status == LoginStatus.success) {
  //       accessToken = result.accessToken;
  //       if (accessToken == null) {
  //         return AuthResponseSocial(null, null, null, null);
  //       }
  //       AuthResponse authResponse = await client.socialLogin(
  //           AuthRequestLoginSocial("facebook", accessToken.token,
  //               Platform.isAndroid ? "android" : "ios"));
  //       return AuthResponseSocial(null, null, null, authResponse);
  //     } else {
  //       return AuthResponseSocial(null, null, null, null);
  //     }
  //   } catch (e) {
  //     String? userName, userEmail, userImageUrl;

  //     try {
  //       if (e is DioException) {
  //         Map<String, dynamic>? facebookUserData;
  //         if (accessToken != null) {
  //           facebookUserData = await FacebookAuth.instance.getUserData();
  //         }
  //         Response<dynamic>? response = (e).response;
  //         if (response == null) {
  //           return AuthResponseSocial(null, null, null, null);
  //         }
  //         if (response.statusCode == 404 && response.data != null) {
  //           Map<String, dynamic> errorResponse = response.data;
  //           if (errorResponse.containsKey("message")) {
  //             if (errorResponse.containsKey("name")) {
  //               userName = errorResponse["name"];
  //             } else if (facebookUserData != null) {
  //               userImageUrl = facebookUserData["name"];
  //             }

  //             if (errorResponse.containsKey("email")) {
  //               userName = errorResponse["email"];
  //             } else if (facebookUserData != null) {
  //               userImageUrl = facebookUserData["email"];
  //             }

  //             if (errorResponse.containsKey("image_url")) {
  //               userName = errorResponse["image_url"];
  //             } else if (facebookUserData != null) {
  //               userImageUrl = facebookUserData["picture"]["data"]["url"];
  //             }
  //           }
  //         }
  //       }
  //     } catch (e) {
  //       if (kDebugMode) {
  //         print(e);
  //       }
  //     }

  //     try {
  //       logout();
  //     } catch (le) {
  //       if (kDebugMode) {
  //         print(le);
  //       }
  //     }

  //     return AuthResponseSocial(userName, userEmail, userImageUrl, null);
  //   }
  // }

  Future<void> deleteUser() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    await client.deleteUser(token);
  }

  /// AUTH STUFF END

  Future<void> postUrl(String url, Map<String, String> data) =>
      dio.post(url, data: data);

  Future<void> getUrl(String url) => dio.get(url);

  Future<List<Faq>> getFaqs() => client.getFaqs();

  Future<List<Setting>> fetchSettings() => client.getSettings();

  Future<UserData?> updateUser(Map<String, dynamic> updateRequest) async {
    updateRequest.removeWhere((key, value) => value == null);
    String? token = await LocalDataLayer().getAuthenticationToken();
    if (token == null || updateRequest.isEmpty) return null;
    return client.updateUser(token, updateRequest);
  }

  Future<UserData?> getUser() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    if (token == null) return null;
    return client.getUser(token);
  }

  Future<void> postNotification(
      {required String roleTo,
      required String userIdTo,
      String? title,
      String? body}) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.postNotification(
        token, {"role": roleTo, "user_id": userIdTo}, title, body);
  }

  Future<List<my_cat.Category>> getCategoriesWithScope(String scope) {
    return client.getCategoriesWithScope(scope);
  }

  Future<ResidentProfile> getResidentProfileByUserId(int userId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getResidentProfileByUserId(token, userId);
  }

  Future<List<ResidentProject>> getResidentProjects() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getResidentProjects(token);
  }

  Future<List<ResidentBuilding>> getResidentBuildings(int projectId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getResidentBuildings(token, projectId);
  }

  Future<List<ResidentFlat>> getResidentFlats(int buildingId) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getResidentFlats(token, buildingId);
  }

  Future<BaseListResponse<VisitorLog>> getVisitorLogs(
      {int? projectId,
      int? buildingId,
      int? pageNo,
      String? status,
      String? type,
      String? code,
      bool? isWaiting}) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getVisitorLogs(token, projectId, buildingId, pageNo, status,
        type, code, (isWaiting ?? false) ? 1 : null);
  }

  Future<dynamic> postSupport(SupportRequest supportRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.postSupport(token, supportRequest);
  }

  Future<GuardProfile> getGuardProfileMe() async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getGuardProfileMe(token);
  }

  Future<VisitorLog> updateVisitorLog(
      int visitorLogId, VisitorLogUpdateRequest visitorLogUpdateRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    Map<String, dynamic> ur = visitorLogUpdateRequest.toJson();
    ur.removeWhere((key, value) => value == null);
    return client.updateVisitorLog(token, visitorLogId, ur);
  }

  Future<VisitorLog> createVisitorLog(
      VisitorLogRequest visitorLogRequest) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    Map<String, dynamic> cr = visitorLogRequest.toJson();
    cr.removeWhere((key, value) => value == null);
    return client.createVisitorLog(token, cr);
  }

  Future<BaseListResponse<Complaint>> getComplaints(
      int? projectId, String type, int pageNo) async {
    String? token = await LocalDataLayer().getAuthenticationToken();
    return client.getComplaints(token, projectId, type, pageNo);
  }
}
