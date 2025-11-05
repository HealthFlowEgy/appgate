// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amenity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Amenity _$AmenityFromJson(Map<String, dynamic> json) => Amenity(
      json['id'] as int,
      json['project_id'] as int,
      json['title'] as String,
      json['description'] as String,
      (json['fee'] as num?)?.toDouble(),
      json['capacity'] as int?,
      json['booking_capacity'] as int?,
      json['advance_booking_days'] as int?,
      json['max_days_per_flat'] as int?,
      json['meta'],
    )..fee_to_show = json['fee_to_show'] as String?;

Map<String, dynamic> _$AmenityToJson(Amenity instance) => <String, dynamic>{
      'id': instance.id,
      'project_id': instance.project_id,
      'title': instance.title,
      'description': instance.description,
      'fee': instance.fee,
      'capacity': instance.capacity,
      'booking_capacity': instance.booking_capacity,
      'advance_booking_days': instance.advance_booking_days,
      'max_days_per_flat': instance.max_days_per_flat,
      'meta': instance.meta,
      'fee_to_show': instance.fee_to_show,
    };
