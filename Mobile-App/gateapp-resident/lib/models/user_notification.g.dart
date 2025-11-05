// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotification _$UserNotificationFromJson(Map<String, dynamic> json) =>
    UserNotification(
      json['id'] as int,
      json['text'] as String?,
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['fromuser'] == null
          ? null
          : UserData.fromJson(json['fromuser'] as Map<String, dynamic>),
      json['created_at'] as String,
      json['updated_at'] as String,
      json['meta'],
    )
      ..created_at_formatted = json['created_at_formatted'] as String?
      ..type = json['type'] as String?
      ..visitorLog = json['visitorLog'] == null
          ? null
          : VisitorLog.fromJson(json['visitorLog'] as Map<String, dynamic>)
      ..service = json['service'] == null
          ? null
          : ServiceBooking.fromJson(json['service'] as Map<String, dynamic>);

Map<String, dynamic> _$UserNotificationToJson(UserNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'user': instance.user,
      'fromuser': instance.fromuser,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'meta': instance.meta,
      'created_at_formatted': instance.created_at_formatted,
      'type': instance.type,
      'visitorLog': instance.visitorLog,
      'service': instance.service,
    };
