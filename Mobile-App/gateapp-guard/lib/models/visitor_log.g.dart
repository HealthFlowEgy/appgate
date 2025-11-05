// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visitor_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisitorLog _$VisitorLogFromJson(Map<String, dynamic> json) => VisitorLog(
      json['id'] as int,
      json['pax'] as int?,
      json['type'] as String,
      json['code'] as String,
      json['name'] as String?,
      json['contact'] as String?,
      json['company_name'] as String?,
      json['vehicle_number'] as String?,
      json['intime'] as String?,
      json['outtime'] as String?,
      json['status'] as String,
      json['meta'],
      json['project_id'] as int?,
      json['building_id'] as int?,
      json['flat_id'] as int?,
      json['user_id'] as int?,
      json['flat'] == null
          ? null
          : ResidentFlat.fromJson(json['flat'] as Map<String, dynamic>),
      json['project'] == null
          ? null
          : ResidentProject.fromJson(json['project'] as Map<String, dynamic>),
      json['building'] == null
          ? null
          : ResidentBuilding.fromJson(json['building'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['created_at'] as String,
    );

Map<String, dynamic> _$VisitorLogToJson(VisitorLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pax': instance.pax,
      'type': instance.type,
      'code': instance.code,
      'name': instance.name,
      'contact': instance.contact,
      'company_name': instance.company_name,
      'vehicle_number': instance.vehicle_number,
      'intime': instance.intime,
      'outtime': instance.outtime,
      'status': instance.status,
      'meta': instance.meta,
      'project_id': instance.project_id,
      'building_id': instance.building_id,
      'flat_id': instance.flat_id,
      'user_id': instance.user_id,
      'flat': instance.flat,
      'project': instance.project,
      'building': instance.building,
      'user': instance.user,
      'created_at': instance.created_at,
    };
