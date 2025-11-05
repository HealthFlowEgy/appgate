import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/payment_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/payment_request.dart';
import 'package:gateapp_user/models/payment_method.dart' as my_payment_method;
import 'package:gateapp_user/widgets/card_picker.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class AddPaymentRequestPage extends StatelessWidget {
  const AddPaymentRequestPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => PaymentCubit(),
        child: AddPaymentRequestStateful(
            ModalRoute.of(context)!.settings.arguments as PaymentRequest),
      );
}

class AddPaymentRequestStateful extends StatefulWidget {
  final PaymentRequest paymentRequest;
  const AddPaymentRequestStateful(this.paymentRequest, {super.key});

  @override
  State<AddPaymentRequestStateful> createState() =>
      _AddPaymentRequestStatefulState();
}

class _AddPaymentRequestStatefulState extends State<AddPaymentRequestStateful> {
  bool _isLoading = true;
  List<my_payment_method.PaymentMethod> paymentMethods = [];
  my_payment_method.PaymentMethod? paymentMethodSelected;
  @override
  void initState() {
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
        if (state is PaymentRequestCreateLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }

        if (state is PaymentRequestCreateLoaded) {
          Navigator.pop(context, state.paymentRequest);
        }
        if (state is PaymentRequestCreateFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
          Navigator.pop(context);
        }
        if (state is PaymentSetupError) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
          Navigator.pop(context);
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
                      ),
                      color: theme.colorScheme.background,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 20,
                            top: 20,
                            bottom: 14,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.paymentRequest.title,
                                    style: theme.textTheme.bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Text(
                                widget.paymentRequest.amountToShow,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          top: 0,
                          end: 0,
                          child: Container(
                            alignment: Alignment.center,
                            height: 28,
                            width: 90,
                            decoration: BoxDecoration(
                              color: widget.paymentRequest.status == "paid"
                                  ? const Color(0xff5faf1e)
                                  : widget.paymentRequest.status == "failed"
                                      ? const Color(0xffe31b1b)
                                      : const Color(0xffe3bb1b),
                              borderRadius: const BorderRadiusDirectional.only(
                                topEnd: Radius.circular(12),
                                bottomStart: Radius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppLocalization.instance
                                  .getLocalizationFor(
                                      "payment_request_status_${widget.paymentRequest.status}")
                                  .toUpperCase(),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.scaffoldBackgroundColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: theme.hintColor,
                              ),
                              children: [
                                TextSpan(
                                    text: AppLocalization.instance
                                        .getLocalizationFor("dueDate")),
                                TextSpan(
                                  text:
                                      " ${widget.paymentRequest.dueDateFormatted ?? ""}",
                                  style: TextStyle(color: theme.primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
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
            onTap: () {
              if (paymentMethodSelected == null) {
                Toaster.showToastCenter(AppLocalization.instance
                    .getLocalizationFor("select_payment_method"));
              } else {
                CardInfo? cardInfo;
                if (paymentMethodSelected!.slug == "stripe") {
                  CardPicker.getSavedCard().then((CardInfo? savedCard) {
                    CardPicker.pickCard(context, savedCard, true).then((value) {
                      cardInfo = value;
                      if (mounted) {
                        if (cardInfo != null) {
                          BlocProvider.of<PaymentCubit>(context)
                              .initCreatePaymentRequest(widget.paymentRequest,
                                  paymentMethodSelected!, cardInfo);
                        } else {
                          Toaster.showToastCenter(AppLocalization.instance
                              .getLocalizationFor("card_invalid_card"));
                        }
                      }
                    });
                  });
                } else {
                  BlocProvider.of<PaymentCubit>(context)
                      .initCreatePaymentRequest(widget.paymentRequest,
                          paymentMethodSelected!, cardInfo);
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
}
