import 'package:json_annotation/json_annotation.dart';

part 'image_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ImageData {
  @JsonKey(name: 'default')
  final String? defaultImage;

  final String? thumb;
  final String? small;
  final String? medium;
  final String? large;

  ImageData({
    this.defaultImage,
    this.thumb,
    this.small,
    this.medium,
    this.large,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) =>
      _$ImageDataFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDataToJson(this);
}

enum MediaImageSize { thumb, small, medium, large }

extension ImgDataExt on ImageData {
  String? getPreferredSizedImageUrl(MediaImageSize? preferredSize) {
    if (preferredSize != null) {
      if (preferredSize == MediaImageSize.thumb && thumb != null) {
        return thumb;
      }
      if (preferredSize == MediaImageSize.small && small != null) {
        return small;
      }
      if (preferredSize == MediaImageSize.medium && medium != null) {
        return medium;
      }
      if (preferredSize == MediaImageSize.large && large != null) {
        return large;
      }
    }
    return defaultImage;
  }
}
