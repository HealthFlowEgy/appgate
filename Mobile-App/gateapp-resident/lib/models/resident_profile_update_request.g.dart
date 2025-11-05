// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_profile_update_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentProfileUpdateRequest _$ResidentProfileUpdateRequestFromJson(
        Map<String, dynamic> json) =>
    ResidentProfileUpdateRequest(
      type: json['type'] as String?,
      project_id: json['project_id'] as int?,
      building_id: json['building_id'] as int?,
      flat_id: json['flat_id'] as int?,
    );

Map<String, dynamic> _$ResidentProfileUpdateRequestToJson(
        ResidentProfileUpdateRequest instance) =>
    <String, dynamic>{
      'type': instance.type,
      'project_id': instance.project_id,
      'building_id': instance.building_id,
      'flat_id': instance.flat_id,
    };
