import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/models/remote_response_type.dart';
import 'package:gateapp_guard/utility/buy_this_app.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:gateapp_guard/bloc/fetcher_visitor_logs_cubit.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/models/visitor_log.dart';
import 'package:gateapp_guard/models/visitor_log_update_request.dart';
import 'package:gateapp_guard/utility/constants.dart';
import 'package:gateapp_guard/widgets/cached_image.dart';
import 'package:gateapp_guard/widgets/error_final_widget.dart';
import 'package:gateapp_guard/widgets/loader.dart';
import 'package:gateapp_guard/widgets/toaster.dart';

class HomeTabVisitorLogs extends StatelessWidget {
  const HomeTabVisitorLogs({super.key});

  @override
  Widget build(BuildContext context) => const VisitorLogsStateful();
}

class VisitorLogsStateful extends StatefulWidget {
  const VisitorLogsStateful({super.key});

  @override
  State<VisitorLogsStateful> createState() => _VisitorLogsStatefulState();
}

class _VisitorLogsStatefulState extends State<VisitorLogsStateful>
    implements TabCallbacks {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: theme.colorScheme.background,
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: theme.primaryColor,
                    labelColor: theme.primaryColor,
                    labelStyle:
                        theme.textTheme.titleSmall?.copyWith(fontSize: 15),
                    unselectedLabelColor: theme.hintColor,
                    tabs: [
                      Tab(
                          text: AppLocalization.instance
                              .getLocalizationFor("waiting")),
                      Tab(
                          text: AppLocalization.instance
                              .getLocalizationFor("inside"))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                VisitorLogsTabStateful(
                  tabType: "waiting",
                  tabCallbacks: this,
                ),
                VisitorLogsTabStateful(
                  tabType: "inside",
                  tabCallbacks: this,
                ),
              ],
            ),
          ),
          if (AppConfig.isDemoMode)
            Container(
              color: theme.scaffoldBackgroundColor,
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 0.8,
              child: BuyThisApp.developerRowVerbose(
                backgroundColor: Colors.transparent,
                textColor: theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  @override
  onItemClick(String tabType, VisitorLog visitorLog) {
    if (visitorLog.status == "inside") {
      BlocProvider.of<FetcherVisitorLogsCubit>(context).initUpdateVisitorLog(
          tabType,
          visitorLog.id,
          VisitorLogUpdateRequest(
            status: "left",
            outtime: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
            type: visitorLog.type.contains("household_")
                ? visitorLog.type.substring(visitorLog.type.indexOf("_") + 1)
                : null,
          ));
    } else if (visitorLog.status == "approved") {
      BlocProvider.of<FetcherVisitorLogsCubit>(context).initUpdateVisitorLog(
          tabType,
          visitorLog.id,
          VisitorLogUpdateRequest(
            status: "inside",
            intime: DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
            type: visitorLog.type.contains("household_")
                ? visitorLog.type.substring(visitorLog.type.indexOf("_") + 1)
                : null,
          ));
    }
  }

  @override
  Future<void> onFetch(
          {required String tabType, bool? refresh, bool? paginate}) =>
      BlocProvider.of<FetcherVisitorLogsCubit>(context).initFetchVisitorLogs(
          tabType: tabType, refresh: refresh, paginate: paginate);
}

class VisitorLogsTabStateful extends StatefulWidget {
  final String tabType;
  final TabCallbacks tabCallbacks;
  const VisitorLogsTabStateful(
      {super.key, required this.tabType, required this.tabCallbacks});

  @override
  State<VisitorLogsTabStateful> createState() => _VisitorLogsTabStatefulState();
}

class _VisitorLogsTabStatefulState extends State<VisitorLogsTabStateful>
    with AutomaticKeepAliveClientMixin {
  List<VisitorLog> _visitorLogs = [];
  bool _isLoading = true;
  int _idUpdating = -1;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    RemoteResponseType<VisitorLog> visitorType =
        BlocProvider.of<FetcherVisitorLogsCubit>(context)
            .getVisitorTypes
            .firstWhere((element) => element.type == widget.tabType);
    _visitorLogs = visitorType.data;
    _isLoading = visitorType.isLoading;
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (_isLoading && mounted) {
        _isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<FetcherVisitorLogsCubit, FetcherVisitorLogsState>(
      listener: (context, state) {
        if (state is VisitorLogsLoaded &&
            state.visitorLog.type == widget.tabType) {
          _isLoading = false;
          _visitorLogs = state.visitorLog.data;
          setState(() {});
        }
        if (state is VisitorLogsFail && state.type == widget.tabType) {
          _isLoading = false;
          setState(() {});
        }

        if (state is VisitorLogUpdateLoading && state.type == widget.tabType) {
          _idUpdating = state.visitorLogId;
          if (_idUpdating == -1) {
            Loader.showLoader(context);
          } else {
            setState(() {});
          }
        } else {
          Loader.dismissLoader(context);
        }

        if (state is VisitorLogUpdateFail && state.type == widget.tabType) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
        }
      },
      child: RefreshIndicator(
          onRefresh: () => widget.tabCallbacks
              .onFetch(tabType: widget.tabType, refresh: true),
          child: _visitorLogs.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: _visitorLogs.length,
                  itemBuilder: (context, index) {
                    if (index == _visitorLogs.length - 1 && !_isLoading) {
                      _isLoading = true;
                      widget.tabCallbacks
                          .onFetch(tabType: widget.tabType, paginate: true);
                    }
                    return ListItemVisitorLog(
                      visitorLog: _visitorLogs[index],
                      isLoading: _idUpdating == _visitorLogs[index].id,
                      onActionTap: () => widget.tabCallbacks
                          .onItemClick(widget.tabType, _visitorLogs[index]),
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
                                .getLocalizationFor("empty_visitors"),
                            imageAsset: "assets/plc_profile.png",
                          ),
                  ],
                )),
    );
  }
}

class ListItemVisitorLog extends StatelessWidget {
  final VisitorLog visitorLog;
  final Function() onActionTap;
  final bool isLoading;
  const ListItemVisitorLog({
    super.key,
    required this.visitorLog,
    required this.onActionTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 12,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12.0),
            child: CachedImage(
              radius: 22,
              height: 44,
              width: 44,
              imageUrl: visitorLog.imageUrl,
              imagePlaceholder: visitorLog.type == Constants.visitorTypeCab
                  ? "assets/plc_vehicle.png"
                  : "assets/plc_profile.png",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  visitorLog.nameToShow,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      AppLocalization.instance.getLocalizationFor(
                          "visitor_type_${visitorLog.type}"),
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: theme.hintColor),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 2,
                      backgroundColor: theme.hintColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      visitorLog.flat?.title ?? "",
                      style: theme.textTheme.titleSmall
                          ?.copyWith(color: theme.hintColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          MaterialButton(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: visitorLog.status == "inside"
                ? const Color(0xffe43f5e)
                : (visitorLog.status == "approved"
                    ? const Color(0xff2ba41e)
                    : const Color(0xffC8D3D9)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: () => onActionTap.call(),
            child: isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: Loader.circularProgressIndicatorWhite(),
                  )
                : visitorLog.status == "inside" ||
                        visitorLog.status == "approved"
                    ? Text(
                        AppLocalization.instance.getLocalizationFor(
                            visitorLog.status == "inside" ? "out" : "inn"),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 18,
                          color: theme.scaffoldBackgroundColor,
                        ),
                      )
                    : Icon(
                        Icons.access_time,
                        color: theme.scaffoldBackgroundColor,
                      ),
          ),
        ],
      ),
    );
  }
}

abstract class TabCallbacks {
  Future<void> onFetch(
      {required String tabType, bool? refresh, bool? paginate});
  onItemClick(String tabType, VisitorLog visitorLog);
}
