import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/amenity.dart';
import 'package:gateapp_user/utility/app_settings.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class AddAmenityAppointmentPage extends StatelessWidget {
  const AddAmenityAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) => AddAmenityAppointmentStateful(
      amenity: ModalRoute.of(context)!.settings.arguments as Amenity);
}

class AddAmenityAppointmentStateful extends StatefulWidget {
  final Amenity amenity;
  const AddAmenityAppointmentStateful({
    super.key,
    required this.amenity,
  });

  @override
  State<AddAmenityAppointmentStateful> createState() =>
      _AddAmenityAppointmentStatefulState();
}

class _AddAmenityAppointmentStatefulState
    extends State<AddAmenityAppointmentStateful> {
  TextEditingController dateFromController = TextEditingController();
  TextEditingController dateToController = TextEditingController();
  TextEditingController timeFromController = TextEditingController();
  TextEditingController timeToController = TextEditingController();
  DateTime selectedDateFrom = DateTime.now();
  TimeOfDay selectedTimeFrom = TimeOfDay.now();
  DateTime selectedDateTo = DateTime.now();
  TimeOfDay selectedTimeTo = TimeOfDay.now();
  int days() {
    DateTime dateTimeFrom = DateTime(
        selectedDateFrom.year,
        selectedDateFrom.month,
        selectedDateFrom.day,
        selectedTimeFrom.hour,
        selectedTimeFrom.minute);
    DateTime dateTimeTo = DateTime(selectedDateTo.year, selectedDateTo.month,
        selectedDateTo.day, selectedTimeTo.hour, selectedTimeTo.minute);
    return dateTimeTo.difference(dateTimeFrom).inDays;
  }

  double totalFee() {
    return (widget.amenity.fee ?? 0) * days();
  }

  @override
  void initState() {
    selectedDateFrom = _getInitialDate();
    selectedDateTo = _getInitialDate(selectedDateFrom);
    dateFromController.text = Helper.setupDateFromMillis(
        selectedDateFrom.millisecondsSinceEpoch, true);
    dateToController.text =
        Helper.setupDateFromMillis(selectedDateTo.millisecondsSinceEpoch, true);
    timeFromController.text = Helper.setupTimeFromMillis(
        DateTime(
                selectedDateFrom.year,
                selectedDateFrom.month,
                selectedDateFrom.day,
                selectedTimeFrom.hour,
                selectedTimeFrom.minute)
            .millisecondsSinceEpoch,
        true);
    timeToController.text = Helper.setupTimeFromMillis(
        DateTime(selectedDateTo.year, selectedDateTo.month, selectedDateTo.day,
                selectedTimeTo.hour, selectedTimeTo.minute)
            .millisecondsSinceEpoch,
        true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    AppLocalization.instance.getLocalizationFor("bookAmenity"),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            children: [
              Text(
                widget.amenity.title,
                style: theme.textTheme.labelLarge?.copyWith(fontSize: 15),
              ),
              const SizedBox(height: 22),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalization.instance
                          .getLocalizationFor("maxCapacity"),
                      style: theme.textTheme.bodySmall,
                    ),
                    TextSpan(
                      text:
                          "${widget.amenity.capacity ?? 0} ${AppLocalization.instance.getLocalizationFor("people")}",
                      style: theme.textTheme.labelLarge?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalization.instance
                          .getLocalizationFor("bookBeforeAtleast"),
                      style: theme.textTheme.bodySmall,
                    ),
                    TextSpan(
                      text:
                          "${widget.amenity.advance_booking_days ?? 0} ${AppLocalization.instance.getLocalizationFor("days")}",
                      style: theme.textTheme.labelLarge?.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: EntryField(
                      label:
                          AppLocalization.instance.getLocalizationFor("from"),
                      hintText: "",
                      readOnly: true,
                      controller: dateFromController,
                      onTap: () => showDatePicker(
                        context: context,
                        initialDate: selectedDateFrom,
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: _getInitialDate(),
                        lastDate:
                            _getInitialDate().add(const Duration(days: 395)),
                      ).then((value) {
                        if (value != null) {
                          selectedDateFrom = value;
                          dateFromController.text = Helper.setupDateFromMillis(
                              selectedDateFrom.millisecondsSinceEpoch, true);
                          setState(() {});
                        }
                      }),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: theme.hintColor,
                      ),
                      // initialValue: AppLocalization.instance
                      //     .getLocalizationFor("selectDate"),
                    ),
                  ),
                  const SizedBox(width: 32),
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
                          timeFromController.text = Helper.setupTimeFromMillis(
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
                      // initialValue: AppLocalization.instance
                      //     .getLocalizationFor("selectTime"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: EntryField(
                      label:
                          AppLocalization.instance.getLocalizationFor("till"),
                      hintText: '',
                      readOnly: true,
                      controller: dateToController,
                      onTap: () => showDatePicker(
                        context: context,
                        initialDate: selectedDateTo,
                        initialDatePickerMode: DatePickerMode.day,
                        firstDate: _getInitialDate(),
                        lastDate:
                            _getInitialDate().add(const Duration(days: 395)),
                      ).then((value) {
                        if (value != null) {
                          selectedDateTo = value;
                          dateToController.text = Helper.setupDateFromMillis(
                              selectedDateTo.millisecondsSinceEpoch, true);
                          setState(() {});
                        }
                      }),
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: theme.hintColor,
                      ),
                      // initialValue: AppLocalization.instance
                      //     .getLocalizationFor("selectDate"),
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: EntryField(
                      label: " ",
                      hintText: "",
                      readOnly: true,
                      controller: timeToController,
                      onTap: () => showTimePicker(
                        context: context,
                        initialTime: selectedTimeTo,
                      ).then((value) {
                        if (value != null) {
                          selectedTimeTo = value;
                          timeToController.text = Helper.setupTimeFromMillis(
                              DateTime(
                                      selectedDateTo.year,
                                      selectedDateTo.month,
                                      selectedDateTo.day,
                                      selectedTimeTo.hour,
                                      selectedTimeTo.minute)
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
                      // initialValue: AppLocalization.instance
                      //     .getLocalizationFor("selectTime"),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            color: theme.colorScheme.background,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalization.instance
                            .getLocalizationFor("amountToPay"),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      "${AppSettings.currencyIcon} ${totalFee().toStringAsFixed(1)}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.amenity.fee_to_show ?? "0"} ${AppLocalization.instance.getLocalizationFor("perDay")}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ),
                    if (days() > 0)
                      Text(
                        "${days()} ${AppLocalization.instance.getLocalizationFor("days")}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor,
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  title: AppLocalization.instance
                      .getLocalizationFor("proceedToPay"),
                  onTap: () {
                    DateTime dateTimeFrom = DateTime(
                        selectedDateFrom.year,
                        selectedDateFrom.month,
                        selectedDateFrom.day,
                        selectedTimeFrom.hour,
                        selectedTimeFrom.minute);
                    DateTime dateTimeTo = DateTime(
                        selectedDateTo.year,
                        selectedDateTo.month,
                        selectedDateTo.day,
                        selectedTimeTo.hour,
                        selectedTimeTo.minute);

                    if (dateTimeFrom.isAfter(dateTimeTo)) {
                      Toaster.showToastCenter(AppLocalization.instance
                          .getLocalizationFor("datefrom_after_dateto"));
                    } else if ((widget.amenity.max_days_per_flat ?? 0) > 0 &&
                        days() > (widget.amenity.max_days_per_flat ?? 0)) {
                      Toaster.showToastCenter(
                          "${AppLocalization.instance.getLocalizationFor("max_days_per_flat")}: ${widget.amenity.max_days_per_flat}");
                    } else {
                      Navigator.pushNamed(
                          context, PageRoutes.amenityAppointmentPaymentPage,
                          arguments: {
                            "amenity": widget.amenity,
                            "date_time_from": dateTimeFrom,
                            "date_time_to": dateTimeTo,
                            "days": days(),
                            "amount": totalFee(),
                          });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getInitialDate([DateTime? dateTimeFrom]) =>
      (dateTimeFrom ?? DateTime.now())
          .add(Duration(days: widget.amenity.advance_booking_days ?? 0));
}
