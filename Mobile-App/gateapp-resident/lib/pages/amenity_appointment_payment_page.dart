// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/payment_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/amenity.dart';
import 'package:gateapp_user/models/amenity_appointment_request.dart';
import 'package:gateapp_user/utility/app_settings.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/card_picker.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/models/payment_method.dart' as my_payment_method;
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AmenityAppointmentPaymentPage extends StatelessWidget {
  const AmenityAppointmentPaymentPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => PaymentCubit(),
        child: AmenityAppointmentPaymentStateful(
            arguments: ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>),
      );
}

class AmenityAppointmentPaymentStateful extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const AmenityAppointmentPaymentStateful({
    super.key,
    required this.arguments,
  });

  @override
  State<AmenityAppointmentPaymentStateful> createState() =>
      _AmenityAppointmentPaymentStatefulState();
}

class _AmenityAppointmentPaymentStatefulState
    extends State<AmenityAppointmentPaymentStateful> {
  late Amenity amenity;
  late int days;
  late double amount;
  late String date_from;
  late String date_to;
  late String time_from;
  late String time_to;

  bool _isLoading = true;
  List<my_payment_method.PaymentMethod> paymentMethods = [];
  my_payment_method.PaymentMethod? paymentMethodSelected;

  @override
  void initState() {
    amenity = widget.arguments["amenity"];
    days = widget.arguments["days"];
    amount = widget.arguments["amount"];
    DateTime dateTimeFrom = widget.arguments["date_time_from"];
    date_from = DateFormat("yyyy-MM-dd").format(dateTimeFrom);
    time_from = DateFormat("HH:mm").format(dateTimeFrom);
    DateTime dateTimeTo = widget.arguments["date_time_to"];
    date_to = DateFormat("yyyy-MM-dd").format(dateTimeTo);
    time_to = DateFormat("HH:mm").format(dateTimeTo);

    super.initState();
    BlocProvider.of<PaymentCubit>(context).initFetchPaymentMethods([]);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentMethodsLoaded) {
          paymentMethods = state.listPayment;
          _isLoading = false;
          setState(() {});
        }
        if (state is PaymentMethodsError) {
          _isLoading = false;
          setState(() {});
        }

        if (state is CreateUpdateAmenityAppointmentLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is CreateUpdateAmenityAppointmentLoaded) {
          Toaster.showToastBottom(getLocalizationFor("appointment_created"));
          if (state.paymentData?.payment.paymentMethod.slug == "cod") {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else {
            Navigator.pushNamed(
              context,
              PageRoutes.processPaymentPage,
              arguments: state.paymentData,
            ).then(
              (paymentStatus) => Navigator.pushNamed(
                context,
                PageRoutes.paymentResultPage,
                arguments: paymentStatus,
              ).then((value) =>
                  Navigator.popUntil(context, (route) => route.isFirst)),
            );
          }
        }
        if (state is CreateUpdateAmenityAppointmentFail) {
          Toaster.showToastCenter(state.message);
        }
        if (state is PaymentSetupError) {
          Toaster.showToastCenter(getLocalizationFor(state.messageKey));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalization.instance.getLocalizationFor("payments"),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 30,
          ),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 0.5,
                  color: theme.hintColor.withOpacity(0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                        bottom: Radius.circular(12),
                      ),
                      color: theme.colorScheme.background,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 20,
                            end: 20,
                            top: 20,
                            bottom: 14,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      AppLocalization.instance
                                          .getLocalizationFor("amountToPay"),
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Text(
                                    "${AppSettings.currencyIcon} ${amount.toStringAsFixed(1)}",
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      amenity.title,
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.hintColor.withOpacity(0.7),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "$days ${AppLocalization.instance.getLocalizationFor("days")}",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor.withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const Divider(height: 1),
                  // const SizedBox(height: 12),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (paymentMethods.isNotEmpty)
              Text(
                AppLocalization.instance
                    .getLocalizationFor("selectPaymentMethod"),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 15,
                  color: theme.hintColor.withOpacity(0.7),
                ),
              ),
            if (paymentMethods.isNotEmpty) const SizedBox(height: 20),
            for (my_payment_method.PaymentMethod pm in paymentMethods)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: theme.hintColor.withOpacity(0.2)),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => setState(() => paymentMethodSelected = pm),
                  child: Row(
                    children: [
                      Image.asset(
                        _getPaymentMethodImage(pm),
                        height: 35,
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Text(
                          pm.title ?? "",
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontSize: 15),
                        ),
                      ),
                      Radio<my_payment_method.PaymentMethod>(
                        fillColor:
                            MaterialStateProperty.all(theme.primaryColor),
                        value: pm,
                        groupValue: paymentMethodSelected,
                        onChanged: (my_payment_method.PaymentMethod? val) {},
                      ),
                    ],
                  ),
                ),
              ),
            if (paymentMethods.isEmpty && _isLoading)
              Loader.loadingWidget(context: context),
            if (paymentMethods.isEmpty && !_isLoading)
              ErrorFinalWidget.errorWithRetry(
                context: context,
                message: AppLocalization.instance
                    .getLocalizationFor("empty_payment_methods"),
                imageAsset: "assets/empty_results.png",
              ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomButton(
            title: AppLocalization.instance.getLocalizationFor("confirmAndPay"),
            onTap: () async {
              if (paymentMethodSelected == null) {
                Toaster.showToastCenter(AppLocalization.instance
                    .getLocalizationFor("select_payment_method"));
              } else {
                CardInfo? cardInfo;
                if (paymentMethodSelected?.slug == "stripe") {
                  CardInfo? savedCard = await CardPicker.getSavedCard();
                  cardInfo =
                      await CardPicker.pickCard(context, savedCard, true);
                  if (cardInfo != null) {
                    _placeAppointment(cardInfo);
                  } else {
                    Toaster.showToastCenter(AppLocalization.instance
                        .getLocalizationFor("card_invalid_card"));
                  }
                } else {
                  _placeAppointment(cardInfo);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  String _getPaymentMethodImage(my_payment_method.PaymentMethod pm) {
    switch (pm.slug) {
      case "stripe":
        return "assets/payment_methods/payment_credit.png";
      case "paypal":
        return "assets/payment_methods/payment_paypal.png";
      default:
        return "assets/payment_methods/payment_online.png";
    }
  }

  _placeAppointment(CardInfo? cardInfo) {
    LocalDataLayer().getResidentProfileMe().then((value) {
      if (value != null) {
        AmenityAppointmentRequest amenityAppointmentRequest =
            AmenityAppointmentRequest(
          time_from: time_from,
          time_to: time_to,
          date_to: date_to,
          date: date_from,
          amount: amount,
          resident_id: value.id,
          payment_method_slug: paymentMethodSelected?.slug ?? "cod",
        );
        BlocProvider.of<PaymentCubit>(context).initCreateAmenityAppointment(
            amenity.id,
            amenityAppointmentRequest,
            paymentMethodSelected!,
            cardInfo);
      }
    });
  }
}
