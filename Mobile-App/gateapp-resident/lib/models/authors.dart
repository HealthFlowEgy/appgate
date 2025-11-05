// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:json_annotation/json_annotation.dart';

part 'authors.g.dart';

@JsonSerializable()
class Author {
  final int? id;
  final String? title;

  @JsonKey(name: 'short_description')
  final String? shortDescription;

  final String? description;
  final meta;
  final String? scope;

  @JsonKey(name: 'media_count')
  final int? mediaCount;

  @JsonKey(name: 'favourite_count')
  final int? favouriteCount;

  @JsonKey(name: 'is_favourite')
  bool? isFavourite;

  final double ratings;

  @JsonKey(name: 'ratings_count')
  final int? ratingsCount;

  final dynamic mediaurls;

  Author(
    this.id,
    this.title,
    this.shortDescription,
    this.description,
    this.meta,
    this.scope,
    this.mediaCount,
    this.favouriteCount,
    this.isFavourite,
    this.ratings,
    this.ratingsCount,
    this.mediaurls,
  );

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorToJson(this);
}
