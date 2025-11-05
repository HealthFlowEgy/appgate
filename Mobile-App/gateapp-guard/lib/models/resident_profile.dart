// ignore_for_file: non_constant_identifier_names

import 'package:gateapp_guard/models/user_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'resident_building.dart';
import 'resident_flat.dart';
import 'resident_project.dart';

part 'resident_profile.g.dart';

@JsonSerializable()
class ResidentProfile {
  final int id;
  final String? type;
  final int? is_approved;
  final int? project_id;
  final int? building_id;
  final int? flat_id;
  int? user_id;
  UserData? user;
  final ResidentProject? project;
  final ResidentBuilding? building;
  final ResidentFlat? flat;
  final dynamic meta;

  ResidentProfile(
      this.id,
      this.type,
      this.is_approved,
      this.project_id,
      this.building_id,
      this.flat_id,
      this.user_id,
      this.user,
      this.project,
      this.building,
      this.flat,
      this.meta);

  get isComplete => flat != null && building != null && project != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResidentProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ResidentProfile.fromJson(Map<String, dynamic> json) =>
      _$ResidentProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ResidentProfileToJson(this);

  String getAddressToShow() =>
      "${flat?.title}-${building?.title}, ${project?.title}";

  void setup() {
    user?.setup();
  }
}
