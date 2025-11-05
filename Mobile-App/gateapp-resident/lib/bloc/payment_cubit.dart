import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/models/amenity_appointment.dart';
import 'package:gateapp_user/models/amenity_appointment_request.dart';
import 'package:gateapp_user/models/payment_request.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/models/wallet_balance.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/models/payment.dart';
import 'package:gateapp_user/models/payment_response.dart';
import 'package:gateapp_user/models/user_data.dart';
import 'package:gateapp_user/network/remote_repository.dart';
import 'package:gateapp_user/widgets/card_picker.dart';
import 'package:gateapp_user/models/payment_method.dart' as my_payment_method;
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

part 'payment_state.dart';

class PaymentStatus {
  final bool isPaid;
  final String paidVia;
  PaymentStatus(this.isPaid, this.paidVia);
}

class PaymentCubit extends Cubit<PaymentState> {
  final List<String> _supportedPaymentGatewaySlugs = [
    "cod",
    "wallet",
    "stripe",
    "payu",
    "paystack"
  ];
  final RemoteRepository _networkRepo = RemoteRepository();
  String? _sUrl, _fUrl, _currentPaymentMethod;
  Payment? _currentPayment;

  PaymentCubit() : super(InitialPaymentState());

  initFetchPaymentMethods(List<String> slugsToIgnore) async {
    emit(LoadingPaymentMethods());
    try {
      List<my_payment_method.PaymentMethod> listPayment =
          await _networkRepo.getPaymentMethod();
      listPayment.removeWhere((element) => (element.enabled == null ||
          element.enabled != 1 ||
          (slugsToIgnore.contains(element.slug))));
      emit(PaymentMethodsLoaded(listPayment));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(PaymentMethodsError("Something went wrong", "something_wrong"));
    }
  }

  initCreatePaymentRequest(PaymentRequest paymentRequest,
      my_payment_method.PaymentMethod paymentMethod, CardInfo? cardInfo) async {
    emit(PaymentRequestCreateLoading());
    VerifyPaymentMethodResponse verifyPaymentMethodResponse =
        await _verifyPaymentMethod(
            paymentMethod: paymentMethod,
            cardInfo: cardInfo,
            amount: paymentRequest.amount,
            paymentMethodslugsToIgnore: []);
    if (verifyPaymentMethodResponse.paymentSetupError != null) {
      emit(verifyPaymentMethodResponse.paymentSetupError!);
    } else {
      try {
        ResidentProfile? residentProfile =
            await LocalDataLayer().getResidentProfileMe();
        PaymentRequest updatedPaymentRequest =
            await _networkRepo.createPayment(paymentRequest.id, {
          "payment_method_slug": paymentMethod.slug,
          "flat_id": residentProfile!.flat_id,
        });
        updatedPaymentRequest.setup();
        emit(PaymentRequestCreateLoaded(updatedPaymentRequest));
      } catch (e) {
        if (kDebugMode) {
          print("initCreatePaymentRequest: $e");
        }
        emit(PaymentRequestCreateFail(
            "Something went wrong", "something_wrong"));
      }
    }
  }

  initCreatePaymentRequestPaymentData(
      PaymentRequest paymentRequest, CardInfo? cardInfo) async {
    emit(CreatePaymentRequestPaymentDataLoading());
    VerifyPaymentMethodResponse verifyPaymentMethodResponse =
        await _verifyPaymentMethod(
            paymentMethod: paymentRequest.payment!.paymentMethod,
            cardInfo: cardInfo,
            amount: paymentRequest.amount,
            paymentMethodslugsToIgnore: ["cod"]);
    if (verifyPaymentMethodResponse.paymentSetupError != null) {
      emit(verifyPaymentMethodResponse.paymentSetupError!);
    } else {
      try {
        UserData? userData = await LocalDataLayer().getUserMe();
        emit(CreatePaymentRequestPaymentDataLoaded(
            paymentRequest,
            PaymentData(
              payment: paymentRequest.payment!,
              payuMeta: PayUMeta(
                name: userData!.name.replaceAll(' ', ''),
                mobile: userData.mobile_number.replaceAll(' ', ''),
                email: userData.email.replaceAll(' ', ''),
                bookingId: "${paymentRequest.payment!.id}",
                productinfo: (paymentRequest.title).replaceAll(' ', ''),
              ),
              stripeTokenId: verifyPaymentMethodResponse.stripeTokenId,
            )));
      } catch (e) {
        if (kDebugMode) {
          print("createAppointment: $e");
        }
        emit(CreatePaymentRequestPaymentDataFail(
            "Something went wrong", "something_wrong"));
      }
    }
  }

  initCreateAmenityAppointment(
      int amenityId,
      AmenityAppointmentRequest amenityAppointmentRequest,
      my_payment_method.PaymentMethod paymentMethod,
      CardInfo? cardInfo) async {
    emit(CreateUpdateAmenityAppointmentLoading());
    VerifyPaymentMethodResponse verifyPaymentMethodResponse =
        await _verifyPaymentMethod(
            paymentMethod: paymentMethod,
            cardInfo: cardInfo,
            amount: amenityAppointmentRequest.amount,
            paymentMethodslugsToIgnore: []);
    if (verifyPaymentMethodResponse.paymentSetupError != null) {
      emit(verifyPaymentMethodResponse.paymentSetupError!);
    } else {
      try {
        AmenityAppointment appointment = await _networkRepo
            .createAmenityAppointment(amenityId, amenityAppointmentRequest);
        appointment.setup();
        emit(CreateUpdateAmenityAppointmentLoaded(
            appointment,
            PaymentData(
              payment: appointment.payment!,
              payuMeta: PayUMeta(
                name: appointment.resident!.user!.name.replaceAll(' ', ''),
                mobile: appointment.resident!.user!.mobile_number
                    .replaceAll(' ', ''),
                email: appointment.resident!.user!.email.replaceAll(' ', ''),
                bookingId: "${appointment.id}",
                productinfo: (appointment.amenity!.title).replaceAll(' ', ''),
              ),
              stripeTokenId: verifyPaymentMethodResponse.stripeTokenId,
            )));
      } catch (e) {
        if (kDebugMode) {
          print("createAppointment: $e");
        }
        String errorMsg = "Something went wrong";
        String errorMsgKey = "something_wrong";
        // if (e is DioException &&
        //     (e).response != null &&
        //     (e).response!.data != null &&
        //     ((e).response!.data as Map<String, dynamic>)
        //         .containsKey("errors") &&
        //     ((e).response!.data["errors"] as Map<String, dynamic>)
        //         .containsKey("time_from")) {
        //   errorMsg = "Slot already booked";
        //   errorMsgKey = "slot_booked";
        // }
        if (e is DioException &&
            (e).response != null &&
            (e).response!.data != null &&
            ((e).response!.data as Map<String, dynamic>)
                .containsKey("message")) {
          errorMsg =
              "${((e).response!.data as Map<String, dynamic>)["message"]}";
          errorMsgKey = "slot_booked";
        }
        emit(CreateUpdateAmenityAppointmentFail(errorMsg, errorMsgKey));
      }
    }
  }

  initWalletDeposit(double amount,
      my_payment_method.PaymentMethod paymentMethod, CardInfo? cardInfo) async {
    emit(LoadingWalletDeposit());
    VerifyPaymentMethodResponse verifyPaymentMethodResponse =
        await _verifyPaymentMethod(
            paymentMethod: paymentMethod,
            cardInfo: cardInfo,
            amount: amount,
            paymentMethodslugsToIgnore: ["cod", "wallet"]);
    if (verifyPaymentMethodResponse.paymentSetupError != null) {
      emit(verifyPaymentMethodResponse.paymentSetupError!);
    } else {
      try {
        Payment payment =
            await _networkRepo.depositWallet("$amount", paymentMethod.slug!);
        UserData? userData = await LocalDataLayer().getUserMe();
        emit(WalletDepositLoaded(PaymentData(
          payment: payment,
          payuMeta: PayUMeta(
            name: userData!.name.replaceAll(' ', ''),
            mobile: userData.mobile_number.replaceAll(' ', ''),
            email: userData.email.replaceAll(' ', ''),
            bookingId: "${payment.id}",
            productinfo: "Wallet Recharge",
          ),
          stripeTokenId: verifyPaymentMethodResponse.stripeTokenId,
        )));
      } catch (e) {
        if (kDebugMode) {
          print("initWalletDeposit: $e");
        }
        emit(WalletDepositError("Something went wrong", "something_wrong"));
      }
    }
  }

  initProcessPayment(PaymentData paymentData) async {
    emit(ProcessingPaymentState());
    _currentPaymentMethod = (paymentData.payment.paymentMethod.slug ?? "");
    _currentPayment = paymentData.payment;
    switch (_currentPaymentMethod) {
      case "cod":
        emit(
            ProcessedPaymentState(PaymentStatus(true, _currentPaymentMethod!)));
        break;
      case "wallet":
        try {
          PaymentResponse paymentResponse =
              await _networkRepo.payThroughWallet(paymentData.payment.id);
          emit(ProcessedPaymentState(
              PaymentStatus(paymentResponse.success, _currentPaymentMethod!)));
        } catch (e) {
          if (kDebugMode) {
            print("processPayment wallet $e");
          }
          emit(ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod!)));
        }
        break;
      case "stripe":
        try {
          PaymentResponse paymentResponse = await _networkRepo.payThroughStripe(
              paymentData.payment.id, paymentData.stripeTokenId!);
          emit(ProcessedPaymentState(
              PaymentStatus(paymentResponse.success, _currentPaymentMethod!)));
        } catch (e) {
          if (kDebugMode) {
            print("processPayment stripe $e");
          }
          emit(ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod!)));
        }
        break;
      case "payu":
        try {
          String? key =
              paymentData.payment.paymentMethod.getMetaKey("public_key");
          String? salt =
              paymentData.payment.paymentMethod.getMetaKey("private_key");
          if (key != null && salt != null) {
            String name = paymentData.payuMeta!.name;
            String mobile = paymentData.payuMeta!.mobile;
            String email = paymentData.payuMeta!.email;
            String bookingId = paymentData.payuMeta!.bookingId;
            String productinfo = paymentData.payuMeta!.productinfo;
            String amt = "${paymentData.payment.amount}";
            String checksum =
                "$key|$bookingId|$amt|$productinfo|$name|$email|||||||||||$salt";
            var bytes = utf8.encode(checksum);
            Digest sha512Result = sha512.convert(bytes);
            String encrypttext = sha512Result.toString();
            String furl =
                "${AppConfig.baseUrl}api/payment/payu/${paymentData.payment.id}?result=failed";
            String surl =
                "${AppConfig.baseUrl}api/payment/payu/${paymentData.payment.id}?result=success";

            String url =
                "${AppConfig.baseUrl}assets/vendor/payment/payumoney/payuBiz.html?amt=$amt&name=$name&mobileNo=$mobile&email=$email&bookingId=$bookingId&productinfo=$productinfo&hash=$encrypttext&salt=$salt&key=$key&furl=$furl&surl=$surl";
            _sUrl = surl;
            _fUrl = furl;
            emit(LoadPaymentUrlState(url, surl, furl));
          } else {
            emit(ProcessedPaymentState(
                PaymentStatus(false, _currentPaymentMethod!)));
          }
        } catch (e) {
          if (kDebugMode) {
            print("processPayment payu $e");
          }
          emit(ProcessedPaymentState(
              PaymentStatus(false, _currentPaymentMethod!)));
        }
        break;
      case "paystack":
        String url =
            "${AppConfig.baseUrl}api/payment/paystack/${paymentData.payment.id}";
        _sUrl =
            "${AppConfig.baseUrl}api/payment/paystack/callback/${paymentData.payment.id}?result=success";
        _fUrl =
            "${AppConfig.baseUrl}api/payment/paystack/callback/${paymentData.payment.id}?result=error";
        emit(LoadPaymentUrlState(url, _sUrl!, _fUrl!));
        break;
      default:
        if (kDebugMode) {
          print("processPayment unknown payment method");
        }
        emit(ProcessedPaymentState(
            PaymentStatus(false, _currentPaymentMethod!)));
        break;
    }
  }

  setPaymentProcessed(bool paid) async {
    emit(ProcessingPaymentState());
    if (!paid) {
      await _networkRepo.postUrl(
          "${AppConfig.baseUrl}api/payment/generic/${_currentPayment?.id}/failed",
          {});
    }
    emit(ProcessedPaymentState(PaymentStatus(paid, _currentPaymentMethod!)));
  }

  Future<stripe.TokenData> _genStripeTokenData(String stripePublishableKey,
      CardInfo cardInfo, stripe.CreateTokenParams createTokenParams) async {
    stripe.Stripe.publishableKey = stripePublishableKey;
    await stripe.Stripe.instance.dangerouslyUpdateCardDetails(
        stripe.CardDetails().copyWith(
            number: cardInfo.cardNumber,
            expirationMonth: cardInfo.cardMonth,
            expirationYear: cardInfo.cardYear,
            cvc: cardInfo.cardCvv));
    return stripe.Stripe.instance.createToken(createTokenParams);
  }

  Future<VerifyPaymentMethodResponse> _verifyPaymentMethod({
    required my_payment_method.PaymentMethod paymentMethod,
    required double amount,
    required List<String> paymentMethodslugsToIgnore,
    CardInfo? cardInfo,
  }) async {
    if (paymentMethodslugsToIgnore.contains(paymentMethod.slug) ||
        !_supportedPaymentGatewaySlugs.contains(paymentMethod.slug)) {
      return VerifyPaymentMethodResponse(
        stripeTokenId: null,
        paymentSetupError:
            PaymentSetupError("Payment not setup", "payment_setup_not"),
      );
    }
    VerifyPaymentMethodResponse toReturn = VerifyPaymentMethodResponse(
      stripeTokenId: null,
      paymentSetupError: null,
    );
    try {
      switch (paymentMethod.slug) {
        case "wallet":
          try {
            WalletBalance walletBalance = await _networkRepo.getWalletBalance();
            if (amount > (walletBalance.balance ?? 0)) {
              toReturn.paymentSetupError = PaymentSetupError(
                  "Insufficient wallet balance", "insufficient_wallet");
            }
          } catch (e) {
            if (kDebugMode) {
              print("paythroughwallet: $e");
            }
            toReturn.paymentSetupError = PaymentSetupError(
                "Insufficient wallet balance", "insufficient_wallet");
          }
          break;
        case "stripe":
          try {
            String? stripePublishableKey =
                paymentMethod.getMetaKey("public_key");
            UserData? userData = await LocalDataLayer().getUserMe();
            if (stripePublishableKey != null) {
              if (userData != null) {
                stripe.TokenData tokenData = await _genStripeTokenData(
                    stripePublishableKey,
                    cardInfo!,
                    stripe.CreateTokenParams.card(
                        params: stripe.CardTokenParams(
                      name: userData.name,
                      address: stripe.Address(
                        line1: "user ${userData.id} wallet.",
                        line2: null,
                        city: null,
                        country: null,
                        postalCode: null,
                        state: null,
                      ),
                    )));
                toReturn.stripeTokenId = tokenData.id;
              } else {
                toReturn.paymentSetupError = PaymentSetupError(
                    "Card verification failed", "card_verification_fail");
              }
            } else {
              toReturn.paymentSetupError =
                  PaymentSetupError("Payment setup fail", "payment_setup_fail");
            }
          } catch (e) {
            if (kDebugMode) {
              print("StripePaymentError: $e");
            }
            toReturn.paymentSetupError = PaymentSetupError(
                "Card verification failed", "card_verification_fail");
          }
          break;
        case "payu":
          try {
            String? key = paymentMethod.getMetaKey("public_key");
            String? salt = paymentMethod.getMetaKey("private_key");
            if (key == null || salt == null) {
              toReturn.paymentSetupError =
                  PaymentSetupError("Payment setup fail", "payment_setup_fail");
            }
          } catch (e) {
            if (kDebugMode) {
              print("PayuPaymentError: $e");
            }
            toReturn.paymentSetupError =
                PaymentSetupError("Payment setup fail", "payment_setup_fail");
          }
          break;
      }
    } catch (e) {
      if (kDebugMode) {
        print("verifyPaymentMethod: $e");
      }
      toReturn.paymentSetupError =
          PaymentSetupError("Something went wrong", "something_wrong");
    }
    return toReturn;
  }
}

class VerifyPaymentMethodResponse {
  PaymentSetupError? paymentSetupError;
  String? stripeTokenId;

  VerifyPaymentMethodResponse(
      {required this.paymentSetupError, required this.stripeTokenId});
}

class PaymentData {
  final Payment payment;
  final PayUMeta? payuMeta;
  final String? stripeTokenId;

  PaymentData({required this.payment, this.payuMeta, this.stripeTokenId});

  @override
  String toString() =>
      'PaymentData(payment: $payment, payuMeta: $payuMeta, stripeTokenId: $stripeTokenId)';
}

class PayUMeta {
  final String name, mobile, email, bookingId, productinfo;

  PayUMeta(
      {required this.name,
      required this.mobile,
      required this.email,
      required this.bookingId,
      required this.productinfo});
}
