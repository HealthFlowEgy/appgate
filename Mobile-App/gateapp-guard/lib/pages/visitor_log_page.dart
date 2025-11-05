import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:gateapp_guard/bloc/fetcher_visitor_logs_cubit.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/models/visitor_log.dart';
import 'package:gateapp_guard/models/visitor_log_update_request.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/widgets/cached_image.dart';
import 'package:gateapp_guard/widgets/custom_button.dart';
import 'package:gateapp_guard/widgets/loader.dart';
import 'package:gateapp_guard/widgets/toaster.dart';

class VisitorLogPage extends StatelessWidget {
  const VisitorLogPage({super.key});

  @override
  Widget build(BuildContext context) => VisitorLogStateful(
      visitorLog: ModalRoute.of(context)!.settings.arguments as VisitorLog);
}

class VisitorLogStateful extends StatefulWidget {
  final VisitorLog visitorLog;
  const VisitorLogStateful({super.key, required this.visitorLog});

  @override
  State<VisitorLogStateful> createState() => _VisitorLogStatefulState();
}

class _VisitorLogStatefulState extends State<VisitorLogStateful> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherVisitorLogsCubit, FetcherVisitorLogsState>(
      listener: (context, state) {
        if (state is VisitorLogUpdateLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }

        if (state is VisitorLogUpdateLoaded) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("sent_in"));
          Navigator.pop(context);
        }

        if (state is VisitorLogUpdateFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
        }
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                Container(
                  color: theme.colorScheme.background,
                  height: 180,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(Icons.arrow_back),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 120,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    children: [
                      buildItem(
                          theme,
                          Icons.person,
                          AppLocalization.instance
                              .getLocalizationFor("guestName"),
                          widget.visitorLog.nameToShow),
                      const SizedBox(height: 50),
                      buildItem(
                          theme,
                          Icons.business_outlined,
                          AppLocalization.instance
                              .getLocalizationFor("building"),
                          widget.visitorLog.flat?.building?.title ?? ""),
                      const SizedBox(height: 50),
                      buildItem(
                          theme,
                          Icons.business_outlined,
                          AppLocalization.instance
                              .getLocalizationFor("flatNum"),
                          widget.visitorLog.flat?.title ?? ""),
                      const SizedBox(height: 50),
                      buildItem(
                          theme,
                          Icons.timelapse_outlined,
                          AppLocalization.instance.getLocalizationFor("status"),
                          "${AppLocalization.instance.getLocalizationFor("visitor_status_${widget.visitorLog.status}")}, ${AppLocalization.instance.getLocalizationFor("visitor_type_${widget.visitorLog.type}")}"),
                    ],
                  ),
                ),
                if (_allowProcessing())
                  Row(
                    children: [
                      const SizedBox(width: 24),
                      Expanded(
                        child: CustomButton(
                          title: AppLocalization.instance
                              .getLocalizationFor("confirmNSendIn"),
                          onTap: () {
                            if (widget.visitorLog.status == "preapproved" ||
                                widget.visitorLog.status == "approved") {
                              BlocProvider.of<FetcherVisitorLogsCubit>(context)
                                  .initUpdateVisitorLog(
                                      null,
                                      widget.visitorLog.id,
                                      VisitorLogUpdateRequest(
                                        status: "inside",
                                        intime:
                                            DateFormat("yyyy-MM-dd HH:mm:ss")
                                                .format(DateTime.now()),
                                        type: widget.visitorLog.type
                                                .contains("household_")
                                            ? widget.visitorLog.type.substring(
                                                widget.visitorLog.type
                                                        .indexOf("_") +
                                                    1)
                                            : null,
                                      ));
                            } else {
                              Toaster.showToastCenter(AppLocalization.instance
                                  .getLocalizationFor("visitor_not_approved"));
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
            Positioned(
              top: 100,
              child: CachedImage(
                imageUrl: widget.visitorLog.imageUrl,
                height: 150,
                width: 150,
                radius: 75,
                imagePlaceholder: widget.visitorLog.type ==
                        Constants.visitorTypeHouseholdVehicle
                    ? "assets/plc_vehicle.png"
                    : "assets/plc_profile.png",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildItem(
          ThemeData theme, IconData icon, String title, String subtitle) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(
            icon,
            color: theme.hintColor,
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 14),
              Text(
                subtitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      );

  bool _allowProcessing() {
    var arr = ["household_family", "household_dailyhelp", "household_vehicle"];
    return !(arr.contains(widget.visitorLog.type) &&
        widget.visitorLog.status == "preapproved");
  }
}
