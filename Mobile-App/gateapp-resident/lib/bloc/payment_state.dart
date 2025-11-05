part of 'payment_cubit.dart';

abstract class PaymentState {}

class ErrorPaymentState extends PaymentState {
  final String message, messageKey;
  ErrorPaymentState(this.message, this.messageKey);
}

class InitialPaymentState extends PaymentState {}

/// PAYMENTREQUESTCREATE STATES START
class PaymentRequestCreateLoading extends PaymentState {
  PaymentRequestCreateLoading();
}

class PaymentRequestCreateLoaded extends PaymentState {
  final PaymentRequest paymentRequest;
  PaymentRequestCreateLoaded(this.paymentRequest);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentRequestCreateLoaded &&
        other.paymentRequest == paymentRequest;
  }

  @override
  int get hashCode => paymentRequest.hashCode;
}

class PaymentRequestCreateFail extends ErrorPaymentState {
  PaymentRequestCreateFail(String message, String messageKey)
      : super(message, messageKey);
}

/// PAYMENTREQUESTCREATE STATES END

/// CREATEPAYMENTREQUESTPAYMENTDATA STATES START
class CreatePaymentRequestPaymentDataLoading extends PaymentState {
  CreatePaymentRequestPaymentDataLoading();
}

class CreatePaymentRequestPaymentDataLoaded extends PaymentState {
  final PaymentRequest paymentRequest;
  final PaymentData? paymentData;
  CreatePaymentRequestPaymentDataLoaded(this.paymentRequest, this.paymentData);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreatePaymentRequestPaymentDataLoaded &&
        other.paymentRequest == paymentRequest;
  }

  @override
  int get hashCode => paymentRequest.hashCode;
}

class CreatePaymentRequestPaymentDataFail extends ErrorPaymentState {
  CreatePaymentRequestPaymentDataFail(String message, String messageKey)
      : super(message, messageKey);
}

/// CREATEPAYMENTREQUESTPAYMENTDATA STATES END

/// CREATEUPDATEAMENITYAPPOINTMENT STATES START
class CreateUpdateAmenityAppointmentLoading extends PaymentState {
  CreateUpdateAmenityAppointmentLoading();
}

class CreateUpdateAmenityAppointmentLoaded extends PaymentState {
  final AmenityAppointment amenityAppointment;
  final PaymentData? paymentData;
  CreateUpdateAmenityAppointmentLoaded(
      this.amenityAppointment, this.paymentData);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CreateUpdateAmenityAppointmentLoaded &&
        other.amenityAppointment == amenityAppointment;
  }

  @override
  int get hashCode => amenityAppointment.hashCode;
}

class CreateUpdateAmenityAppointmentFail extends ErrorPaymentState {
  CreateUpdateAmenityAppointmentFail(String message, String messageKey)
      : super(message, messageKey);
}

/// CREATEUPDATEAMENITYAPPOINTMENT STATES END

//PAYMENT METHODS STATE
class LoadingPaymentMethods extends PaymentState {}

class PaymentMethodsLoaded extends PaymentState {
  final List<my_payment_method.PaymentMethod> listPayment;
  PaymentMethodsLoaded(this.listPayment);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentMethodsLoaded &&
        listEquals(other.listPayment, listPayment);
  }

  @override
  int get hashCode => listPayment.hashCode;
}

class PaymentMethodsError extends ErrorPaymentState {
  PaymentMethodsError(String message, String messageKey)
      : super(message, messageKey);
}

class ProcessedPaymentState extends PaymentState {
  final PaymentStatus paymentStatus;
  ProcessedPaymentState(this.paymentStatus);
  @override
  String toString() => 'ProcessedPaymentState(paymentStatus: $paymentStatus)';
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProcessedPaymentState &&
        other.paymentStatus == paymentStatus;
  }

  @override
  int get hashCode => paymentStatus.hashCode;
}

//WALLET DEPOSIT STATES
class LoadingWalletDeposit extends PaymentState {
  LoadingWalletDeposit();
}

class WalletDepositLoaded extends PaymentState {
  final PaymentData paymentData;
  WalletDepositLoaded(this.paymentData);
}

class WalletDepositError extends ErrorPaymentState {
  WalletDepositError(String message, String messageKey)
      : super(message, messageKey);
}

//PROCESS PAYMENT STATES
class ProcessingPaymentState extends PaymentState {}

class LoadPaymentUrlState extends PaymentState {
  final String paymentLink;
  final String sUrl;
  final String fUrl;
  LoadPaymentUrlState(this.paymentLink, this.sUrl, this.fUrl);

  @override
  String toString() =>
      'LoadPaymentUrlState(paymentLink: $paymentLink, sUrl: $sUrl, fUrl: $fUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoadPaymentUrlState &&
        other.paymentLink == paymentLink &&
        other.sUrl == sUrl &&
        other.fUrl == fUrl;
  }

  @override
  int get hashCode => paymentLink.hashCode ^ sUrl.hashCode ^ fUrl.hashCode;
}

class PaymentSetupError extends ErrorPaymentState {
  PaymentSetupError(String message, String messageKey)
      : super(message, messageKey);
}
