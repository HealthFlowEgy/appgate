// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity_appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmenityAppointment _$AmenityAppointmentFromJson(Map<String, dynamic> json) =>
    AmenityAppointment(
      json['id'] as int,
      (json['amount'] as num?)?.toDouble(),
      json['address'] as String?,
      (json['latitude'] as num?)?.toDouble(),
      (json['longitude'] as num?)?.toDouble(),
      json['date'] as String?,
      json['date_to'] as String?,
      json['time_from'] as String?,
      json['time_to'] as String?,
      json['meta'],
      json['status'] as String,
      json['resident'] == null
          ? null
          : ResidentProfile.fromJson(json['resident'] as Map<String, dynamic>),
      json['amenity'] == null
          ? null
          : Amenity.fromJson(json['amenity'] as Map<String, dynamic>),
      json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
      json['updated_at'] as String,
      json['created_at'] as String,
    )
      ..created_at_formatted = json['created_at_formatted'] as String?
      ..date_formatted = json['date_formatted'] as String?
      ..date_to_formatted = json['date_to_formatted'] as String?
      ..time_from_formatted = json['time_from_formatted'] as String?
      ..time_to_formatted = json['time_to_formatted'] as String?
      ..amount_to_show = json['amount_to_show'] as String?;

Map<String, dynamic> _$AmenityAppointmentToJson(AmenityAppointment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'date': instance.date,
      'date_to': instance.date_to,
      'time_from': instance.time_from,
      'time_to': instance.time_to,
      'meta': instance.meta,
      'status': instance.status,
      'resident': instance.resident,
      'amenity': instance.amenity,
      'payment': instance.payment,
      'updated_at': instance.updated_at,
      'created_at': instance.created_at,
      'created_at_formatted': instance.created_at_formatted,
      'date_formatted': instance.date_formatted,
      'date_to_formatted': instance.date_to_formatted,
      'time_from_formatted': instance.time_from_formatted,
      'time_to_formatted': instance.time_to_formatted,
      'amount_to_show': instance.amount_to_show,
    };
