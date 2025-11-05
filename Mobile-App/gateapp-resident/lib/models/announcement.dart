// ignore_for_file: non_constant_identifier_names
import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'announcement_option.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  final int id;
  final String type; //["poll","announcement"]
  final String? message;
  final String posted_by; //Admin
  final String? duedate;
  final dynamic meta;
  final String created_at;
  final String updated_at;
  int? likes_count;
  int? response_count;
  bool? is_liked;
  final List<AnnouncementOption>? options;

  String? created_at_formatted;
  String? dueDateFormatted;
  String? dueDateLeftFormatted;

  Announcement(
      this.id,
      this.type,
      this.message,
      this.posted_by,
      this.duedate,
      this.meta,
      this.created_at,
      this.updated_at,
      this.likes_count,
      this.response_count,
      this.is_liked,
      this.options);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Announcement && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);

  void setup() {
    created_at_formatted ??= Helper.setupDate(created_at, true);
    if (duedate != null) {
      dueDateFormatted ??= Helper.setupDate(duedate!, true);
    }
  }
}
