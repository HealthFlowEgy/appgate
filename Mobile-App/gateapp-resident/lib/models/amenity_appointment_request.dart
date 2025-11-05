// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'amenity_appointment_request.g.dart';

@JsonSerializable()
class AmenityAppointmentRequest {
  final String time_from;
  final String time_to;
  final String date_to;
  final String date;
  final double amount;
  final int resident_id;
  final String payment_method_slug;
  final String? meta;

  AmenityAppointmentRequest(
      {required this.time_from,
      required this.time_to,
      required this.date_to,
      required this.date,
      required this.amount,
      required this.resident_id,
      required this.payment_method_slug,
      this.meta});

  factory AmenityAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$AmenityAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AmenityAppointmentRequestToJson(this);
}
