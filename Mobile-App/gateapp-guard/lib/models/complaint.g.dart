// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Complaint _$ComplaintFromJson(Map<String, dynamic> json) => Complaint(
      json['id'] as int,
      json['type'] as String,
      json['message'] as String,
      json['status'] as String,
      json['user_id'] as int?,
      json['flat_id'] as int?,
      json['flat'] == null
          ? null
          : ResidentFlat.fromJson(json['flat'] as Map<String, dynamic>),
      json['project_id'] as int?,
      json['project'] == null
          ? null
          : ResidentProject.fromJson(json['project'] as Map<String, dynamic>),
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['meta'],
      json['created_at'] as String,
      json['updated_at'] as String,
    )..created_at_formatted = json['created_at_formatted'] as String?;

Map<String, dynamic> _$ComplaintToJson(Complaint instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'message': instance.message,
      'status': instance.status,
      'user_id': instance.user_id,
      'flat_id': instance.flat_id,
      'flat': instance.flat,
      'project_id': instance.project_id,
      'project': instance.project,
      'category': instance.category,
      'user': instance.user,
      'meta': instance.meta,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'created_at_formatted': instance.created_at_formatted,
    };
