// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'resident_project.dart';
import 'user_data.dart';

part 'guard_profile.g.dart';

@JsonSerializable()
class GuardProfile {
  final int id;
  final int? project_id;
  int? user_id;
  UserData? user;
  final ResidentProject? project;
  final dynamic meta;

  GuardProfile(this.id, this.project_id, this.user_id, this.user, this.project,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GuardProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory GuardProfile.fromJson(Map<String, dynamic> json) =>
      _$GuardProfileFromJson(json);

  Map<String, dynamic> toJson() => _$GuardProfileToJson(this);

  void setup() {
    user?.setup();
  }
}
