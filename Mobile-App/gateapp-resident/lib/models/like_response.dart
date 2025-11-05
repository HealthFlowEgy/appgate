// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'like_response.g.dart';

@JsonSerializable()
class LikeResponse {
  final bool? like;

  LikeResponse(this.like);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LikeResponse && other.like == like;
  }

  @override
  int get hashCode => like.hashCode;

  factory LikeResponse.fromJson(Map<String, dynamic> json) =>
      _$LikeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LikeResponseToJson(this);
}
