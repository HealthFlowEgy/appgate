// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_log_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitorLogRequest _$VisitorLogRequestFromJson(Map<String, dynamic> json) =>
    VisitorLogRequest(
      type: json['type'] as String,
      flat_id: json['flat_id'] as int,
      name: json['name'] as String?,
      contact: json['contact'] as String?,
      company_name: json['company_name'] as String?,
      vehicle_number: json['vehicle_number'] as String?,
      intime: json['intime'] as String?,
      status: json['status'] as String?,
      pax: json['pax'] as int?,
      meta: json['meta'] as String?,
    );

Map<String, dynamic> _$VisitorLogRequestToJson(VisitorLogRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'flat_id': instance.flat_id,
      'name': instance.name,
      'contact': instance.contact,
      'company_name': instance.company_name,
      'vehicle_number': instance.vehicle_number,
      'intime': instance.intime,
      'status': instance.status,
      'pax': instance.pax,
      'meta': instance.meta,
    };
