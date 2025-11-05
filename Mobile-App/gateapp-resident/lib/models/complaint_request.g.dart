// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintRequest _$ComplaintRequestFromJson(Map<String, dynamic> json) =>
    ComplaintRequest(
      type: json['type'] as String,
      message: json['message'] as String,
      flat_id: json['flat_id'] as int,
      category_id: json['category_id'] as int?,
      meta: json['meta'] as String?,
    );

Map<String, dynamic> _$ComplaintRequestToJson(ComplaintRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'message': instance.message,
      'flat_id': instance.flat_id,
      'category_id': instance.category_id,
      'meta': instance.meta,
    };
