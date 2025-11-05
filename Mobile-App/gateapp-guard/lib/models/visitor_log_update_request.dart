// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'visitor_log_update_request.g.dart';

@JsonSerializable()
class VisitorLogUpdateRequest {
  String?
      status; //["waiting", "preapproved", "approved", "rejected", "left", "inside"]
  String? type;
  String? intime;
  String? outtime;
  String? meta;

  VisitorLogUpdateRequest({
    this.status,
    this.type,
    this.intime,
    this.outtime,
    this.meta,
  });

  factory VisitorLogUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$VisitorLogUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorLogUpdateRequestToJson(this);
}
