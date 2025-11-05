import 'localization/languages/language_arabic.dart';
import 'localization/languages/language_english.dart';
import 'localization/languages/language_french.dart';
import 'localization/languages/indonesian.dart';
import 'localization/languages/italian.dart';
import 'localization/languages/language_portuguese.dart';
import 'localization/languages/language_spanish.dart';
import 'localization/languages/language_swahili.dart';
import 'localization/languages/language_turkish.dart';

class AppConfig {
  static const String appName = "YourAppName Guard";
  static const String baseUrl = "https://yourapibase.com/";
  static const String onesignalAppId = "YourGuardAppOnesignalAppId";
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
}

class AppLanguage {
  final String name;
  final Map<String, String> values;
  AppLanguage(this.name, this.values);
}
