import 'package:flutter/material.dart';
import 'package:gateapp_user/bloc/payment_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';

class PaymentResultPage extends StatelessWidget {
  const PaymentResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    PaymentStatus? paymentStatus =
        ModalRoute.of(context)!.settings.arguments as PaymentStatus?;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Spacer(),
          Image.asset(
            paymentStatus != null && paymentStatus.isPaid
                ? "assets/allowed.png"
                : "assets/declined.png",
            height: 120,
          ),
          Center(
            child: Text(
              AppLocalization.instance.getLocalizationFor(
                  paymentStatus != null && paymentStatus.isPaid
                      ? "paymentSuccessful"
                      : "paymentFailed"),
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 18,
                color: paymentStatus != null && paymentStatus.isPaid
                    ? const Color(0xff5faf1e)
                    : const Color(0xffe31b1b),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          Center(
            child: Image.asset(
              "assets/watermark.png",
              color: theme.hintColor,
              height: 18,
            ),
          ),
          const SizedBox(height: 44),
        ],
      ),
    );
  }
}
