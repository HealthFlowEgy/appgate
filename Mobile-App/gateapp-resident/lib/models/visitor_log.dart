// ignore_for_file: non_constant_identifier_names

import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'resident_flat.dart';

part 'visitor_log.g.dart';

@JsonSerializable()
class VisitorLog {
  final int id;
  final int? pax;
  final String type;
  final String code;
  final String? name;
  final String? contact;
  final String? company_name;
  final String? vehicle_number;
  final String? intime;
  final String? outtime;
  final String
      status; //["waiting", "preapproved", "approved", "rejected", "left", "inside"]
  final dynamic meta;
  final int? project_id;
  final int? building_id;
  final int? flat_id;
  final int? user_id;
  final ResidentFlat? flat;
  final String created_at;

  String? created_at_formatted;
  String? intime_formatted;
  String? outtime_formatted;

  VisitorLog(
      this.id,
      this.pax,
      this.type,
      this.code,
      this.name,
      this.contact,
      this.company_name,
      this.vehicle_number,
      this.intime,
      this.outtime,
      this.status,
      this.meta,
      this.project_id,
      this.building_id,
      this.flat_id,
      this.user_id,
      this.flat,
      this.created_at);

  String? get imageUrl =>
      meta != null && meta is Map && (meta as Map).containsKey("image_url")
          ? meta["image_url"]
          : null;

  String get nameToShow =>
      "${name ?? vehicle_number ?? ""}${company_name != null && company_name!.isNotEmpty ? ", $company_name" : ""}";

  void setup() {
    created_at_formatted ??= Helper.setupDateTime(created_at, false, false);
    if (outtime != null) {
      outtime_formatted ??= Helper.setupDateTime(outtime!, false, false);
    }
    if (intime != null) {
      intime_formatted ??= Helper.setupDateTime(intime!, false, false);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VisitorLog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory VisitorLog.fromJson(Map<String, dynamic> json) =>
      _$VisitorLogFromJson(json);

  Map<String, dynamic> toJson() => _$VisitorLogToJson(this);
}
