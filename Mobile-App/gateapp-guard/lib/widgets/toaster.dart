import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static showToast(String msg, [bool longToast = false]) async {
    await Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withOpacity(0.5),
      toastLength: longToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );
  }

  static showToastTop(String msg, [bool longToast = false]) async {
    await Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withOpacity(0.5),
      gravity: ToastGravity.TOP,
      toastLength: longToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );
  }

  static showToastCenter(String msg, [bool longToast = false]) async {
    await Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withOpacity(0.5),
      gravity: ToastGravity.CENTER,
      toastLength: longToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );
  }

  static showToastBottom(String msg, [bool longToast = false]) async {
    await Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black.withOpacity(0.5),
      gravity: ToastGravity.BOTTOM,
      toastLength: longToast ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    );
  }
}
