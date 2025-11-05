// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceBooking _$ServiceBookingFromJson(Map<String, dynamic> json) =>
    ServiceBooking(
      json['id'] as int,
      json['details'] as String,
      json['date'] as String,
      json['time_from'] as String,
      json['status'] as String,
      json['project_id'] as int,
      json['flat_id'] as int,
      json['service_id'] as int,
      Category.fromJson(json['service'] as Map<String, dynamic>),
      json['meta'],
    )
      ..dateFormatted = json['dateFormatted'] as String?
      ..timeFormatted = json['timeFormatted'] as String?;

Map<String, dynamic> _$ServiceBookingToJson(ServiceBooking instance) =>
    <String, dynamic>{
      'id': instance.id,
      'details': instance.details,
      'date': instance.date,
      'time_from': instance.time_from,
      'status': instance.status,
      'project_id': instance.project_id,
      'flat_id': instance.flat_id,
      'service_id': instance.service_id,
      'service': instance.service,
      'meta': instance.meta,
      'dateFormatted': instance.dateFormatted,
      'timeFormatted': instance.timeFormatted,
    };
