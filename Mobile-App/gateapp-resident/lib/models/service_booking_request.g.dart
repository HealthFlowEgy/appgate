// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_booking_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceBookingRequest _$ServiceBookingRequestFromJson(
        Map<String, dynamic> json) =>
    ServiceBookingRequest(
      details: json['details'] as String,
      date: json['date'] as String,
      time_from: json['time_from'] as String,
      flat_id: json['flat_id'] as int,
      service_id: json['service_id'] as int,
      meta: json['meta'] as String,
    );

Map<String, dynamic> _$ServiceBookingRequestToJson(
        ServiceBookingRequest instance) =>
    <String, dynamic>{
      'details': instance.details,
      'date': instance.date,
      'time_from': instance.time_from,
      'flat_id': instance.flat_id,
      'service_id': instance.service_id,
      'meta': instance.meta,
    };
