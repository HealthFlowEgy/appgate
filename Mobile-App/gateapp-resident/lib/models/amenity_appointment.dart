// ignore_for_file: non_constant_identifier_names
import 'package:gateapp_user/utility/app_settings.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'amenity.dart';
import 'payment.dart';
import 'resident_profile.dart';

part 'amenity_appointment.g.dart';

@JsonSerializable()
class AmenityAppointment {
  final int id;
  final double? amount;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? date;
  final String? date_to;
  final String? time_from;
  final String? time_to;
  final dynamic meta;
  final String status;
  final ResidentProfile? resident;
  final Amenity? amenity;
  final Payment? payment;
  final String updated_at;
  final String created_at;

  String? created_at_formatted;
  String? date_formatted;
  String? date_to_formatted;
  String? time_from_formatted;
  String? time_to_formatted;
  String? amount_to_show;

  AmenityAppointment(
      this.id,
      this.amount,
      this.address,
      this.latitude,
      this.longitude,
      this.date,
      this.date_to,
      this.time_from,
      this.time_to,
      this.meta,
      this.status,
      this.resident,
      this.amenity,
      this.payment,
      this.updated_at,
      this.created_at);

  factory AmenityAppointment.fromJson(Map<String, dynamic> json) =>
      _$AmenityAppointmentFromJson(json);

  Map<String, dynamic> toJson() => _$AmenityAppointmentToJson(this);

  void setup() {
    created_at_formatted ??= Helper.setupDateTime(created_at, false, false);
    if (date != null) {
      date_formatted ??= Helper.setupDate(date!, false);
    }
    if (date_to != null) {
      date_to_formatted ??= Helper.setupDate(date_to!, false);
    }
    time_from_formatted ??= Helper.setupTime("$date $time_from", false);
    time_to_formatted ??= Helper.setupTime("$date $time_to", false);
    amount_to_show ??=
        "${AppSettings.currencyIcon} ${(amount ?? 0).toStringAsFixed(1)}";
    amenity?.setup();
  }

  String get bookedForDateTimeSummary =>
      "$date_formatted-$date_to_formatted | $time_from_formatted-$time_to_formatted";
}
