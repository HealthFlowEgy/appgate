import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/config/app_theme.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static const String isDarkTheme = "is_dark_theme";
  bool _isDark = false;

  ThemeCubit() : super(AppTheme.appTheme);

  bool get isDark => _isDark;

  getCurrentTheme() async {
    String currTheme = await LocalDataLayer().getCurrentTheme();
    setTheme(currTheme == Constants.themeDark);
  }

  setTheme(bool isDark) async {
    if (isDark) {
      await LocalDataLayer().setCurrentThemeDark();
    } else {
      await LocalDataLayer().setCurrentThemeLight();
    }
    _isDark = isDark;
    emit(AppTheme.appTheme);
    //emit(isDark ? AppTheme.appDarkTheme : AppTheme.appTheme);
  }
}
