// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageData _$ImageDataFromJson(Map<String, dynamic> json) => ImageData(
      defaultImage: json['default'] as String?,
      thumb: json['thumb'] as String?,
      small: json['small'] as String?,
      medium: json['medium'] as String?,
      large: json['large'] as String?,
    );

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
      'default': instance.defaultImage,
      'thumb': instance.thumb,
      'small': instance.small,
      'medium': instance.medium,
      'large': instance.large,
    };
