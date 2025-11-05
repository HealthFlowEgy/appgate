// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'category.dart';

part 'service_booking.g.dart';

@JsonSerializable()
class ServiceBooking {
  final int id;
  final String details;
  final String date;
  final String time_from;
  final String status; //["pending", "approved", "rejected", "cancelled"]
  final int project_id;
  final int flat_id;
  final int service_id;
  final Category service;
  final dynamic meta;

  String? dateFormatted;
  String? timeFormatted;

  ServiceBooking(this.id, this.details, this.date, this.time_from, this.status,
      this.project_id, this.flat_id, this.service_id, this.service, this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceBooking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ServiceBooking.fromJson(Map<String, dynamic> json) =>
      _$ServiceBookingFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceBookingToJson(this);

  void setup() {
    try {
      DateTime dateTime = DateTime.parse("$date $time_from");
      dateFormatted =
          Helper.setupDateFromMillis(dateTime.millisecondsSinceEpoch, false);
      timeFormatted =
          Helper.setupTimeFromMillis(dateTime.millisecondsSinceEpoch, false);
    } catch (e) {
      print("setup_service_booking: $e");
    }
    service.setup();
  }
}
