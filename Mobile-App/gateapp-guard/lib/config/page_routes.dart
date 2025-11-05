import 'package:flutter/material.dart';
import 'package:gateapp_guard/pages/add_visitor_log_page.dart';
import 'package:gateapp_guard/pages/language_page.dart';
import 'package:gateapp_guard/pages/profile_page.dart';
import 'package:gateapp_guard/pages/qr_scan_page.dart';
import 'package:gateapp_guard/pages/visitor_log_page.dart';

class PageRoutes {
  static const String profilePage = "profile_page";
  static const String languagePage = "language_page";
  static const String addVisitorLogPage = "add_visitor_log_page";
  static const String visitorLogPage = "visitor_log_page";
  static const String qrScanPage = "qr_scan_page";

  Map<String, WidgetBuilder> routes() => {
        languagePage: (context) => const LanguagePage(),
        profilePage: (context) => const ProfilePage(),
        addVisitorLogPage: (context) => const AddVisitorLogPage(),
        visitorLogPage: (context) => const VisitorLogPage(),
        qrScanPage: (context) => const QrScanPage(),
      };
}
