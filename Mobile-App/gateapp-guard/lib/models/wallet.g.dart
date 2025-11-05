// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      json['id'] as int,
      json['user_id'] as int,
      json['balance'],
      json['updated_at'] as String,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'updated_at': instance.updated_at,
      'balance': instance.dynamicBalance,
    };
