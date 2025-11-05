import 'dart:async';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/bloc/app_cubit.dart';
import 'package:gateapp_guard/bloc/auth_cubit.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/widgets/custom_button.dart';
import 'package:gateapp_guard/widgets/entry_field.dart';
import 'package:gateapp_guard/widgets/loader.dart';
import 'package:gateapp_guard/widgets/toaster.dart';

class AuthVerificationPage extends StatelessWidget {
  final String phoneNumber;
  final GlobalKey<_VerificationUIState> _verificationUiKey = GlobalKey();
  AuthVerificationPage(this.phoneNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => AuthCubit()..initAuthentication(phoneNumber),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is VerificationLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is VerificationSentLoaded) {
              if (_verificationUiKey.currentState != null) {
                _verificationUiKey.currentState!._startTimer();
              }
              Toaster.showToastBottom(
                  AppLocalization.instance.getLocalizationFor("code_sent"));
              if (AppConfig.isDemoMode && phoneNumber.contains("9898989898")) {
                BlocProvider.of<AuthCubit>(context).verifyOtp("123456");
              }
            } else if (state is VerificationVerifyingLoaded) {
              Navigator.pop(context);
              BlocProvider.of<AppCubit>(context).initAuthenticated();
            } else if (state is VerificationError) {
              Toaster.showToastBottom(AppLocalization.instance
                  .getLocalizationFor(state.messageKey));
              // if (state.messageKey == "something_wrong" ||
              //     state.messageKey == "role_exists") {
              //   Navigator.of(context).pop();
              // }
            }
          },
          child: VerificationUI(
            phoneNumber,
            key: _verificationUiKey,
          ),
        ),
      );
}

class VerificationUI extends StatefulWidget {
  final String phoneNumber;
  const VerificationUI(this.phoneNumber, {super.key});

  @override
  State<VerificationUI> createState() => _VerificationUIState();
}

class _VerificationUIState extends State<VerificationUI> {
  final TextEditingController _otpController = TextEditingController();
  int _counter = 60;
  late Timer _timer;

  _startTimer() {
    _counter = 60;
    _timer = Timer.periodic(const Duration(seconds: 1),
        (timer) => setState(() => _counter > 0 ? _counter-- : _timer.cancel()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideDuration: const Duration(milliseconds: 300),
        slideCurve: Curves.linearToEaseOut,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              AppLocalization.instance.getLocalizationFor("verification"),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalization.instance
                  .getLocalizationFor("enterVerificationCode"),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 50),
            EntryField(
              label: AppLocalization.instance.getLocalizationFor("enterOtp"),
              hintText: '',
              controller: _otpController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 50),
            CustomButton(
              title: AppLocalization.instance.getLocalizationFor("submit"),
              onTap: () {
                if (_otpController.text.trim().isEmpty) {
                  Toaster.showToastCenter(AppLocalization.instance
                      .getLocalizationFor("otp_invalid"));
                  return;
                }
                BlocProvider.of<AuthCubit>(context)
                    .verifyOtp(_otpController.text.trim());
              },
            ),
            const SizedBox(height: 36),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "$_counter ${AppLocalization.instance.getLocalizationFor('sec')}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor.withOpacity(0.5),
                      fontSize: 15,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_counter < 1) {
                      BlocProvider.of<AuthCubit>(context)
                          .initAuthentication(widget.phoneNumber);
                    }
                  },
                  child: Text(
                    AppLocalization.instance
                        .getLocalizationFor("resend")
                        .toUpperCase(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      // color: theme.hintColor.withOpacity(0.5),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
