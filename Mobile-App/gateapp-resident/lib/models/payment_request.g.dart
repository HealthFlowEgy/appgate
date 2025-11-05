// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) =>
    PaymentRequest(
      json['id'] as int,
      json['title'] as String,
      json['amount'],
      json['duedate'] as String?,
      json['paidon'] as String?,
      json['meta'],
      json['status'] as String,
      json['project_id'] as int,
      json['flat_id'] as int,
      json['payment'] == null
          ? null
          : Payment.fromJson(json['payment'] as Map<String, dynamic>),
    )
      ..dueDateFormatted = json['dueDateFormatted'] as String?
      ..paidOnFormatted = json['paidOnFormatted'] as String?;

Map<String, dynamic> _$PaymentRequestToJson(PaymentRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.dynamicAmount,
      'duedate': instance.duedate,
      'paidon': instance.paidon,
      'meta': instance.dynamicMeta,
      'status': instance.status,
      'project_id': instance.projectId,
      'flat_id': instance.flatId,
      'payment': instance.payment,
      'dueDateFormatted': instance.dueDateFormatted,
      'paidOnFormatted': instance.paidOnFormatted,
    };
