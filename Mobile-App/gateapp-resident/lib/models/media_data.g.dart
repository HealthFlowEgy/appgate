// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaData _$MediaDataFromJson(Map<String, dynamic> json) => MediaData(
      json['id'] as int,
      json['title'] as String,
      json['description'] as String?,
      json['short_description'] as String?,
      json['meta'],
      (json['price'] as num).toDouble(),
      json['length'] as String?,
      json['language'] as String?,
      json['artists'] as String?,
      json['release_date'] as String?,
      json['maturity_rating'] as String?,
      json['status'] as String?,
      json['medialibrary'],
      json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      (json['subcategories'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Category.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['authors'] as List<dynamic>?)
          ?.map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['content'] as List<dynamic>)
          .map((e) => Content.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['favourite_count'] as int,
      json['is_favourite'] as bool,
      json['episode_count'] as int?,
      json['season_count'] as int?,
      (json['ratings'] as num).toDouble(),
      json['ratings_count'] as int?,
      json['comments_count'] as int,
      json['views_count'] as int,
      json['shares_count'] as int?,
      UserData.fromJson(json['user'] as Map<String, dynamic>),
      json['created_at'] as String?,
    )
      ..likesCount = json['likes_count'] as int
      ..isLiked = json['is_liked'] as bool
      ..created_at_formatted = json['created_at_formatted'] as String?;

Map<String, dynamic> _$MediaDataToJson(MediaData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'short_description': instance.shortDescription,
      'meta': instance.meta,
      'price': instance.price,
      'length': instance.length,
      'language': instance.language,
      'artists': instance.artists,
      'release_date': instance.releaseDate,
      'maturity_rating': instance.maturityRating,
      'status': instance.status,
      'medialibrary': instance.mediaLibrary,
      'user': instance.user,
      'category': instance.categoryData,
      'subcategories': instance.listSubCategoryData,
      'authors': instance.listAuthors,
      'content': instance.listContent,
      'favourite_count': instance.favouriteCount,
      'is_favourite': instance.isFavourite,
      'episode_count': instance.episodeCount,
      'season_count': instance.seasonCount,
      'ratings': instance.ratings,
      'ratings_count': instance.ratingsCount,
      'likes_count': instance.likesCount,
      'is_liked': instance.isLiked,
      'comments_count': instance.commentsCount,
      'views_count': instance.viewsCount,
      'shares_count': instance.sharesCount,
      'created_at': instance.createdAt,
      'created_at_formatted': instance.created_at_formatted,
    };
