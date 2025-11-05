// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_log_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitorLogUpdateRequest _$VisitorLogUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    VisitorLogUpdateRequest(
      status: json['status'] as String?,
      type: json['type'] as String?,
      intime: json['intime'] as String?,
      outtime: json['outtime'] as String?,
      meta: json['meta'] as String?,
    );

Map<String, dynamic> _$VisitorLogUpdateRequestToJson(
        VisitorLogUpdateRequest instance) =>
    <String, dynamic>{
      'status': instance.status,
      'type': instance.type,
      'intime': instance.intime,
      'outtime': instance.outtime,
      'meta': instance.meta,
    };
