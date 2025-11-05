import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_visitor_logs_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/remote_response_type.dart';
import 'package:gateapp_user/models/visitor_log.dart';
import 'package:gateapp_user/models/visitor_log_update_request.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) => const NotificationsStateful();
}

class NotificationsStateful extends StatefulWidget {
  const NotificationsStateful({super.key});

  @override
  State<NotificationsStateful> createState() => _NotificationsStatefulState();
}

class _NotificationsStatefulState extends State<NotificationsStateful> {
  final String tabType = "waiting";
  List<VisitorLog> _visitorLogs = [];
  bool _isLoading = true;
  int _idUpdating = -1;

  @override
  void initState() {
    RemoteResponseType<VisitorLog> visitorType =
        BlocProvider.of<FetcherVisitorLogsCubit>(context)
            .getVisitorTypes
            .firstWhere((element) => element.type == "waiting");
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
                    AppLocalization.instance.getLocalizationFor("notification"),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocListener<FetcherVisitorLogsCubit, FetcherVisitorLogsState>(
        listener: (context, state) {
          if (state is VisitorLogsLoaded && state.visitorLog.type == tabType) {
            _isLoading = false;
            _visitorLogs = state.visitorLog.data;
            if (_visitorLogs.isEmpty && _idUpdating != -1) {
              Navigator.pop(context);
            } else {
              setState(() {});
            }
          }
          if (state is VisitorLogsFail && state.type == tabType) {
            _isLoading = false;
            setState(() {});
          }

          if (state is VisitorLogUpdateLoading && state.type == tabType) {
            _idUpdating = state.visitorLogId;
            if (_idUpdating == -1) {
              Loader.showLoader(context);
            } else {
              setState(() {});
            }
          } else {
            Loader.dismissLoader(context);
          }

          if (state is VisitorLogUpdateFail && state.type == tabType) {
            Toaster.showToastCenter(
                AppLocalization.instance.getLocalizationFor(state.messageKey),
                state.messageKey != "something_wrong");
          }
        },
        child: RefreshIndicator(
          onRefresh: () => BlocProvider.of<FetcherVisitorLogsCubit>(context)
              .initFetchVisitorLogs(tabType: tabType, refresh: true),
          child: _visitorLogs.isNotEmpty
              ? ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: _visitorLogs.length,
                  itemBuilder: (context, index) {
                    if (index == _visitorLogs.length - 1 && !_isLoading) {
                      _isLoading = true;
                      BlocProvider.of<FetcherVisitorLogsCubit>(context)
                          .initFetchVisitorLogs(
                              tabType: tabType, paginate: true);
                    }
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: theme.hintColor.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const SizedBox(width: 14),
                              CachedImage(
                                imageUrl: _visitorLogs[index].imageUrl,
                                imagePlaceholder: _visitorLogs[index].type ==
                                        Constants.visitorTypeCab
                                    ? "assets/plc_vehicle.png"
                                    : "assets/plc_profile.png",
                                height: 46,
                                width: 46,
                                radius: 23,
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _visitorLogs[index].nameToShow,
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                              fontSize: 15,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _visitorLogs[index]
                                                  .created_at_formatted ??
                                              "",
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.hintColor
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      AppLocalization.instance.getLocalizationFor(
                                          "visitor_type_${_visitorLogs[index].type}"),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color: theme.hintColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 14),
                            ],
                          ),
                          const SizedBox(height: 14),
                          if (_idUpdating == _visitorLogs[index].id)
                            SizedBox(
                              height: 1,
                              child: Loader.linearProgressIndicatorPrimary(
                                  context),
                            )
                          else
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: theme.hintColor.withOpacity(0.2),
                            ),
                          SizedBox(
                            height: 36,
                            child: Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () => BlocProvider.of<
                                            FetcherVisitorLogsCubit>(context)
                                        .initUpdateVisitorLog(
                                            tabType,
                                            _visitorLogs[index].id,
                                            VisitorLogUpdateRequest(
                                                status: "rejected")),
                                    child: Text(
                                      AppLocalization.instance
                                          .getLocalizationFor("reject"),
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        fontSize: 15,
                                        color: const Color(0xffc93c3c),
                                      ),
                                    ),
                                  ),
                                ),
                                const VerticalDivider(thickness: 1),
                                Expanded(
                                  child: MaterialButton(
                                    onPressed: () => BlocProvider.of<
                                            FetcherVisitorLogsCubit>(context)
                                        .initUpdateVisitorLog(
                                            tabType,
                                            _visitorLogs[index].id,
                                            VisitorLogUpdateRequest(
                                                status: "approved")),
                                    child: Text(
                                      AppLocalization.instance
                                          .getLocalizationFor("accept"),
                                      textAlign: TextAlign.center,
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        fontSize: 15,
                                        color: const Color(0xff93c152),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                .getLocalizationFor("empty_notifications"),
                            imageAsset: "assets/plc_profile.png",
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
