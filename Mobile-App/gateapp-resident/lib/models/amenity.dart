// ignore_for_file: non_constant_identifier_names
import 'package:gateapp_user/utility/app_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'amenity.g.dart';

@JsonSerializable()
class Amenity {
  final int id;
  final int project_id;
  final String title;
  final String description;
  final double? fee;
  final int? capacity;
  final int? booking_capacity;
  final int? advance_booking_days;
  final int? max_days_per_flat;
  final dynamic meta;

  String? fee_to_show;

  Amenity(
      this.id,
      this.project_id,
      this.title,
      this.description,
      this.fee,
      this.capacity,
      this.booking_capacity,
      this.advance_booking_days,
      this.max_days_per_flat,
      this.meta);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Amenity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  factory Amenity.fromJson(Map<String, dynamic> json) =>
      _$AmenityFromJson(json);

  Map<String, dynamic> toJson() => _$AmenityToJson(this);

  void setup() {
    fee_to_show ??=
        "${AppSettings.currencyIcon} ${(fee ?? 0).toStringAsFixed(1)}";
  }

  bool get isPaid => (fee ?? 0) > 0;
}
