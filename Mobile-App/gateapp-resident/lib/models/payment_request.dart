import 'package:gateapp_user/utility/app_settings.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:json_annotation/json_annotation.dart';

import 'payment.dart';

part 'payment_request.g.dart';

@JsonSerializable()
class PaymentRequest {
  final int id;
  final String title;
  @JsonKey(name: 'amount')
  final dynamic dynamicAmount;
  final String? duedate;
  final String? paidon;
  @JsonKey(name: 'meta')
  final dynamic dynamicMeta;
  final String status; //"pending", "paid", "failed"
  @JsonKey(name: 'project_id')
  final int projectId;
  @JsonKey(name: 'flat_id')
  final int flatId;
  final Payment? payment;

  String? dueDateFormatted;
  String? paidOnFormatted;

  PaymentRequest(
      this.id,
      this.title,
      this.dynamicAmount,
      this.duedate,
      this.paidon,
      this.dynamicMeta,
      this.status,
      this.projectId,
      this.flatId,
      this.payment);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentRequest && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  /// A necessary factory constructor for creating a new PaymentRequest instance
  /// from a map. Pass the map to the generated `_$PaymentRequestFromJson()` constructor.
  /// The constructor is named after the source class, in this case, PaymentRequest.
  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$PaymentRequestToJson`.
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);

  double get amount => double.tryParse("$dynamicAmount") ?? 0;

  String get amountToShow =>
      "${AppSettings.currencyIcon} ${amount.toStringAsFixed(1)}";

  void setup() {
    if (duedate != null) {
      dueDateFormatted ??= Helper.setupDate(duedate!, true);
    }
    if (paidon != null) {
      paidOnFormatted ??= Helper.setupDate(paidon!, true);
    }
  }
}
