import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/bloc/payment_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/payment_request.dart';
import 'package:gateapp_user/widgets/card_picker.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class PaymentRequestsPage extends StatelessWidget {
  const PaymentRequestsPage({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => FetcherCubit()),
          BlocProvider(create: (context) => PaymentCubit()),
        ],
        child: const PaymentRequestsStateful(),
      );
}

class PaymentRequestsStateful extends StatefulWidget {
  const PaymentRequestsStateful({super.key});

  @override
  State<PaymentRequestsStateful> createState() =>
      _PaymentRequestsStatefulState();
}

class _PaymentRequestsStatefulState extends State<PaymentRequestsStateful> {
  final List<PaymentRequest> _paymentRequests = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchPaymentRequests(1);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<FetcherCubit, FetcherState>(
          listener: (context, state) {
            if (state is PaymentRequestsLoaded) {
              _isLoading = false;
              _page = state.paymentRequestsResponse.meta.current_page ?? 1;
              _allDone = state.paymentRequestsResponse.meta.current_page ==
                  state.paymentRequestsResponse.meta.last_page;
              if (state.paymentRequestsResponse.meta.current_page == 1) {
                _paymentRequests.clear();
              }
              _paymentRequests.addAll(state.paymentRequestsResponse.data);
              setState(() {});
            }
            if (state is PaymentRequestsFail) {
              _isLoading = false;
              setState(() {});
            }
          },
        ),
        BlocListener<PaymentCubit, PaymentState>(
          listener: (context, state) {
            if (state is CreatePaymentRequestPaymentDataLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is CreatePaymentRequestPaymentDataLoaded) {
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
            if (state is CreatePaymentRequestPaymentDataFail) {
              Toaster.showToastCenter(
                  AppLocalization.instance.getLocalizationFor(state.messageKey),
                  state.messageKey != "something_wrong");
            }
            if (state is PaymentSetupError) {
              Toaster.showToastCenter(
                  AppLocalization.instance.getLocalizationFor(state.messageKey),
                  state.messageKey != "something_wrong");
            }
          },
        ),
      ],
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
        body: RefreshIndicator(
          onRefresh: () => BlocProvider.of<FetcherCubit>(context)
              .initFetchPaymentRequests(1),
          child: _paymentRequests.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 30,
                    bottom: 100,
                  ),
                  itemCount: _paymentRequests.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index == _paymentRequests.length - 1 &&
                        !_isLoading &&
                        !_allDone) {
                      _isLoading = true;
                      BlocProvider.of<FetcherCubit>(context)
                          .initFetchPaymentRequests(_page + 1);
                    }
                    return GestureDetector(
                      onTap: () =>
                          _onPaymentRequestTap(_paymentRequests[index]),
                      child: Container(
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              _paymentRequests[index].title,
                                              style: theme.textTheme.bodyLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          _paymentRequests[index].amountToShow,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
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
                                        color: _paymentRequests[index].status ==
                                                "paid"
                                            ? const Color(0xff5faf1e)
                                            : _paymentRequests[index].status ==
                                                    "failed"
                                                ? const Color(0xffe31b1b)
                                                : const Color(0xffe3bb1b),
                                        borderRadius:
                                            const BorderRadiusDirectional.only(
                                          topEnd: Radius.circular(12),
                                          bottomStart: Radius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalization.instance
                                            .getLocalizationFor(
                                                "payment_request_status_${_paymentRequests[index].status}")
                                            .toUpperCase(),
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: theme.hintColor,
                                        ),
                                        children: [
                                          TextSpan(
                                              text: AppLocalization.instance
                                                  .getLocalizationFor(
                                                      _paymentRequests[index]
                                                                      .status ==
                                                                  "paid" &&
                                                              _paymentRequests[
                                                                          index]
                                                                      .paidOnFormatted !=
                                                                  null
                                                          ? "paidOn"
                                                          : "dueDate")),
                                          TextSpan(
                                            text:
                                                " ${(_paymentRequests[index].status == "paid" && _paymentRequests[index].paidOnFormatted != null ? _paymentRequests[index].paidOnFormatted : _paymentRequests[index].dueDateFormatted) ?? ""}",
                                            style: TextStyle(
                                                color: theme.primaryColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_paymentRequests[index].status !=
                                          "paid" &&
                                      _paymentRequests[index]
                                              .payment
                                              ?.paymentMethod
                                              .slug !=
                                          "cod")
                                    const Icon(
                                      Icons.local_atm,
                                      size: 20,
                                      color: Color(0xff5faf1e),
                                    ),
                                  const SizedBox(width: 10),
                                  if (_paymentRequests[index].status !=
                                          "paid" &&
                                      _paymentRequests[index]
                                              .payment
                                              ?.paymentMethod
                                              .slug !=
                                          "cod")
                                    Text(
                                      AppLocalization.instance
                                          .getLocalizationFor("payNow"),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: const Color(0xff5faf1e),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : ListView(
                  children: [
                    _isLoading
                        ? Loader.loadingWidget(context: context)
                        : ErrorFinalWidget.errorWithRetry(
                            context: context,
                            message: AppLocalization.instance
                                .getLocalizationFor("empty_payment_requests"),
                            imageAsset: "assets/plc_profile.png",
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  _onPaymentRequestTap(PaymentRequest paymentRequest) {
    if (paymentRequest.status != "paid") {
      if (paymentRequest.payment != null) {
        _handleProcessPayment(paymentRequest);
      } else {
        Navigator.pushNamed(context, PageRoutes.addPaymentRequestPage,
                arguments: paymentRequest)
            .then((value) {
          if (value != null && value is PaymentRequest) {
            int eIndex = _paymentRequests.indexOf(value);
            if (eIndex != -1) {
              _paymentRequests[eIndex] = value;
              setState(() {});
            }
            _onPaymentRequestTap(value);
          }
        });
      }
    }
  }

  _handleProcessPayment(PaymentRequest paymentRequest) {
    if (paymentRequest.payment!.paymentMethod.slug != "cod") {
      CardInfo? cardInfo;
      if (paymentRequest.payment!.paymentMethod.slug == "stripe") {
        CardPicker.getSavedCard().then((CardInfo? savedCard) {
          CardPicker.pickCard(context, savedCard, true).then((value) {
            cardInfo = value;
            if (mounted) {
              if (cardInfo != null) {
                BlocProvider.of<PaymentCubit>(context)
                    .initCreatePaymentRequestPaymentData(
                        paymentRequest, cardInfo);
              } else {
                Toaster.showToastCenter(AppLocalization.instance
                    .getLocalizationFor("card_invalid_card"));
              }
            }
          });
        });
      } else {
        BlocProvider.of<PaymentCubit>(context)
            .initCreatePaymentRequestPaymentData(paymentRequest, cardInfo);
      }
    }
  }
}
