// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'complaint_request.g.dart';

@JsonSerializable()
class ComplaintRequest {
  final String type;
  final String message;
  final int flat_id;
  final int? category_id;
  final String? meta;

  ComplaintRequest(
      {required this.type,
      required this.message,
      required this.flat_id,
      this.category_id,
      this.meta});

  factory ComplaintRequest.fromJson(Map<String, dynamic> json) =>
      _$ComplaintRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintRequestToJson(this);
}
