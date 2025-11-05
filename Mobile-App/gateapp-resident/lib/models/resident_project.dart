// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'resident_city.dart';

part 'resident_project.g.dart';

@JsonSerializable()
class ResidentProject {
  final int id;
  final String? title;
  final String? address;
  final double? latitude;
  final double? longitude;
  final dynamic meta;
  final int? city_id;
  final ResidentCity? city;

  ResidentProject(this.id, this.title, this.address, this.latitude,
      this.longitude, this.meta, this.city_id, this.city);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResidentProject && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ResidentProject.fromJson(Map<String, dynamic> json) =>
      _$ResidentProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ResidentProjectToJson(this);
}
