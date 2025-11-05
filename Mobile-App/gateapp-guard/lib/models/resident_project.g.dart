// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentProject _$ResidentProjectFromJson(Map<String, dynamic> json) =>
    ResidentProject(
      json['id'] as int,
      json['title'] as String?,
      json['address'] as String?,
      (json['latitude'] as num?)?.toDouble(),
      (json['longitude'] as num?)?.toDouble(),
      json['meta'],
      json['city_id'] as int?,
      json['city'] == null
          ? null
          : ResidentCity.fromJson(json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResidentProjectToJson(ResidentProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'meta': instance.meta,
      'city_id': instance.city_id,
      'city': instance.city,
    };
