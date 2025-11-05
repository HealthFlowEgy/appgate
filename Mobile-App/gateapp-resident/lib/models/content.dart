// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:json_annotation/json_annotation.dart';

part 'content.g.dart';

@JsonSerializable()
class Content {
  final int id;
  final meta;
  final String? type;

  @JsonKey(name: 'original_source')
  final String originalSource;

  final source;

  Content(this.id, this.meta, this.type, this.originalSource, this.source);

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
