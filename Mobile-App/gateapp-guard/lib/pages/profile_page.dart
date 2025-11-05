// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/bloc/fetcher_cubit.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/models/guard_profile.dart';
import 'package:gateapp_guard/utility/firebase_uploader.dart';
import 'package:gateapp_guard/utility/helper.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';
import 'package:gateapp_guard/utility/picker.dart';
import 'package:gateapp_guard/widgets/cached_image.dart';
import 'package:gateapp_guard/widgets/custom_button.dart';
import 'package:gateapp_guard/widgets/entry_field.dart';
import 'package:gateapp_guard/widgets/loader.dart';
import 'package:gateapp_guard/widgets/toaster.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const ProfileStateful(),
      );
}

class ProfileStateful extends StatefulWidget {
  const ProfileStateful({super.key});

  @override
  State<ProfileStateful> createState() => _ProfileStatefulState();
}

class _ProfileStatefulState extends State<ProfileStateful> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  GuardProfile? _guardProfile;
  String? _newImageUrl;
  File? _filePicked;
  final Set<String> _firebaseStorageCleanupRef = {};

  @override
  void dispose() {
    for (String refToCleanup in _firebaseStorageCleanupRef) {
      FirebaseUploader.deleteRef(refToCleanup);
    }
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    LocalDataLayer()
        .getGuardProfileMe()
        .then((value) => _setupWithValue(value));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is UserMeUpdating) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }

        if (state is UserMeError) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey));
        }

        if (state is UserMeLoaded) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalization.instance.getLocalizationFor("profile"),
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor("everythingAboutYou"),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                children: [
                  GestureDetector(
                    onTap: () async {
                      _filePicked = await Picker().pickImageFile(
                        context: context,
                        pickerSource: PickerSource.ask,
                        cropConfig: CropConfig.square,
                      );
                      if (_filePicked != null && mounted) {
                        final String dpRef =
                            "dp_user_id_${_guardProfile?.user_id}";
                        _newImageUrl = await FirebaseUploader.uploadFile(
                          context,
                          _filePicked!,
                          AppLocalization.instance
                              .getLocalizationFor("uploading"),
                          AppLocalization.instance
                              .getLocalizationFor("just_moment"),
                          dpRef,
                        );
                        if (_newImageUrl != null) {
                          _firebaseStorageCleanupRef.add(dpRef);
                        } else {
                          _filePicked = null;
                        }
                        setState(() {});
                      }
                    },
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: CachedImage(
                                radius: 36,
                                imageUrl: _newImageUrl ??
                                    _guardProfile?.user?.imageUrl,
                                imagePlaceholder: "assets/plc_profile.png",
                                height: 72,
                              ),
                            ),
                            PositionedDirectional(
                              end: 0,
                              top: 8,
                              child: CircleAvatar(
                                backgroundColor: theme.primaryColor,
                                radius: 12,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 14,
                                  color: theme.scaffoldBackgroundColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  EntryField(
                    label:
                        AppLocalization.instance.getLocalizationFor("fullName"),
                    hintText: '',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 30),
                  EntryField(
                    label: AppLocalization.instance
                        .getLocalizationFor("phoneNumber"),
                    hintText: '',
                    readOnly: true,
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title:
                          AppLocalization.instance.getLocalizationFor("update"),
                      onTap: () {
                        if (_nameController.text.trim().isEmpty) {
                          Toaster.showToastTop(AppLocalization.instance
                              .getLocalizationFor("enterName"));
                        } else {
                          Helper.closeKeyboard(context);
                        }
                        BlocProvider.of<FetcherCubit>(context).initUpdateUserMe(
                            _nameController.text.trim(), _newImageUrl);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _setupWithValue(GuardProfile? value) {
    _guardProfile = value;
    _nameController.text = value?.user?.name ?? "";
    _phoneController.text = value?.user?.mobile_number ?? "";
    setState(() {});
  }
}
