// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

import 'package:gateapp_guard/utility/helper.dart';

import 'category.dart';
import 'resident_flat.dart';
import 'resident_project.dart';
import 'user_data.dart';

part 'complaint.g.dart';

@JsonSerializable()
class Complaint {
  final int id;
  final String type;
  final String message;
  final String status;
  final int? user_id;
  final int? flat_id;
  final ResidentFlat? flat;
  final int? project_id;
  final ResidentProject? project;
  final Category? category;
  final UserData? user;
  final dynamic meta;
  final String created_at;
  final String updated_at;

  String? created_at_formatted;

  Complaint(
      this.id,
      this.type,
      this.message,
      this.status,
      this.user_id,
      this.flat_id,
      this.flat,
      this.project_id,
      this.project,
      this.category,
      this.user,
      this.meta,
      this.created_at,
      this.updated_at);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Complaint && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Complaint.fromJson(Map<String, dynamic> json) =>
      _$ComplaintFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintToJson(this);

  void setup() {
    created_at_formatted ??= Helper.setupDateTime(created_at, false, false);
    user?.setup();
  }
}
