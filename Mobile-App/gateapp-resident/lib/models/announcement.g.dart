// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      json['id'] as int,
      json['type'] as String,
      json['message'] as String?,
      json['posted_by'] as String,
      json['duedate'] as String?,
      json['meta'],
      json['created_at'] as String,
      json['updated_at'] as String,
      json['likes_count'] as int?,
      json['response_count'] as int?,
      json['is_liked'] as bool?,
      (json['options'] as List<dynamic>?)
          ?.map((e) => AnnouncementOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..created_at_formatted = json['created_at_formatted'] as String?
      ..dueDateFormatted = json['dueDateFormatted'] as String?
      ..dueDateLeftFormatted = json['dueDateLeftFormatted'] as String?;

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'message': instance.message,
      'posted_by': instance.posted_by,
      'duedate': instance.duedate,
      'meta': instance.meta,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'likes_count': instance.likes_count,
      'response_count': instance.response_count,
      'is_liked': instance.is_liked,
      'options': instance.options,
      'created_at_formatted': instance.created_at_formatted,
      'dueDateFormatted': instance.dueDateFormatted,
      'dueDateLeftFormatted': instance.dueDateLeftFormatted,
    };
