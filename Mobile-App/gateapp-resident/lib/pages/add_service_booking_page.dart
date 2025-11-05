import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/category.dart';
import 'package:gateapp_user/models/service_booking_request.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AddServiceBookingPage extends StatelessWidget {
  const AddServiceBookingPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: AddServiceBookingStateful(
            ModalRoute.of(context)!.settings.arguments as Category),
      );
}

class AddServiceBookingStateful extends StatefulWidget {
  final Category category;
  const AddServiceBookingStateful(this.category, {super.key});

  @override
  State<AddServiceBookingStateful> createState() =>
      _AddServiceBookingStatefulState();
}

class _AddServiceBookingStatefulState extends State<AddServiceBookingStateful> {
  TextEditingController dateFromController = TextEditingController();
  TextEditingController timeFromController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  DateTime selectedDateFrom = DateTime.now();
  TimeOfDay selectedTimeFrom = TimeOfDay.now();

  @override
  void initState() {
    dateFromController.text = Helper.setupDateFromMillis(
        selectedDateFrom.millisecondsSinceEpoch, true);
    timeFromController.text = Helper.setupTimeFromMillis(
        DateTime(
                selectedDateFrom.year,
                selectedDateFrom.month,
                selectedDateFrom.day,
                selectedTimeFrom.hour,
                selectedTimeFrom.minute)
            .millisecondsSinceEpoch,
        true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is ServiceBookingCreateLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is ServiceBookingCreateLoaded) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("booking_created"));
          Navigator.pop(context, state.serviceBooking);
        }
        if (state is ServiceBookingCreateFail) {
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
                  Stack(
                    // fit: StackFit.expand,
                    children: [
                      Container(
                        height: 78,
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
                                widget.category.title,
                                style: theme.textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PositionedDirectional(
                        end: 12,
                        top: 8,
                        bottom: -40,
                        child: CachedImage(
                          imageUrl: widget.category.image_url,
                          imagePlaceholder: "assets/empty_image.png",
                          fit: BoxFit.cover,
                          height: 72,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppLocalization.instance
                          .getLocalizationFor("bookVisitOn"),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: theme.hintColor.withOpacity(0.5)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: EntryField(
                            label: AppLocalization.instance
                                .getLocalizationFor("selectDate"),
                            hintText: "",
                            readOnly: true,
                            controller: dateFromController,
                            onTap: () => showDatePicker(
                              context: context,
                              initialDate: selectedDateFrom,
                              initialDatePickerMode: DatePickerMode.day,
                              firstDate: selectedDateFrom,
                              lastDate: selectedDateFrom
                                  .add(const Duration(days: 395)),
                            ).then((value) {
                              if (value != null) {
                                selectedDateFrom = value;
                                dateFromController.text =
                                    Helper.setupDateFromMillis(
                                        selectedDateFrom.millisecondsSinceEpoch,
                                        true);
                                setState(() {});
                              }
                            }),
                            prefixIcon: Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: EntryField(
                            label: " ",
                            hintText: "",
                            readOnly: true,
                            controller: timeFromController,
                            onTap: () => showTimePicker(
                              context: context,
                              initialTime: selectedTimeFrom,
                            ).then((value) {
                              if (value != null) {
                                selectedTimeFrom = value;
                                timeFromController.text =
                                    Helper.setupTimeFromMillis(
                                        DateTime(
                                                selectedDateFrom.year,
                                                selectedDateFrom.month,
                                                selectedDateFrom.day,
                                                selectedTimeFrom.hour,
                                                selectedTimeFrom.minute)
                                            .millisecondsSinceEpoch,
                                        true);
                                setState(() {});
                              }
                            }),
                            prefixIcon: Icon(
                              Icons.access_time,
                              size: 20,
                              color: theme.hintColor,
                            ),
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
                      controller: detailsController,
                      hintText: AppLocalization.instance
                          .getLocalizationFor("briefYourProblem"),
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomButton(
                      title:
                          AppLocalization.instance.getLocalizationFor("submit"),
                      onTap: () {
                        if (detailsController.text.trim().isEmpty) {
                          Toaster.showToastCenter(AppLocalization.instance
                              .getLocalizationFor("briefYourProblem"));
                        } else {
                          LocalDataLayer().getResidentProfileMe().then((value) {
                            DateTime dateTimeFrom = DateTime(
                                selectedDateFrom.year,
                                selectedDateFrom.month,
                                selectedDateFrom.day,
                                selectedTimeFrom.hour,
                                selectedTimeFrom.minute);
                            BlocProvider.of<FetcherCubit>(context)
                                .initCreateServiceBooking(ServiceBookingRequest(
                              details: detailsController.text.trim(),
                              date:
                                  DateFormat("yyyy-MM-dd").format(dateTimeFrom),
                              time_from:
                                  DateFormat("HH:mm").format(dateTimeFrom),
                              flat_id: value!.flat_id!,
                              service_id: widget.category.id,
                              meta: jsonEncode({}),
                            ));
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
