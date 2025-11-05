// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/auth_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/utility/firebase_uploader.dart';
import 'package:gateapp_user/utility/picker.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/confirm_dialog.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

import 'auth_verification_page.dart';

class AuthSignUpPage extends StatelessWidget {
  final RegisterData registerRequest;

  const AuthSignUpPage(this.registerRequest, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is RegisterLoaded) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AuthVerificationPage(
                          state.authResponse.user.mobile_number)));
            } else if (state is RegisterError) {
              Toaster.showToastBottom(AppLocalization.instance
                  .getLocalizationFor(state.messageKey));
              if (kDebugMode) {
                print("register_error: ${state.messageKey}");
              }
            }
          },
          child: SignUpUI(registerRequest),
        ),
      );
}

class SignUpUI extends StatefulWidget {
  final RegisterData registerData;
  const SignUpUI(this.registerData, {super.key});

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  late TextEditingController _nameController,
      _emailController,
      _phoneController,
      // ignore: unused_field
      _countryController;
  String? _isoCode, _dialCode;

  File? _filePicked;
  final Set<String> _firebaseStorageCleanupRef = {};

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.registerData.name);
    _emailController = TextEditingController(text: widget.registerData.email);
    if (widget.registerData.phoneNumberData != null) {
      _phoneController = TextEditingController(
          text: widget.registerData.phoneNumberData!.phoneNumber);
      _countryController = TextEditingController(
          text: widget.registerData.phoneNumberData!.countryText);
      _isoCode = widget.registerData.phoneNumberData!.isoCode;
      _dialCode = widget.registerData.phoneNumberData!.dialCode;
    } else {
      _phoneController = TextEditingController();
      _countryController = TextEditingController();
    }
    super.initState();
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      AppLocalization.instance.getLocalizationFor("signUpNow"),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalization.instance
                          .getLocalizationFor("youReNotRegistered"),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Stack(
                      children: [
                        CachedImage(
                          radius: 42,
                          imageUrl: widget.registerData.imageUrl,
                          imagePlaceholder: "assets/plc_profile.png",
                          height: 85,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () async {
                              _filePicked = await Picker().pickImageFile(
                                context: context,
                                pickerSource: PickerSource.ask,
                                restrictSquare: true,
                              );
                              if (_filePicked != null && mounted) {
                                String dpRef =
                                    "dp_user_id_${DateTime.now().millisecondsSinceEpoch}";
                                widget.registerData.imageUrl =
                                    await FirebaseUploader.uploadFile(
                                  context,
                                  _filePicked!,
                                  AppLocalization.instance
                                      .getLocalizationFor("uploading"),
                                  AppLocalization.instance
                                      .getLocalizationFor("just_moment"),
                                  dpRef,
                                );
                                if (widget.registerData.imageUrl != null) {
                                  _firebaseStorageCleanupRef.add(dpRef);
                                } else {
                                  _filePicked = null;
                                }
                                setState(() {});
                              }
                            },
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: theme.primaryColor,
                              child: Icon(
                                Icons.camera_alt,
                                color: theme.scaffoldBackgroundColor,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    EntryField(
                      label: AppLocalization.instance
                          .getLocalizationFor("phoneNumber"),
                      hintText: '',
                      initialValue: "$_dialCode${_phoneController.text.trim()}",
                      readOnly: true,
                    ),
                    const SizedBox(height: 40),
                    EntryField(
                      label: AppLocalization.instance
                          .getLocalizationFor("fullName"),
                      hintText: '',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 40),
                    EntryField(
                      label: AppLocalization.instance
                          .getLocalizationFor("emailAddress"),
                      hintText: '',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 24,
              child: CustomButton(
                title: AppLocalization.instance.getLocalizationFor("continuee"),
                onTap: () => _checkAndRegister(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (String refToCleanup in _firebaseStorageCleanupRef) {
      FirebaseUploader.deleteRef(refToCleanup);
    }
    super.dispose();
  }

  _checkAndRegister(BuildContext context) async {
    if (_nameController.text.trim().length < 3) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_name"));
      return;
    }
    if (_emailController.text.trim().isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.text.trim())) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_email"));
      return;
    }
    if (_isoCode == null || _isoCode!.isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("choose_country"));
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("enter_phone"));
      return;
    }
    ConfirmDialog.showConfirmation(
            context,
            Text("$_dialCode${_phoneController.text.trim()}"),
            Text(AppLocalization.instance.getLocalizationFor("alert_phone")),
            AppLocalization.instance.getLocalizationFor("no"),
            AppLocalization.instance.getLocalizationFor("yes"))
        .then((value) {
      if (value != null && value == true) {
        BlocProvider.of<AuthCubit>(context).initRegistration(
            _isoCode!,
            _phoneController.text.trim(),
            _nameController.text.trim(),
            _emailController.text.trim(),
            null,
            widget.registerData.imageUrl);
      }
    });
  }
}
