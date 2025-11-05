// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      json['id'] as int?,
      json['title'] as String?,
      json['short_description'] as String?,
      json['description'] as String?,
      json['meta'],
      json['scope'] as String?,
      json['media_count'] as int?,
      json['favourite_count'] as int?,
      json['is_favourite'] as bool?,
      (json['ratings'] as num).toDouble(),
      json['ratings_count'] as int?,
      json['mediaurls'],
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'short_description': instance.shortDescription,
      'description': instance.description,
      'meta': instance.meta,
      'scope': instance.scope,
      'media_count': instance.mediaCount,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'mediaurls': instance.mediaurls,
    };
