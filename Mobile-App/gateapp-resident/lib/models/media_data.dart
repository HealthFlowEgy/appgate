// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'authors.dart';
import 'category.dart';
import 'content.dart';
import 'media_library.dart';
import 'user_data.dart';

part 'media_data.g.dart';

@JsonSerializable()
class MediaData {
  final int id;
  final String title;
  final String? description;

  @JsonKey(name: 'short_description')
  final String? shortDescription;

  final dynamic meta;
  final double price;
  final String? length;
  final String? language;
  final String? artists;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @JsonKey(name: 'maturity_rating')
  final String? maturityRating;

  final String? status;

  @JsonKey(name: 'medialibrary')
  final mediaLibrary;

  final UserData user;

  @JsonKey(name: 'category')
  final Category? categoryData;

  @JsonKey(name: 'subcategories')
  final List<Category?>? listSubCategoryData;

  @JsonKey(name: 'authors')
  final List<Author>? listAuthors;

  @JsonKey(name: 'content')
  final List<Content> listContent;

  @JsonKey(name: 'favourite_count')
  late int favouriteCount;

  @JsonKey(name: 'is_favourite')
  bool isFavourite;

  @JsonKey(name: 'episode_count')
  final int? episodeCount;

  @JsonKey(name: 'season_count')
  final int? seasonCount;

  final double ratings;

  @JsonKey(name: 'ratings_count')
  final int? ratingsCount;

  @JsonKey(name: 'likes_count')
  late int likesCount;

  @JsonKey(name: 'is_liked')
  late bool isLiked;

  @JsonKey(name: 'comments_count')
  int commentsCount;

  @JsonKey(name: 'views_count')
  late int viewsCount;

  @JsonKey(name: 'shares_count')
  final int? sharesCount;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  String? get videoUrl => listContent.firstOrNull?.originalSource;

  String? get imageUrl {
    if (mediaLibrary is Map) {
      MediaLibrary mediaUrls = MediaLibrary.fromJson(mediaLibrary);
      return mediaUrls.getMediaUrl();
    } else {
      return null;
    }
  }

  String? created_at_formatted;

  MediaData(
    this.id,
    this.title,
    this.description,
    this.shortDescription,
    this.meta,
    this.price,
    this.length,
    this.language,
    this.artists,
    this.releaseDate,
    this.maturityRating,
    this.status,
    this.mediaLibrary,
    this.categoryData,
    this.listSubCategoryData,
    this.listAuthors,
    this.listContent,
    this.favouriteCount,
    this.isFavourite,
    this.episodeCount,
    this.seasonCount,
    this.ratings,
    this.ratingsCount,
    this.commentsCount,
    this.viewsCount,
    this.sharesCount,
    this.user,
    this.createdAt,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MediaData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory MediaData.fromJson(Map<String, dynamic> json) =>
      _$MediaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDataToJson(this);

  void setup() {
    user.setup();
    if (createdAt != null) {
      created_at_formatted ??= Helper.setupDateTime(createdAt!, false, false);
    }
  }
}
