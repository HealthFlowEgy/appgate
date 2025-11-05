// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'resident_profile_update_request.g.dart';

@JsonSerializable()
class ResidentProfileUpdateRequest {
  String? type; //"owner"
  int? project_id;
  int? building_id;
  int? flat_id;

  ResidentProfileUpdateRequest(
      {this.type, this.project_id, this.building_id, this.flat_id}) {
    type = "owner";
  }

  factory ResidentProfileUpdateRequest.fromJson(Map<String, dynamic> json) =>
      _$ResidentProfileUpdateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ResidentProfileUpdateRequestToJson(this);
}
