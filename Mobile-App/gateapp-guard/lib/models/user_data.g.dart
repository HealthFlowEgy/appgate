// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      json['id'] as int,
      json['name'] as String,
      json['email'] as String?,
      json['language'] as String?,
      json['mediaurls'],
      json['active'] as int?,
      json['confirmed'] as int?,
      json['mobile_verified'] as int?,
      json['mobile_number'] as String,
      json['wallet'] == null
          ? null
          : Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      json['referral_code'] as String?,
    )..imageUrl = json['imageUrl'] as String?;

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'language': instance.language,
      'mediaurls': instance.mediaurls,
      'active': instance.active,
      'confirmed': instance.confirmed,
      'mobile_verified': instance.mobile_verified,
      'mobile_number': instance.mobile_number,
      'wallet': instance.wallet,
      'referral_code': instance.referral_code,
      'imageUrl': instance.imageUrl,
    };
