// ignore_for_file: non_constant_identifier_names

import 'package:gateapp_user/models/user_data.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_data.g.dart';

@JsonSerializable()
class CommentData {
  final int id;
  final String comment;
  final UserData user;

  @JsonKey(name: 'is_approved')
  final bool? isApproved;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'is_liked')
  bool isLiked;
  final dynamic meta;

  String? created_at_formatted;

  CommentData(this.id, this.comment, this.user, this.isApproved, this.createdAt,
      this.isLiked, this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDataToJson(this);

  void setup() {
    user.setup();
    created_at_formatted ??= Helper.setupDateTime(createdAt, false, false);
  }
}
