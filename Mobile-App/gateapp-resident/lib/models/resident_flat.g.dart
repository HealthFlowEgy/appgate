// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_flat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentFlat _$ResidentFlatFromJson(Map<String, dynamic> json) => ResidentFlat(
      json['id'] as int,
      json['title'] as String?,
      json['meta'],
      json['building_id'] as int?,
      json['building'] == null
          ? null
          : ResidentBuilding.fromJson(json['building'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResidentFlatToJson(ResidentFlat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'meta': instance.meta,
      'building_id': instance.building_id,
      'building': instance.building,
    };
