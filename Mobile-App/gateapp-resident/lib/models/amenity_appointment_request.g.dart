// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity_appointment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmenityAppointmentRequest _$AmenityAppointmentRequestFromJson(
        Map<String, dynamic> json) =>
    AmenityAppointmentRequest(
      time_from: json['time_from'] as String,
      time_to: json['time_to'] as String,
      date_to: json['date_to'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
      resident_id: json['resident_id'] as int,
      payment_method_slug: json['payment_method_slug'] as String,
      meta: json['meta'] as String?,
    );

Map<String, dynamic> _$AmenityAppointmentRequestToJson(
        AmenityAppointmentRequest instance) =>
    <String, dynamic>{
      'time_from': instance.time_from,
      'time_to': instance.time_to,
      'date_to': instance.date_to,
      'date': instance.date,
      'amount': instance.amount,
      'resident_id': instance.resident_id,
      'payment_method_slug': instance.payment_method_slug,
      'meta': instance.meta,
    };
