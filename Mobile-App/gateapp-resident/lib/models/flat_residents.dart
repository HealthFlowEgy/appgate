// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

import 'resident_profile.dart';

part 'flat_residents.g.dart';

@JsonSerializable()
class FlatResidents {
  final int id;
  final String title;
  final List<ResidentProfile>? residents;
  final dynamic meta;

  FlatResidents(this.id, this.title, this.residents, this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FlatResidents && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory FlatResidents.fromJson(Map<String, dynamic> json) =>
      _$FlatResidentsFromJson(json);

  Map<String, dynamic> toJson() => _$FlatResidentsToJson(this);
}
