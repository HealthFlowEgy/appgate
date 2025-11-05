// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale(AppConfig.languageDefault));

  void localeSelected(String value) {
    Helper.setHeadersBase("X-Localization", value);
    emit(Locale(value));
  }

  getCurrentLanguage() async {
    String currLang = await LocalDataLayer().getCurrentLanguage();
    localeSelected(currLang);
  }

  setCurrentLanguage(String langCode, bool save) async {
    if (save) {
      await LocalDataLayer().setCurrentLanguage(langCode);
      // RemoteRepository().updateUser({
      //   "language": langCode,
      // }).then((value) {
      //   if (value != null) LocalDataLayer().setUserMe(value);
      // });
    }
    localeSelected(langCode);
  }
}
