import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/bloc/app_cubit.dart';
import 'package:gateapp_guard/bloc/auth_cubit.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/widgets/confirm_dialog.dart';
import 'package:gateapp_guard/widgets/custom_button.dart';
import 'package:gateapp_guard/widgets/entry_field.dart';
import 'package:gateapp_guard/widgets/loader.dart';
import 'package:gateapp_guard/widgets/toaster.dart';

import 'auth_verification_page.dart';

class AuthSignInPage extends StatelessWidget {
  const AuthSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is LoginLoaded) {
              gotoHome(context);
            } else if (state is LoginExistsLoaded) {
              if (state.isRegistered) {
                gotoVerification(
                    context, state.phoneNumberData.phoneNumberNormalised!);
              } else {
                gotoRegistration(context,
                    RegisterData(null, null, null, state.phoneNumberData));
              }
            } else if (state is LoginErrorSocial) {
              if (state.loginName != null &&
                  state.loginName!.isNotEmpty &&
                  state.loginEmail != null &&
                  state.loginEmail!.isNotEmpty) {
                Toaster.showToastBottom(AppLocalization.instance
                    .getLocalizationFor(state.messageKey));
                gotoRegistration(
                    context,
                    RegisterData(state.loginName!, state.loginEmail!,
                        state.loginImageUrl, null));
              } else {
                Toaster.showToastBottom(AppLocalization.instance
                    .getLocalizationFor("something_wrong"));
              }
              if (kDebugMode) {
                print("login_error_social: $state");
              }
            } else if (state is LoginError) {
              Toaster.showToastBottom(AppLocalization.instance
                  .getLocalizationFor(state.messageKey));
              if (kDebugMode) {
                print("login_error: $state");
              }
            }
          },
          child: const SignInUi(),
        ),
      );

  void gotoHome(BuildContext context) {
    BlocProvider.of<AppCubit>(context).initAuthenticated();
  }

  void gotoVerification(
          BuildContext context, String phoneNumber) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuthVerificationPage(phoneNumber)));

  void gotoRegistration(BuildContext context, RegisterData registerData) =>
      Toaster.showToastBottom(
          AppLocalization.instance.getLocalizationFor("profile_na"));
  // Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => AuthSignUpPage(registerData)));
}

class SignInUi extends StatefulWidget {
  const SignInUi({super.key});

  @override
  State<SignInUi> createState() => _SignInUiState();
}

class _SignInUiState extends State<SignInUi> {
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  String? _dialCode, _isoCode;

  @override
  void initState() {
    if (AppConfig.isDemoMode) {
      _isoCode = "IN";
      _dialCode = '+91';
      _numberController.text = "8787878787";
      _countryController.text = "India";

      Future.delayed(
          const Duration(seconds: 1),
          () => showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(AppLocalization.instance
                      .getLocalizationFor("demo_login_title")),
                  content: Text(AppLocalization.instance
                      .getLocalizationFor("demo_login_message")),
                  actions: <Widget>[
                    MaterialButton(
                      textColor: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white70)),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                          AppLocalization.instance.getLocalizationFor("okay")),
                    ),
                  ],
                ),
              ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: FadedSlideAnimation(
        beginOffset: const Offset(0, 0.3),
        endOffset: const Offset(0, 0),
        slideDuration: const Duration(milliseconds: 300),
        slideCurve: Curves.linearToEaseOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 9),
              Image.asset(
                'assets/logo_main.png',
                height: 120,
              ),
              const Spacer(flex: 14),
              Text(
                AppLocalization.instance.getLocalizationFor("heyMate"),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 15,
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalization.instance.getLocalizationFor("signInNow"),
                style: theme.textTheme.titleLarge,
              ),
              const Spacer(flex: 5),
              Stack(
                children: [
                  EntryField(
                      hintText: AppLocalization.instance
                          .getLocalizationFor("choose_country"),
                      label: AppLocalization.instance
                          .getLocalizationFor("choose_country"),
                      controller: _countryController),
                  SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: CountryCodePicker(
                      initialSelection: '91',
                      hideMainText: true,
                      dialogTextStyle: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.black),
                      textStyle: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.black),
                      searchStyle: theme.textTheme.bodyLarge!
                          .copyWith(color: Colors.black),
                      searchDecoration: const InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                      onChanged: (value) {
                        if ((_dialCode == null ||
                                value.dialCode != _dialCode) ||
                            (_isoCode == null || value.code != _isoCode)) {
                          _dialCode = value.dialCode;
                          _isoCode = value.code;
                          _countryController.text = value.name ?? "";

                          _numberController.clear();
                          setState(() {});
                        }
                      },
                      dialogSize: Size(MediaQuery.of(context).size.width * 0.8,
                          MediaQuery.of(context).size.height * 0.8),
                      showFlag: false,
                      showFlagDialog: true,
                      favorite: const ['+91', 'US'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              EntryField(
                hintText: (_dialCode != null && _dialCode!.isNotEmpty)
                    ? "${AppLocalization.instance.getLocalizationFor("enter_phone_exluding")} $_dialCode"
                    : AppLocalization.instance
                        .getLocalizationFor("enter_phone"),
                label: (_dialCode != null && _dialCode!.isNotEmpty)
                    ? "${AppLocalization.instance.getLocalizationFor("enter_phone_exluding")} $_dialCode"
                    : AppLocalization.instance
                        .getLocalizationFor("enter_phone"),
                controller: _numberController,
                keyboardType: TextInputType.phone,
              ),
              const Spacer(flex: 4),
              CustomButton(
                title: AppLocalization.instance.getLocalizationFor("continuee"),
                onTap: () => _checkAndLogin(),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSocialButton(
    BuildContext context,
    String image,
    String title,
  ) =>
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).hintColor.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 18,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );

  _checkAndLogin() async {
    if (_dialCode == null || _dialCode!.isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("choose_country"));
      return;
    }
    if (_numberController.text.trim().isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_phone"));
      return;
    }
    ConfirmDialog.showConfirmation(
            context,
            Text("$_dialCode${_numberController.text.trim()}"),
            Text(AppLocalization.instance.getLocalizationFor("alert_phone")),
            AppLocalization.instance.getLocalizationFor("no"),
            AppLocalization.instance.getLocalizationFor("yes"))
        .then((value) {
      if (value != null && value == true) {
        BlocProvider.of<AuthCubit>(context).initLoginPhone(PhoneNumberData(
            _countryController.text,
            _isoCode,
            _dialCode,
            _numberController.text,
            null));
      }
    });
  }
}
