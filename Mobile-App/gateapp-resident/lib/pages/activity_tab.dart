import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/bloc/fetcher_visitor_logs_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/user_notification.dart';
import 'package:gateapp_user/models/visitor_log_update_request.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/confirm_dialog.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';

class ActivityTab extends StatelessWidget {
  final bool isUpcoming;
  final Key? activityStatefulKey;
  const ActivityTab(
      {super.key, required this.isUpcoming, this.activityStatefulKey});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child:
            ActivityStateful(isUpcoming: isUpcoming, key: activityStatefulKey),
      );
}

class ActivityStateful extends StatefulWidget {
  final bool isUpcoming;
  const ActivityStateful({super.key, required this.isUpcoming});

  @override
  State<ActivityStateful> createState() => ActivityStatefulState();
}

class ActivityStatefulState extends State<ActivityStateful>
    with AutomaticKeepAliveClientMixin<ActivityStateful> {
  final List<UserNotification> _notifications = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return MultiBlocListener(
        listeners: [
          BlocListener<FetcherCubit, FetcherState>(
            listener: (context, state) {
              if (state is UserNotificationsLoaded) {
                _isLoading = false;
                _page = state.notificationssResponse.meta.current_page ?? 1;
                _allDone = state.notificationssResponse.meta.current_page ==
                    state.notificationssResponse.meta.last_page;
                if (state.notificationssResponse.meta.current_page == 1) {
                  _notifications.clear();
                }
                _notifications.addAll(state.notificationssResponse.data);
                setState(() {});
              }
              if (state is UserNotificationsFail) {
                _isLoading = false;
                setState(() {});
              }
            },
          ),
          BlocListener<FetcherVisitorLogsCubit, FetcherVisitorLogsState>(
            listener: (context, state) {
              if (state is VisitorLogUpdateLoaded) {
                int eIndex = _notifications.indexWhere((element) =>
                    element.visitorLog != null &&
                    element.visitorLog!.id == state.visitorLog.id);
                if (eIndex != -1) {
                  _notifications[eIndex].visitorLog = state.visitorLog;
                  setState(() {});
                }
              }
            },
          ),
        ],
        child: RefreshIndicator(
          onRefresh: () => doRefresh(),
          child: _notifications.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index == _notifications.length - 1 &&
                        !_isLoading &&
                        !_allDone) {
                      _isLoading = true;
                      BlocProvider.of<FetcherCubit>(context)
                          .initFetchUserNotifications(_page + 1,
                              isUpcoming: widget.isUpcoming,
                              isPast: !widget.isUpcoming);
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.hintColor.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 22),
                            child: Row(
                              children: [
                                CachedImage(
                                  imageUrl: _notifications[index]
                                          .service
                                          ?.service
                                          .image_url ??
                                      _notifications[index]
                                          .visitorLog
                                          ?.imageUrl ??
                                      _notifications[index].fromuser?.imageUrl,
                                  imagePlaceholder:
                                      _notifications[index].service != null
                                          ? "assets/empty_image.png"
                                          : "assets/plc_profile.png",
                                  height: 50,
                                  radius: 25,
                                ),
                                const SizedBox(width: 28),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              _notifications[index].text ?? "",
                                              style: theme.textTheme.bodySmall
                                                  ?.copyWith(
                                                color: theme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        (_notifications[index].service != null
                                                ? AppLocalization.instance
                                                    .getLocalizationFor(
                                                        "service_booking_status_${_notifications[index].service!.status}")
                                                : _notifications[index]
                                                            .visitorLog !=
                                                        null
                                                    ? _notifications[index]
                                                        .visitorLog!
                                                        .nameToShow
                                                    : "")
                                            .toUpperCase(),
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          //color: _notifications[index].color,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_notifications[index].visitorLog != null ||
                              _notifications[index].service != null)
                            const SizedBox(height: 14),
                          if (_notifications[index].visitorLog != null ||
                              _notifications[index].service != null)
                            Container(
                              decoration: BoxDecoration(
                                color: theme.scaffoldBackgroundColor,
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(16)),
                              ),
                              child: _notifications[index].visitorLog != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 80),
                                        if (_notifications[index]
                                            .visitorLog!
                                            .status
                                            .contains("approved"))
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () => Navigator.pushNamed(
                                                context,
                                                PageRoutes.gatePassPage,
                                                arguments: _notifications[index]
                                                    .visitorLog),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.receipt,
                                                    color: theme.hintColor
                                                        .withOpacity(0.5),
                                                    size: 14,
                                                  ),
                                                  const SizedBox(width: 14),
                                                  Text(
                                                    AppLocalization.instance
                                                        .getLocalizationFor(
                                                            "gatePass"),
                                                    style: theme
                                                        .textTheme.bodySmall
                                                        ?.copyWith(
                                                      color: theme.hintColor
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else if (_notifications[index]
                                                    .visitorLog!
                                                    .status ==
                                                "inside" &&
                                            _notifications[index]
                                                    .visitorLog!
                                                    .intime_formatted !=
                                                null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: theme.hintColor
                                                      .withOpacity(0.5),
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 14),
                                                Text(
                                                  _notifications[index]
                                                      .visitorLog!
                                                      .intime_formatted!,
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: theme.hintColor
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        else if (_notifications[index]
                                                    .visitorLog!
                                                    .status ==
                                                "left" &&
                                            _notifications[index]
                                                    .visitorLog!
                                                    .outtime_formatted !=
                                                null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: theme.hintColor
                                                      .withOpacity(0.5),
                                                  size: 14,
                                                ),
                                                const SizedBox(width: 14),
                                                Text(
                                                  _notifications[index]
                                                      .visitorLog!
                                                      .outtime_formatted!,
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: theme.hintColor
                                                        .withOpacity(0.5),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (_notifications[index]
                                                .visitorLog!
                                                .status ==
                                            "preapproved")
                                          const Spacer(),
                                        if (_notifications[index]
                                                .visitorLog!
                                                .status ==
                                            "preapproved")
                                          GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () =>
                                                _handleDeleteVisitorLog(index),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 16,
                                              ),
                                              child: Icon(
                                                Icons.delete,
                                                size: 16,
                                                color: theme.hintColor
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 80),
                                          Icon(
                                            Icons.calendar_today,
                                            color: theme.hintColor
                                                .withOpacity(0.5),
                                            size: 14,
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            "${_notifications[index].service!.dateFormatted}  |  ${_notifications[index].service!.timeFormatted}",
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: theme.hintColor
                                                  .withOpacity(0.5),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                        ],
                      ),
                    );
                  },
                )
              : ListView(
                  children: [
                    _isLoading
                        ? Loader.loadingWidget(context: context)
                        : ErrorFinalWidget.errorWithRetry(
                            context: context,
                            message: AppLocalization.instance
                                .getLocalizationFor("empty_activities"),
                            imageAsset: "assets/plc_profile.png",
                          ),
                  ],
                ),
        ));
  }

  _handleDeleteVisitorLog(int index) => ConfirmDialog.showConfirmation(
              context,
              Text(AppLocalization.instance
                  .getLocalizationFor("reject_visitor_log")),
              Text(AppLocalization.instance
                  .getLocalizationFor("reject_visitor_log_msg")),
              AppLocalization.instance.getLocalizationFor("no"),
              AppLocalization.instance.getLocalizationFor("yes"))
          .then((value) async {
        if (value != null && value == true) {
          Loader.showLoader(context);
          await BlocProvider.of<FetcherVisitorLogsCubit>(context)
              .initUpdateVisitorLog(
                  "waiting",
                  _notifications[index].visitorLog!.id,
                  VisitorLogUpdateRequest(status: "rejected"));
          if (mounted) {
            Loader.dismissLoader(context);
            doRefresh();
          }
        }
      });

  Future<void> doRefresh() =>
      BlocProvider.of<FetcherCubit>(context).initFetchUserNotifications(1,
          isUpcoming: widget.isUpcoming, isPast: !widget.isUpcoming);
}
