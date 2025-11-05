import 'localization/languages/languagearabic.dart';
import 'localization/languages/language_english.dart';
import 'localization/languages/language_french.dart';
import 'localization/languages/language_indonesian.dart';
import 'localization/languages/language_italian.dart';
import 'localization/languages/language_portuguese.dart';
import 'localization/languages/language_spanish.dart';
import 'localization/languages/language_swahili.dart';
import 'localization/languages/language_turkish.dart';

class AppConfig {
  static const String appName = "YourAppName";
  static const String baseUrl = "https://yourapibase.com/";
  static const String onesignalAppId = "YourResidentAppOnesignalAppId";
  static const String languageDefault = "en";
  static const bool isDemoMode = false;
  static final Map<String, AppLanguage> languagesSupported = {
    "en": AppLanguage("English", languageEnglish()),
    "ar": AppLanguage("عربى", languageArabic()),
    "pt": AppLanguage("Portugal", languagePortuguese()),
    "fr": AppLanguage("Français", languageFrench()),
    "id": AppLanguage("Bahasa Indonesia", languageIndonesian()),
    "es": AppLanguage("Español", languageSpanish()),
    "it": AppLanguage("italiano", languageItalian()),
    "tr": AppLanguage("Türk", languageTurkish()),
    "sw": AppLanguage("Kiswahili", languageSwahili()),
  };
  static late FireConfig fireConfig;
}

class FireConfig {
  bool enableSocialAuthApple = false;
  bool enableSocialAuthGoogle = false;
  bool enableSocialAuthFacebook = false;

  bool get isSocialAuthEnabled =>
      enableSocialAuthApple ||
      enableSocialAuthGoogle ||
      enableSocialAuthFacebook;

  @override
  String toString() {
    return '(enableSocialAuthApple: $enableSocialAuthApple, enableSocialAuthGoogle: $enableSocialAuthGoogle, enableSocialAuthFacebook: $enableSocialAuthFacebook)';
  }
}

class AppLanguage {
  final String name;
  final Map<String, String> values;
  AppLanguage(this.name, this.values);
}
