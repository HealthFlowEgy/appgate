import 'package:flutter/material.dart';

class AppTheme {
  static String fontFamily = 'ProductSans';
  static ThemeData appTheme = ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    hintColor: const Color(0xff979ca7),
    // highlightColor: Colors.white,
    primaryColor: Colors.black,
    splashColor: Colors.transparent, highlightColor: Colors.transparent,
    // primaryColorLight: const Color(0xffFEF675),
    // primaryColorDark: primaryColorDark,
    fontFamily: fontFamily,

    ///appBar theme
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    ),

    ///text theme
    textTheme: const TextTheme(
      titleSmall: TextStyle(),
      titleLarge: TextStyle(),
      bodyLarge: TextStyle(),
      labelLarge: TextStyle(),
      bodySmall: TextStyle(), //caption
    ),
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: const Color(0xfff4fbff),
    ),
  );
}

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
