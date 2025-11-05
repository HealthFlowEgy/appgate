// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guard_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GuardProfile _$GuardProfileFromJson(Map<String, dynamic> json) => GuardProfile(
      json['id'] as int,
      json['project_id'] as int?,
      json['user_id'] as int?,
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['project'] == null
          ? null
          : ResidentProject.fromJson(json['project'] as Map<String, dynamic>),
      json['meta'],
    );

Map<String, dynamic> _$GuardProfileToJson(GuardProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project_id': instance.project_id,
      'user_id': instance.user_id,
      'user': instance.user,
      'project': instance.project,
      'meta': instance.meta,
    };
