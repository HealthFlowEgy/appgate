// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'service_booking_request.g.dart';

@JsonSerializable()
class ServiceBookingRequest {
  final String details;
  final String date;
  final String time_from;
  final int flat_id;
  final int service_id;
  final String meta;

  ServiceBookingRequest(
      {required this.details,
      required this.date,
      required this.time_from,
      required this.flat_id,
      required this.service_id,
      required this.meta});

  factory ServiceBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceBookingRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceBookingRequestToJson(this);
}
