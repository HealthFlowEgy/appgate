// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'resident_city.g.dart';

@JsonSerializable()
class ResidentCity {
  final int id;
  final int? parent_id;
  final String? slug;
  final String title;
  final dynamic mediaurls;
  final dynamic meta;

  ResidentCity(this.id, this.parent_id, this.slug, this.title, this.mediaurls,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResidentCity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory ResidentCity.fromJson(Map<String, dynamic> json) =>
      _$ResidentCityFromJson(json);

  Map<String, dynamic> toJson() => _$ResidentCityToJson(this);
}
