// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentBuilding _$ResidentBuildingFromJson(Map<String, dynamic> json) =>
    ResidentBuilding(
      json['id'] as int,
      json['title'] as String?,
      json['meta'],
      json['project_id'] as int?,
      json['project'] == null
          ? null
          : ResidentProject.fromJson(json['project'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResidentBuildingToJson(ResidentBuilding instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'meta': instance.meta,
      'project_id': instance.project_id,
      'project': instance.project,
    };
