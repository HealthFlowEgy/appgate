// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementOption _$AnnouncementOptionFromJson(Map<String, dynamic> json) =>
    AnnouncementOption(
      json['id'] as int,
      json['title'] as String,
      (json['selected_percentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AnnouncementOptionToJson(AnnouncementOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'selected_percentage': instance.selected_percentage,
    };
