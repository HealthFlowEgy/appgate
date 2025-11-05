// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'amenity_appointment_update_request.g.dart';

@JsonSerializable()
class AmenityAppointmentUpdateRequest {
  final String status;

  AmenityAppointmentUpdateRequest({required this.status});

  factory AmenityAppointmentUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$AmenityAppointmentUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AmenityAppointmentUpdateRequestToJson(this);
}
