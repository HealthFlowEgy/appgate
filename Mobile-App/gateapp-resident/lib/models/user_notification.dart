// ignore_for_file: non_constant_identifier_names, avoid_print
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:gateapp_user/utility/helper.dart';

import 'service_booking.dart';
import 'user_data.dart';
import 'visitor_log.dart';

part 'user_notification.g.dart';

@JsonSerializable()
class UserNotification {
  final int id;
  final String? text;
  final UserData? user;
  final UserData? fromuser;
  final String created_at;
  final String updated_at;
  final dynamic
      meta; //{ "type": "visitorlog" | "service", "visitor_log": VisitorLog | null, "service": Category | null }

  UserNotification(this.id, this.text, this.user, this.fromuser,
      this.created_at, this.updated_at, this.meta);

  String? created_at_formatted;
  String? type;
  VisitorLog? visitorLog;
  ServiceBooking? service;

  factory UserNotification.fromJson(Map<String, dynamic> json) =>
      _$UserNotificationFromJson(json);

  Map<String, dynamic> toJson() => _$UserNotificationToJson(this);

  void setup() {
    created_at_formatted ??= Helper.setupDateTime(created_at, false, false);
    try {
      type ??= meta != null && meta is Map && (meta as Map).containsKey("type")
          ? meta["type"]
          : null;
      visitorLog ??= meta != null &&
              meta is Map &&
              (meta as Map).containsKey("visitor_log")
          ? VisitorLog.fromJson(jsonDecode(jsonEncode(meta["visitor_log"])))
          : null;
      service ??= meta != null &&
              meta is Map &&
              (meta as Map).containsKey("servicebooking")
          ? ServiceBooking.fromJson(
              jsonDecode(jsonEncode(meta["servicebooking"])))
          : null;
      visitorLog?.setup();
      service?.setup();
      user?.setup();
      fromuser?.setup();
    } catch (e) {
      print("noti_meta: $e");
    }
  }
}
