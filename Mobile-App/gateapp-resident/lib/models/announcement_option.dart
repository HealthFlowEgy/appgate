// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'announcement_option.g.dart';

@JsonSerializable()
class AnnouncementOption {
  final int id;
  final String title;
  final double? selected_percentage;

  AnnouncementOption(this.id, this.title, this.selected_percentage);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnnouncementOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  int get selectedPercentage =>
      ((selected_percentage ?? 0) > 100 ? 100 : (selected_percentage ?? 0))
          .toInt();

  factory AnnouncementOption.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementOptionFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementOptionToJson(this);
}
