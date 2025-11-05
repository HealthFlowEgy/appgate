// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentData _$CommentDataFromJson(Map<String, dynamic> json) => CommentData(
      json['id'] as int,
      json['comment'] as String,
      UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['is_approved'] as bool?,
      json['created_at'] as String,
      json['is_liked'] as bool,
      json['meta'],
    )..created_at_formatted = json['created_at_formatted'] as String?;

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'user': instance.user,
      'is_approved': instance.isApproved,
      'created_at': instance.createdAt,
      'is_liked': instance.isLiked,
      'meta': instance.meta,
      'created_at_formatted': instance.created_at_formatted,
    };
