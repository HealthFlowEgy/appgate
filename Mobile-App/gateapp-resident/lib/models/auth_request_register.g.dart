// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_request_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRequestRegister _$AuthRequestRegisterFromJson(Map<String, dynamic> json) =>
    AuthRequestRegister(
      json['name'] as String,
      json['email'] as String,
      json['password'] as String?,
      json['mobile_number'] as String,
      json['image'] as String?,
    )..role = json['role'] as String;

Map<String, dynamic> _$AuthRequestRegisterToJson(
        AuthRequestRegister instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'mobile_number': instance.mobile_number,
      'image': instance.image,
      'role': instance.role,
    };
