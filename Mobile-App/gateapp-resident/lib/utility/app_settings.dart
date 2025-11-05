import 'package:flutter/foundation.dart';
import 'package:gateapp_user/models/setting.dart';

class AppSettings {
  static late String currencyIcon,
      supportPhone,
      supportEmail,
      privacyPolicy,
      terms,
      deliveryDistance,
      fireAlert,
      liftAlert,
      animalAlert,
      visitorAlert;

  static bool setupWith(List<Setting> settings) {
    currencyIcon = _getSettingValue(settings, "currency_icon");
    supportPhone = _getSettingValue(settings, "support_phone");
    supportEmail = _getSettingValue(settings, "support_email");
    privacyPolicy = _getSettingValue(settings, "privacy_policy");
    terms = _getSettingValue(settings, "terms");
    fireAlert = _getSettingValue(settings, "fire_alert");
    liftAlert = _getSettingValue(settings, "lift_alert");
    animalAlert = _getSettingValue(settings, "animal_alert");
    visitorAlert = _getSettingValue(settings, "visitor_alert");

    //for testing
    //currencyIcon = "\$";
    return currencyIcon.isNotEmpty;
  }

  static String _getSettingValue(List<Setting> settings, String forKey) {
    String toReturn = "";
    for (Setting setting in settings) {
      if (setting.key == forKey) {
        toReturn = setting.value;
        break;
      }
    }
    if (toReturn.isEmpty) {
      if (kDebugMode) {
        print(
            "getSettingValue returned empty value for: $forKey, when settings were: $settings");
      }
    }
    return toReturn;
  }
}
