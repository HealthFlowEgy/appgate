import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/models/guard_profile.dart';
import 'package:gateapp_guard/models/setting.dart';
import 'package:gateapp_guard/models/user_data.dart';
import 'package:gateapp_guard/network/remote_repository.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  late RemoteRepository _repository;
  AppCubit() : super(Uninitialized());
  Future<void> initApp() async {
    await Firebase.initializeApp();
    //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    //Remove this method to stop OneSignal Debugging
    await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    // OneSignal.shared.promptUserForPushNotificationPermission();
    await OneSignal.shared.setAppId(AppConfig.onesignalAppId);
    await OneSignal.shared.setRequiresUserPrivacyConsent(false);
    await OneSignal.shared.promptUserForPushNotificationPermission();
    // OneSignal.shared.consentGranted(true);
    if (Platform.isIOS) OneSignal.shared.setLaunchURLsInApp(false);

    _addOnesignalEvents();
    _repository = RemoteRepository();
    bool initialised = await LocalDataLayer().initAppSettings();
    //await _setupFireConfig();
    if (initialised) {
      await emitAuthenticationState();
      _setupSettings(initialised);
    } else {
      await _setupSettings(initialised);
    }
    FlutterNativeSplash.remove();
  }

  Future<void> _setupSettings(bool alreadyInitialized) async {
    try {
      List<Setting> settings = await _repository.fetchSettings();
      await LocalDataLayer().saveSettings(settings);
      if (!alreadyInitialized) await emitAuthenticationState();
    } catch (e) {
      if (kDebugMode) {
        print("getSettings: $e");
        print("something went wrong in emitAuthenticationState");
      }
      await LocalDataLayer().clearPrefKey(LocalDataLayer.settingsKey);
      emit(FailureState("network_issue"));
    }
  }

  Future<void> emitAuthenticationState() async {
    emit(Uninitialized());

    UserData? userData;
    try {
      //userData = await _authRepo.getUser();
      userData = await LocalDataLayer().getUserMe();
    } catch (e) {
      if (kDebugMode) {
        print("emitAuthenticationState: $e");
      }
    }

    bool isDemoShowLangs = false;
    if (AppConfig.isDemoMode) {
      isDemoShowLangs = await LocalDataLayer().getHasLanguageSelectionPromted();
      await LocalDataLayer().setHasLanguageSelectionPromted();
    }

    if (userData != null) {
      initAuthenticated(isDemoShowLangs);
    } else {
      await LocalDataLayer().clearPrefsUser();
      emit(Unauthenticated(isDemoShowLangs, false));
    }
  }

  initAuthenticated([bool isDemoShowLangs = false]) async {
    emit(Uninitialized());

    GuardProfile? guardProfileMe;
    try {
      guardProfileMe = await LocalDataLayer().getGuardProfileMe();
      if (guardProfileMe == null) {
        guardProfileMe = await _repository.getGuardProfileMe();
        await LocalDataLayer().setGuardProfileMe(guardProfileMe);
      }
    } catch (e) {
      if (kDebugMode) {
        print("initAuthenticated: $e");
      }
    }

    if (guardProfileMe == null) {
      emit(Unauthenticated(isDemoShowLangs, true));
    } else {
      emit(Authenticated(isDemoShowLangs));
      _setupUserLanguageAndOneSignalPlayerId();
    }
  }

  logOut() {
    emit(Uninitialized());
    Future.delayed(const Duration(milliseconds: 500),
        () => _repository.logout().then((value) => emitAuthenticationState()));
    //OneSignal.User.pushSubscription.optOut();
  }

  // _setupUserLanguageAndOneSignalPlayerId() =>
  //     OneSignal.User.pushSubscription.optIn().then((value) async {
  //       String? playerId = OneSignal.User.pushSubscription.id;
  //       if (playerId != null) {
  //         String currLang = await LocalDataLayer().getCurrentLanguage();
  //         UserData? updatedUserData = await _repository.updateUser({
  //           "notification": "{\"${Constants.roleGuard}\":\"$playerId\"}",
  //           "language": currLang,
  //         });
  //         if (updatedUserData != null) {
  //           await LocalDataLayer().setUserMe(updatedUserData);
  //           await FirebaseDatabase.instance
  //               .ref()
  //               .child(Constants.refUsersFcmIds)
  //               .child(("${updatedUserData.id}${Constants.roleGuard}"))
  //               .set(playerId);
  //         }
  //       }
  //     });

  _setupUserLanguageAndOneSignalPlayerId() async {
    try {
      OSDeviceState? deviceState = await OneSignal.shared.getDeviceState();
      if (deviceState != null &&
          deviceState.userId != null &&
          deviceState.userId != null) {
        String currLang = await LocalDataLayer().getCurrentLanguage();
        UserData? updatedUserData = await _repository.updateUser({
          "notification":
              "{\"${Constants.roleGuard}\":\"${deviceState.userId}\"}",
          "language": currLang,
        });
        if (updatedUserData != null) {
          await LocalDataLayer().setUserMe(updatedUserData);
          await FirebaseDatabase.instance
              .ref()
              .child(Constants.refUsersFcmIds)
              .child(("${updatedUserData.id}${Constants.roleGuard}"))
              .set(deviceState.userId);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("userLanguageAndPlayerId: $e");
      }
    }
  }

  void _addOnesignalEvents() async {
    // OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    //   if (kDebugMode) {
    //     print(
    //         'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');
    //   }
    //   // try {
    //   //   FlutterAppBadger.updateBadgeCount(1);
    //   // } catch (e) {
    //   //   if (kDebugMode) {
    //   //     print("updateBadgeCount: $e");
    //   //   }
    //   // }
    // });

    // OneSignal.InAppMessages.addClickListener((event) {
    //   if (kDebugMode) {
    //     print("In App Message Clicked: \n${event.result.jsonRepresentation()}");
    //   }
    //   // try {
    //   //   FlutterAppBadger.removeBadge();
    //   // } catch (e) {
    //   //   if (kDebugMode) {
    //   //     print("removeBadge: $e");
    //   //   }
    //   // }
    // });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      if (kDebugMode) {
        print('FOREGROUND HANDLER CALLED WITH: $event');
      }
      // try {
      //   FlutterAppBadger.updateBadgeCount(1);
      // } catch (e) {
      //   if (kDebugMode) {
      //     print("updateBadgeCount: $e");
      //   }
      // }
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      if (kDebugMode) {
        print('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
      }
      // try {
      //   FlutterAppBadger.removeBadge();
      // } catch (e) {
      //   if (kDebugMode) {
      //     print("removeBadge: $e");
      //   }
      // }
    });
  }

  // _setupFireConfig() async {
  //   try {
  //     AppConfig.fireConfig = FireConfig();
  //     DatabaseReference configRef =
  //         FirebaseDatabase.instance.ref().child(Constants.refConfig);
  //     DatabaseEvent databaseEventFireConfig = await configRef.once();
  //     if (databaseEventFireConfig.snapshot.value != null &&
  //         databaseEventFireConfig.snapshot.value is Map) {
  //       AppConfig.fireConfig.enableSocialAuthGoogle = ((databaseEventFireConfig
  //               .snapshot.value as Map)["enableSocialAuthGoogle"] as bool?) ??
  //           false;
  //       AppConfig.fireConfig.enableSocialAuthApple = ((databaseEventFireConfig
  //               .snapshot.value as Map)["enableSocialAuthApple"] as bool?) ??
  //           false;
  //       AppConfig.fireConfig.enableSocialAuthFacebook =
  //           ((databaseEventFireConfig.snapshot.value
  //                   as Map)["enableSocialAuthFacebook"] as bool?) ??
  //               false;
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("setupFireConfig: $e");
  //     }
  //   }
  //   if (kDebugMode) {
  //     print("FireConfig: ${AppConfig.fireConfig}");
  //   }
  // }
}
