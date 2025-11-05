// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:gateapp_guard/bloc/fetcher_cubit.dart';
import 'package:gateapp_guard/bloc/fetcher_visitor_logs_cubit.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/models/resident_building.dart';
import 'package:gateapp_guard/models/resident_flat.dart';
import 'package:gateapp_guard/models/visitor_log_request.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/utility/firebase_uploader.dart';
import 'package:gateapp_guard/utility/helper.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';
import 'package:gateapp_guard/utility/picker.dart';
import 'package:gateapp_guard/widgets/cached_image.dart';
import 'package:gateapp_guard/widgets/custom_button.dart';
import 'package:gateapp_guard/widgets/entry_field.dart';
import 'package:gateapp_guard/widgets/loader.dart';
import 'package:gateapp_guard/widgets/toaster.dart';

class AddVisitorLogPage extends StatelessWidget {
  const AddVisitorLogPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: AddVisitorStateful(
            visitorType: ModalRoute.of(context)!.settings.arguments as String),
      );
}

class AddVisitorStateful extends StatefulWidget {
  final String visitorType;
  const AddVisitorStateful({super.key, required this.visitorType});

  @override
  State<AddVisitorStateful> createState() => _AddVisitorStatefulState();
}

class _AddVisitorStatefulState extends State<AddVisitorStateful> {
  TextEditingController nameController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  String? _newImageUrl;

  List<ResidentBuilding> residentBuildings = [];
  List<ResidentFlat> residentFlats = [];
  ResidentBuilding? _residentBuildingSelected;
  ResidentFlat? _residentFlatSelected;

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    LocalDataLayer().getGuardProfileMe().then((value) {
      if (value != null) {
        BlocProvider.of<FetcherCubit>(context)
            .initFetchResidentBuildings(value.project_id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return MultiBlocListener(
      listeners: [
        BlocListener<FetcherCubit, FetcherState>(
          listener: (context, state) {
            if (state is ResidentBuildingsLoaded) {
              residentBuildings = state.buildings;
              setState(() {});
            }
            if (state is ResidentFlatsLoaded) {
              residentFlats = state.flats;
              setState(() {});
            }
          },
        ),
        BlocListener<FetcherVisitorLogsCubit, FetcherVisitorLogsState>(
          listener: (context, state) {
            if (state is CreateVisitorLogLoading) {
              Loader.showLoader(context);
            } else {
              Loader.dismissLoader(context);
            }
            if (state is CreateVisitorLogLoaded) {
              Toaster.showToastCenter(AppLocalization.instance
                  .getLocalizationFor("visitor_log_created"));
              Navigator.pop(context);
            }
            if (state is CreateVisitorLogFail) {
              Toaster.showToastCenter(
                  AppLocalization.instance.getLocalizationFor(state.messageKey),
                  state.messageKey != "something_wrong");
              Navigator.pop(context);
            }
          },
        ),
      ],
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: theme.colorScheme.background,
              height: 160,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(height: 26),
                            Text(
                              _getTitle(),
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          File? filePicked = await Picker().pickImageFile(
                            context: context,
                            pickerSource: PickerSource.ask,
                            cropConfig: CropConfig.square,
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
                              padding: const EdgeInsets.only(top: 8.0),
                              child: CachedImage(
                                radius: 37,
                                imageUrl: _newImageUrl,
                                imagePlaceholder: widget.visitorType ==
                                        Constants.visitorTypeHouseholdVehicle
                                    ? "assets/plc_vehicle.png"
                                    : "assets/plc_profile.png",
                                height: 74,
                                width: 74,
                              ),
                            ),
                            PositionedDirectional(
                              top: 0,
                              end: 0,
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
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 50),
                  EntryField(
                    label: "",
                    hintText: AppLocalization.instance.getLocalizationFor(
                        widget.visitorType == Constants.visitorTypeCab
                            ? "vehicleNumber"
                            : "enterName"),
                    controller: nameController,
                  ),
                  const SizedBox(height: 40),
                  if (widget.visitorType != Constants.visitorTypeGuest)
                    EntryField(
                      label: '',
                      hintText: AppLocalization.instance.getLocalizationFor(
                          widget.visitorType == Constants.visitorTypeCab
                              ? "vehicleModel"
                              : "companyName"),
                      controller: companyController,
                    ),
                  if (widget.visitorType != Constants.visitorTypeGuest)
                    const SizedBox(height: 40),
                  Text(AppLocalization.instance.getLocalizationFor("building"),
                      style: Theme.of(context).textTheme.bodySmall),
                  DropdownButton<ResidentBuilding>(
                    value: _residentBuildingSelected,
                    dropdownColor: theme.scaffoldBackgroundColor,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: residentBuildings.isEmpty
                          ? theme.hintColor
                          : theme.primaryColor,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: theme.textTheme.titleSmall!,
                    underline: Container(
                      height: 0.5,
                      color: theme.hintColor,
                    ),
                    onChanged: (ResidentBuilding? newValue) {
                      bool newCatSelected = _residentBuildingSelected == null ||
                          _residentBuildingSelected != newValue;
                      _residentBuildingSelected = newValue;

                      if (newCatSelected) {
                        _residentFlatSelected = null;
                        residentFlats = [];
                        BlocProvider.of<FetcherCubit>(context)
                            .initFetchResidentFlats(
                                _residentBuildingSelected!.id);
                      }
                      setState(() {});
                    },
                    items: [
                      for (ResidentBuilding cat in residentBuildings)
                        DropdownMenuItem<ResidentBuilding>(
                          value: cat,
                          child: Text(cat.title ?? ""),
                        )
                    ],
                    hint: Text(AppLocalization.instance
                        .getLocalizationFor("select_building")),
                  ),
                  const SizedBox(height: 40),
                  Text(AppLocalization.instance.getLocalizationFor("flatNum"),
                      style: Theme.of(context).textTheme.bodySmall),
                  DropdownButton<ResidentFlat>(
                    value: _residentFlatSelected,
                    dropdownColor: theme.scaffoldBackgroundColor,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: _residentBuildingSelected == null
                          ? theme.hintColor
                          : theme.primaryColor,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: theme.textTheme.titleSmall,
                    underline: Container(
                      height: 0.5,
                      color: theme.hintColor,
                    ),
                    onChanged: _residentBuildingSelected == null
                        ? null
                        : (ResidentFlat? newValue) {
                            // bool newCatSelected = _residentFlatSelected == null ||
                            //     _residentFlatSelected != newValue;
                            _residentFlatSelected = newValue;
                            setState(() {});
                            //if (newCatSelected) {}
                          },
                    items: [
                      for (ResidentFlat cat in residentFlats)
                        DropdownMenuItem<ResidentFlat>(
                          value: cat,
                          child: Text(cat.title ?? ""),
                        )
                    ],
                    hint: Text(AppLocalization.instance
                        .getLocalizationFor("select_flat")),
                    disabledHint: Text(AppLocalization.instance
                        .getLocalizationFor("select_building_first")),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
            Row(
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: CustomButton(
                    title: AppLocalization.instance
                        .getLocalizationFor("continuee"),
                    onTap: () {
                      Helper.closeKeyboard(context);
                      if (nameController.text.trim().isEmpty) {
                        Toaster.showToastCenter(AppLocalization.instance
                            .getLocalizationFor(widget.visitorType ==
                                    Constants.visitorTypeHouseholdVehicle
                                ? "vehicleNumber"
                                : "enterName"));
                      } else if (widget.visitorType !=
                              Constants.visitorTypeGuest &&
                          companyController.text.trim().isEmpty) {
                        Toaster.showToastCenter(AppLocalization.instance
                            .getLocalizationFor(widget.visitorType ==
                                    Constants.visitorTypeHouseholdVehicle
                                ? "vehicleModel"
                                : "enter_phone"));
                      } else if (_residentBuildingSelected == null) {
                        Toaster.showToastCenter(AppLocalization.instance
                            .getLocalizationFor("select_building"));
                      } else if (_residentFlatSelected == null) {
                        Toaster.showToastCenter(AppLocalization.instance
                            .getLocalizationFor("select_flat"));
                      } else {
                        LocalDataLayer().getGuardProfileMe().then((value) {
                          if (value != null) {
                            VisitorLogRequest visitorLogRequest =
                                VisitorLogRequest(
                                    type: widget.visitorType,
                                    flat_id: _residentFlatSelected!.id);
                            if (widget.visitorType ==
                                Constants.visitorTypeCab) {
                              visitorLogRequest.vehicle_number =
                                  nameController.text;
                            } else {
                              visitorLogRequest.name =
                                  nameController.text.trim();
                            }
                            if (_newImageUrl != null) {
                              visitorLogRequest.meta =
                                  jsonEncode({"image_url": _newImageUrl});
                            }
                            BlocProvider.of<FetcherVisitorLogsCubit>(context)
                                .initCreateVisitorLog(visitorLogRequest);
                          }
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.visitorType) {
      case Constants.visitorTypeDelivery:
        return AppLocalization.instance.getLocalizationFor("allowDeliveryman");
      case Constants.visitorTypeCab:
        return AppLocalization.instance.getLocalizationFor("allowMyCab");
      case Constants.visitorTypeGuest:
        return AppLocalization.instance.getLocalizationFor("addGuest");
      case Constants.visitorTypeService:
        return AppLocalization.instance.getLocalizationFor("allowServiceman");
      default:
        return AppLocalization.instance.getLocalizationFor("addGuest");
    }
  }
}
