// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/visitor_log_request.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/utility/firebase_uploader.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/utility/picker.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class AddVisitorLogCustomPage extends StatelessWidget {
  const AddVisitorLogCustomPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: AddVisitorCustomStateful(
            visitorType: ModalRoute.of(context)!.settings.arguments as String),
      );
}

class AddVisitorCustomStateful extends StatefulWidget {
  final String visitorType;
  const AddVisitorCustomStateful({super.key, required this.visitorType});

  @override
  State<AddVisitorCustomStateful> createState() =>
      _AddVisitorCustomStatefulState();
}

class _AddVisitorCustomStatefulState extends State<AddVisitorCustomStateful> {
  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  String? _newImageUrl;

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is CreateVisitorLogLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is CreateVisitorLogLoaded) {
          Navigator.pop(context, state.visitorLog);
        }
        if (state is CreateVisitorLogFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: theme.primaryColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(
              Icons.close,
              color: theme.scaffoldBackgroundColor,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: theme.scaffoldBackgroundColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      color: theme.colorScheme.background,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            AppLocalization.instance.getLocalizationFor(
                                "${widget.visitorType}_new"),
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            File? filePicked = await Picker().pickImageFile(
                              context: context,
                              pickerSource: PickerSource.ask,
                              restrictSquare: true,
                            );
                            if (filePicked != null && mounted) {
                              String dpRef =
                                  "visitorlog_image_new_${DateTime.now().millisecondsSinceEpoch}";
                              String? imageUrl =
                                  await FirebaseUploader.uploadFile(
                                context,
                                filePicked,
                                AppLocalization.instance
                                    .getLocalizationFor("uploading"),
                                AppLocalization.instance
                                    .getLocalizationFor("just_moment"),
                                dpRef,
                              );
                              if (imageUrl != null) {
                                _newImageUrl = imageUrl;
                                setState(() {});
                              }
                            }
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: CachedImage(
                                  radius: 36,
                                  imageUrl: _newImageUrl,
                                  imagePlaceholder: widget.visitorType ==
                                          Constants.visitorTypeHouseholdVehicle
                                      ? "assets/plc_vehicle.png"
                                      : "assets/plc_profile.png",
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: EntryField(
                      label: '',
                      hintText: AppLocalization.instance.getLocalizationFor(
                          widget.visitorType ==
                                  Constants.visitorTypeHouseholdVehicle
                              ? "vehicleNumber"
                              : "enterName"),
                      controller: nameController,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: EntryField(
                      label: '',
                      hintText: AppLocalization.instance.getLocalizationFor(
                          widget.visitorType ==
                                  Constants.visitorTypeHouseholdVehicle
                              ? "vehicleModel"
                              : "phoneNumber"),
                      controller: companyController,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      title:
                          AppLocalization.instance.getLocalizationFor("submit"),
                      onTap: () {
                        Helper.closeKeyboard(context);
                        if (nameController.text.trim().isEmpty) {
                          Toaster.showToastCenter(AppLocalization.instance
                              .getLocalizationFor(widget.visitorType ==
                                      Constants.visitorTypeHouseholdVehicle
                                  ? "vehicleNumber"
                                  : "enterName"));
                        } else if (companyController.text.trim().isEmpty) {
                          Toaster.showToastCenter(AppLocalization.instance
                              .getLocalizationFor(widget.visitorType ==
                                      Constants.visitorTypeHouseholdVehicle
                                  ? "vehicleModel"
                                  : "enter_phone"));
                        } else {
                          LocalDataLayer().getResidentProfileMe().then((value) {
                            if (value != null) {
                              VisitorLogRequest visitorLogRequest =
                                  VisitorLogRequest(
                                      type: widget.visitorType,
                                      flat_id: value.flat_id!);
                              if (widget.visitorType ==
                                  Constants.visitorTypeHouseholdVehicle) {
                                visitorLogRequest.vehicle_number =
                                    nameController.text;
                                visitorLogRequest.company_name =
                                    companyController.text.trim();
                              } else {
                                visitorLogRequest.name =
                                    nameController.text.trim();
                                visitorLogRequest.contact =
                                    companyController.text.trim();
                              }
                              if (_newImageUrl != null) {
                                visitorLogRequest.meta =
                                    jsonEncode({"image_url": _newImageUrl});
                              }
                              visitorLogRequest.status = "preapproved";
                              BlocProvider.of<FetcherCubit>(context)
                                  .initCreateVisitorLog(visitorLogRequest);
                            } else {
                              if (kDebugMode) {
                                print("getResidentProfileMe: null");
                              }
                            }
                          });
                        }
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
}
