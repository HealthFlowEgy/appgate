// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'complaint_update_request.g.dart';

@JsonSerializable()
class ComplaintUpdateRequest {
  final String status;

  ComplaintUpdateRequest({required this.status});

  factory ComplaintUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ComplaintUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ComplaintUpdateRequestToJson(this);
}
