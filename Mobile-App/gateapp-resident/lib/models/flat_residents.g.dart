// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flat_residents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlatResidents _$FlatResidentsFromJson(Map<String, dynamic> json) =>
    FlatResidents(
      json['id'] as int,
      json['title'] as String,
      (json['residents'] as List<dynamic>?)
          ?.map((e) => ResidentProfile.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['meta'],
    );

Map<String, dynamic> _$FlatResidentsToJson(FlatResidents instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'residents': instance.residents,
      'meta': instance.meta,
    };
