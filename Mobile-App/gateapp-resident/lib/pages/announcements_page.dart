import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/announcement.dart';
import 'package:gateapp_user/models/announcement_option.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const AnnouncementsStateful(),
      );
}

class AnnouncementsStateful extends StatefulWidget {
  const AnnouncementsStateful({super.key});

  @override
  State<AnnouncementsStateful> createState() => _AnnouncementsStatefulState();
}

class _AnnouncementsStatefulState extends State<AnnouncementsStateful> {
  final List<Announcement> _announcements = [];
  final List<int> _announcementIdsLikeInProgress = [];
  final List<int> _announcementPollSubmittedIds = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchAnnouncements(1);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is AnnouncementsLoaded) {
          _isLoading = false;
          _page = state.announcementsResponse.meta.current_page ?? 1;
          _allDone = state.announcementsResponse.meta.current_page ==
              state.announcementsResponse.meta.last_page;
          if (state.announcementsResponse.meta.current_page == 1) {
            _announcements.clear();
          }
          DateTime dateTimeNow = DateTime.now();
          for (Announcement a in state.announcementsResponse.data) {
            if (a.duedate != null) {
              DateTime dateTimeDue = DateTime.parse(a.duedate!);

              a.dueDateLeftFormatted = dateTimeDue.isAfter(dateTimeNow)
                  ? Helper.formatDurationAgo(
                      dateTimeDue.difference(dateTimeNow),
                      daysToGo: AppLocalization.instance
                          .getLocalizationFor("days_left"),
                      dayToGo: AppLocalization.instance
                          .getLocalizationFor("day_left"),
                      hoursToGo: AppLocalization.instance
                          .getLocalizationFor("hours_left"),
                      hourToGo: AppLocalization.instance
                          .getLocalizationFor("hour_left"),
                      minsToGo: AppLocalization.instance
                          .getLocalizationFor("mins_left"),
                      minToGo: AppLocalization.instance
                          .getLocalizationFor("min_left"),
                    )
                  : null;
            }
          }
          _announcements.addAll(state.announcementsResponse.data);
          setState(() {});
        }
        if (state is AnnouncementsFail) {
          _isLoading = false;
          setState(() {});
        }

        if (state is AnnouncementLikeToggleLoading) {
          int eIndex =
              _announcementIdsLikeInProgress.indexOf(state.announcementId);
          if (eIndex == -1) {
            _announcementIdsLikeInProgress.add(state.announcementId);
            setState(() {});
          }
        }
        if (state is AnnouncementLikeToggleLoaded) {
          int eAnnouncementIndex = _announcements
              .indexWhere((element) => element.id == state.announcementId);
          if (eAnnouncementIndex != -1) {
            _announcements[eAnnouncementIndex].is_liked =
                !(_announcements[eAnnouncementIndex].is_liked ?? false);
            if (_announcements[eAnnouncementIndex].is_liked ?? false) {
              _announcements[eAnnouncementIndex].likes_count =
                  (_announcements[eAnnouncementIndex].likes_count ?? 0) + 1;
            } else if ((_announcements[eAnnouncementIndex].likes_count ?? 0) >
                0) {
              _announcements[eAnnouncementIndex].likes_count =
                  (_announcements[eAnnouncementIndex].likes_count ?? 1) - 1;
            }
          }
          int eIndex =
              _announcementIdsLikeInProgress.indexOf(state.announcementId);
          if (eIndex != -1) {
            _announcementIdsLikeInProgress.removeAt(eIndex);
          }
          if (eAnnouncementIndex != -1 || eIndex != -1) {
            setState(() {});
          }
        }
        if (state is AnnouncementLikeToggleFail) {
          int eIndex =
              _announcementIdsLikeInProgress.indexOf(state.announcementId);
          if (eIndex != -1) {
            _announcementIdsLikeInProgress.removeAt(eIndex);
            setState(() {});
          }
        }
        if (state is SubmitAnnouncementPollLoaded) {
          int eIndex = _announcements.indexOf(state.announcement);
          if (eIndex != -1) {
            _announcements[eIndex] = state.announcement;
            setState(() {});
          }
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor("poll_submitted"));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Text(
                    AppLocalization.instance.getLocalizationFor("noticeBoard"),
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              BlocProvider.of<FetcherCubit>(context).initFetchAnnouncements(1),
          child: _announcements.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  itemCount: _announcements.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    if (index == _announcements.length - 1 &&
                        !_isLoading &&
                        !_allDone) {
                      _isLoading = true;
                      BlocProvider.of<FetcherCubit>(context)
                          .initFetchAnnouncements(_page + 1);
                    }
                    if (_announcements[index].type == "poll") {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 0.5,
                            color: theme.hintColor.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                color: theme.colorScheme.background,
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                  end: 20,
                                  top: 20,
                                  bottom: 14,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.insert_chart,
                                          color: Color(0xfff19e27),
                                        ),
                                        const SizedBox(width: 15),
                                        Expanded(
                                          child: Text(
                                            AppLocalization.instance
                                                .getLocalizationFor("poll"),
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xfff19e27),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _announcements[index]
                                                  .created_at_formatted ??
                                              "",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: theme.hintColor
                                                      .withOpacity(0.7)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      _announcements[index].message ?? "",
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        fontSize: 12,
                                        height: 1.4,
                                      ),
                                    ),
                                    for (AnnouncementOption announcementOption
                                        in (_announcements[index].options ??
                                            []))
                                      GestureDetector(
                                        onTap: () {
                                          if (_announcementPollSubmittedIds
                                              .contains(
                                                  _announcements[index].id)) {
                                            Toaster.showToastCenter(AppLocalization
                                                .instance
                                                .getLocalizationFor(
                                                    "poll_submitted_already"));
                                          } else {
                                            _announcementPollSubmittedIds
                                                .add(_announcements[index].id);
                                            BlocProvider.of<FetcherCubit>(
                                                    context)
                                                .initSubmitAnnouncementPoll(
                                                    _announcements[index].id,
                                                    announcementOption.id);
                                          }
                                        },
                                        child: Container(
                                          height: 42,
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: ((MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            80) *
                                                        announcementOption
                                                            .selectedPercentage) /
                                                    100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color:
                                                      const Color(0xffD4E4EE),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .only(
                                                  start: 20,
                                                  end: 20,
                                                ),

                                                height: 42,
                                                //
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "${announcementOption.selectedPercentage}%"),
                                                    Text(announcementOption
                                                        .title),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Color(0xff57a523),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _announcements[index]
                                              .dueDateLeftFormatted ??
                                          _announcements[index]
                                              .dueDateFormatted ??
                                          "",
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: const Color(0xff57a523),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.group,
                                    size: 16,
                                    color: theme.hintColor.withOpacity(0.7),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "${_announcements[index].response_count ?? 0} ${AppLocalization.instance.getLocalizationFor("responded")}",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.hintColor.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            width: 0.5,
                            color: theme.hintColor.withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                color: theme.colorScheme.background,
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                  end: 20,
                                  top: 20,
                                  bottom: 14,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.notifications_active,
                                          size: 16,
                                          color: Color(0xff57a523),
                                        ),
                                        const SizedBox(width: 13),
                                        Text(
                                          AppLocalization.instance
                                              .getLocalizationFor(
                                                  "announcement"),
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff57a523),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      _announcements[index].message ?? "",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: theme.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 14,
                                  ),
                                  child: Text(
                                    _announcements[index]
                                            .created_at_formatted ??
                                        "",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.hintColor.withOpacity(0.7)),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () =>
                                      BlocProvider.of<FetcherCubit>(context)
                                          .initToggleAnnouncementLike(
                                              _announcements[index].id),
                                  behavior: HitTestBehavior.translucent,
                                  child: SizedBox(
                                    width: 70,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (_announcementIdsLikeInProgress
                                            .contains(_announcements[index].id))
                                          SizedBox(
                                            height: 14,
                                            width: 14,
                                            child: Loader
                                                .circularProgressIndicatorOfColor(
                                                    (_announcements[index]
                                                                .is_liked ??
                                                            false)
                                                        ? theme.primaryColor
                                                        : theme.hintColor),
                                          )
                                        else
                                          Icon(
                                            Icons.thumb_up,
                                            color: (_announcements[index]
                                                        .is_liked ??
                                                    false)
                                                ? theme.primaryColor
                                                : theme.hintColor,
                                            size: 16,
                                          ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${_announcements[index].likes_count ?? 0}",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: theme.hintColor
                                                      .withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Row(
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: [
                                //     const SizedBox(width: 30),
                                //     Icon(
                                //       Icons.thumb_down,
                                //       color: theme.primaryColor,
                                //       size: 16,
                                //     ),
                                //     const SizedBox(width: 6),
                                //     Text(
                                //       '12',
                                //       style:
                                //           theme.textTheme.bodySmall?.copyWith(
                                //         color:
                                //             theme.hintColor.withOpacity(0.8),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              : ListView(
                  children: [
                    _isLoading
                        ? Loader.loadingWidget(context: context)
                        : ErrorFinalWidget.errorWithRetry(
                            context: context,
                            message: AppLocalization.instance
                                .getLocalizationFor("empty_announcements"),
                            imageAsset: "assets/plc_profile.png",
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
