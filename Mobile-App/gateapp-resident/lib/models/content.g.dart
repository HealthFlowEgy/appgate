// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) => Content(
      json['id'] as int,
      json['meta'],
      json['type'] as String?,
      json['original_source'] as String,
      json['source'],
    );

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'id': instance.id,
      'meta': instance.meta,
      'type': instance.type,
      'original_source': instance.originalSource,
      'source': instance.source,
    };
