// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'visitor_log_request.g.dart';

@JsonSerializable()
class VisitorLogRequest {
  String type;
  int flat_id;
  String? name;
  String? contact;
  String? company_name;
  String? vehicle_number;
  String? intime;
  String? status;
  int? pax;
  String? meta;

  VisitorLogRequest(
      {required this.type,
      required this.flat_id,
      this.name,
      this.contact,
      this.company_name,
      this.vehicle_number,
      this.intime,
      this.status,
      this.pax,
      this.meta});

  factory VisitorLogRequest.fromJson(Map<String, dynamic> json) =>
      _$VisitorLogRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorLogRequestToJson(this);
}
