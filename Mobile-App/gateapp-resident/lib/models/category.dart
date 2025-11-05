// ignore_for_file: non_constant_identifier_names
import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int id;
  final int? parent_id;
  final String? slug;
  final String title;
  final dynamic mediaurls;
  final dynamic meta;
  String? image_url;

  Category(this.id, this.parent_id, this.slug, this.title, this.mediaurls,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  void setup() {
    image_url = Helper.getMediaUrl(mediaurls);
  }

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
