// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentProfile _$ResidentProfileFromJson(Map<String, dynamic> json) =>
    ResidentProfile(
      json['id'] as int,
      json['type'] as String?,
      json['is_approved'] as int?,
      json['project_id'] as int?,
      json['building_id'] as int?,
      json['flat_id'] as int?,
      json['user_id'] as int?,
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['project'] == null
          ? null
          : ResidentProject.fromJson(json['project'] as Map<String, dynamic>),
      json['building'] == null
          ? null
          : ResidentBuilding.fromJson(json['building'] as Map<String, dynamic>),
      json['flat'] == null
          ? null
          : ResidentFlat.fromJson(json['flat'] as Map<String, dynamic>),
      json['meta'],
    );

Map<String, dynamic> _$ResidentProfileToJson(ResidentProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'is_approved': instance.is_approved,
      'project_id': instance.project_id,
      'building_id': instance.building_id,
      'flat_id': instance.flat_id,
      'user_id': instance.user_id,
      'user': instance.user,
      'project': instance.project,
      'building': instance.building,
      'flat': instance.flat,
      'meta': instance.meta,
    };
