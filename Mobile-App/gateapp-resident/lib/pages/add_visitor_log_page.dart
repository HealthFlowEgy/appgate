import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/visitor_log_request.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

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
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: theme.colorScheme.background,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _getTitle(),
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Image.asset(
                            _getImage(),
                            height: 72,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: EntryField(
                      label: "",
                      hintText: _getHintName(),
                      controller: nameController,
                    ),
                  ),
                  if (widget.visitorType != Constants.visitorTypeGuest)
                    const SizedBox(height: 24),
                  if (widget.visitorType != Constants.visitorTypeGuest)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: EntryField(
                        label: "",
                        hintText: AppLocalization.instance
                            .getLocalizationFor("companyName"),
                        controller: companyController,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      title:
                          AppLocalization.instance.getLocalizationFor("submit"),
                      onTap: () {
                        Helper.closeKeyboard(context);
                        if (nameController.text.trim().isEmpty) {
                          Toaster.showToastCenter(AppLocalization.instance
                              .getLocalizationFor(
                                  widget.visitorType == Constants.visitorTypeCab
                                      ? "enter_cab_number"
                                      : "enter_name_visitor"));
                        } else if (widget.visitorType !=
                                Constants.visitorTypeGuest &&
                            companyController.text.trim().isEmpty) {
                          Toaster.showToastCenter(AppLocalization.instance
                              .getLocalizationFor("enter_company_name"));
                        } else {
                          LocalDataLayer().getResidentProfileMe().then((value) {
                            if (value != null) {
                              VisitorLogRequest visitorLogRequest =
                                  VisitorLogRequest(
                                      type: widget.visitorType,
                                      flat_id: value.flat_id!);
                              if (widget.visitorType ==
                                  Constants.visitorTypeCab) {
                                visitorLogRequest.vehicle_number =
                                    nameController.text;
                              } else {
                                visitorLogRequest.name =
                                    nameController.text.trim();
                              }
                              visitorLogRequest.company_name =
                                  companyController.text.trim();
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

  @override
  void dispose() {
    nameController.dispose();
    companyController.dispose();
    super.dispose();
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

  String _getImage() {
    switch (widget.visitorType) {
      case Constants.visitorTypeDelivery:
        return "assets/visitor_types/allow_deliveryman.png";
      case Constants.visitorTypeCab:
        return "assets/visitor_types/allow_cab.png";
      case Constants.visitorTypeGuest:
        return "assets/visitor_types/allow_guest.png";
      case Constants.visitorTypeService:
        return "assets/visitor_types/allow_serviceman.png";
      default:
        return "assets/visitor_types/allow_cab.png";
    }
  }

  String _getHintName() {
    switch (widget.visitorType) {
      case Constants.visitorTypeDelivery:
        return AppLocalization.instance.getLocalizationFor("deliverymanName");
      case Constants.visitorTypeCab:
        return AppLocalization.instance.getLocalizationFor("lastDigitOfCab");
      case Constants.visitorTypeGuest:
        return AppLocalization.instance.getLocalizationFor("enterGuestName");
      case Constants.visitorTypeService:
        return AppLocalization.instance.getLocalizationFor("servicemanName");
      default:
        return AppLocalization.instance.getLocalizationFor("enterGuestName");
    }
  }
}
