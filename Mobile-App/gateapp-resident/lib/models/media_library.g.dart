// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaLibrary _$MediaLibraryFromJson(Map<String, dynamic> json) => MediaLibrary(
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => ImageData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaLibraryToJson(MediaLibrary instance) =>
    <String, dynamic>{
      'images': instance.images?.map((e) => e.toJson()).toList(),
    };
