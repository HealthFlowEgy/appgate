// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'resident_project.dart';

part 'resident_building.g.dart';

@JsonSerializable()
class ResidentBuilding {
  final int id;
  final String? title;
  final dynamic meta;
  final int? project_id;
  final ResidentProject? project;

  ResidentBuilding(
      this.id, this.title, this.meta, this.project_id, this.project);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResidentBuilding && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ResidentBuilding.fromJson(Map<String, dynamic> json) =>
      _$ResidentBuildingFromJson(json);

  Map<String, dynamic> toJson() => _$ResidentBuildingToJson(this);
}
