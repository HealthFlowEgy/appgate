// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'resident_building.dart';

part 'resident_flat.g.dart';

@JsonSerializable()
class ResidentFlat {
  final int id;
  final String? title;
  final dynamic meta;
  final int? building_id;
  final ResidentBuilding? building;

  ResidentFlat(this.id, this.title, this.meta, this.building_id, this.building);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResidentFlat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ResidentFlat.fromJson(Map<String, dynamic> json) =>
      _$ResidentFlatFromJson(json);

  Map<String, dynamic> toJson() => _$ResidentFlatToJson(this);
}
