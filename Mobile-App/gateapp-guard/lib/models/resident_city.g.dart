// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentCity _$ResidentCityFromJson(Map<String, dynamic> json) => ResidentCity(
      json['id'] as int,
      json['parent_id'] as int?,
      json['slug'] as String?,
      json['title'] as String,
      json['mediaurls'],
      json['meta'],
    );

Map<String, dynamic> _$ResidentCityToJson(ResidentCity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parent_id,
      'slug': instance.slug,
      'title': instance.title,
      'mediaurls': instance.mediaurls,
      'meta': instance.meta,
    };
