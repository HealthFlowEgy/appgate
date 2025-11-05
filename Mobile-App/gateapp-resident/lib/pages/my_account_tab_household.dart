import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:shimmer/shimmer.dart';

import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/visitor_log.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/confirm_dialog.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class MyAccountTabHouseHold extends StatelessWidget {
  const MyAccountTabHouseHold({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const AccountHouseholdStateful(),
      );
}

class AccountHouseholdStateful extends StatefulWidget {
  const AccountHouseholdStateful({super.key});

  @override
  State<AccountHouseholdStateful> createState() =>
      _AccountHouseholdStatefulState();
}

class _AccountHouseholdStatefulState extends State<AccountHouseholdStateful>
    with AutomaticKeepAliveClientMixin<AccountHouseholdStateful> {
  final List<VisitorType> visitorTypes = [
    VisitorType(Constants.visitorTypeHouseholdFamily),
    VisitorType(Constants.visitorTypeHouseholdDailyHelp),
    VisitorType(Constants.visitorTypeHouseholdVehicle)
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    for (VisitorType visitorType in visitorTypes) {
      BlocProvider.of<FetcherCubit>(context).initFetchVisitorLogs(
        type: visitorType.type,
        pageNo: 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is VisitorLogsLoaded) {
          int visitorTypeIndex =
              visitorTypes.indexWhere((element) => element.type == state.type);
          if (visitorTypeIndex != -1) {
            visitorTypes[visitorTypeIndex].isLoading = false;
            visitorTypes[visitorTypeIndex].page =
                state.visitorLogs.meta.current_page ?? 1;
            visitorTypes[visitorTypeIndex].allDone =
                state.visitorLogs.meta.current_page ==
                    state.visitorLogs.meta.last_page;
            if (state.visitorLogs.meta.current_page == 1) {
              visitorTypes[visitorTypeIndex].visitorLogs.clear();
            }
            visitorTypes[visitorTypeIndex]
                .visitorLogs
                .addAll(state.visitorLogs.data);
            setState(() {});
          }
        }
        if (state is VisitorLogsFail) {
          int visitorTypeIndex =
              visitorTypes.indexWhere((element) => element.type == state.type);
          if (visitorTypeIndex != -1) {
            visitorTypes[visitorTypeIndex].isLoading = false;
            setState(() {});
          }
        }

        if (state is DeleteVisitorLogLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is DeleteVisitorLogLoaded) {
          int visitorTypeIndex =
              visitorTypes.indexWhere((element) => element.type == state.type);
          if (visitorTypeIndex != -1) {
            visitorTypes[visitorTypeIndex]
                .visitorLogs
                .removeWhere((element) => element.id == state.visitorLogId);
            setState(() {});
          }
        }
        if (state is DeleteVisitorLogFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
        }
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        children: [
          for (VisitorType visitorType in visitorTypes)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalization.instance
                            .getLocalizationFor(visitorType.type),
                        style:
                            theme.textTheme.labelLarge?.copyWith(fontSize: 15),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                              context, PageRoutes.addVisitorLogCustomPage,
                              arguments: visitorType.type)
                          .then((value) {
                        if (value != null && value is VisitorLog) {
                          int visitorTypeIndex = visitorTypes.indexWhere(
                              (element) => element.type == visitorType.type);
                          if (visitorTypeIndex != -1) {
                            visitorTypes[visitorTypeIndex]
                                .visitorLogs
                                .insert(0, value);
                            setState(() {});
                          }
                        }
                      }),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: Colors.transparent,
                        child: Text(
                          "+ ${AppLocalization.instance.getLocalizationFor("add")}",
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 15,
                            color: const Color(0xff723fbe),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalization.instance
                      .getLocalizationFor("${visitorType.type}_msg"),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor.withOpacity(0.5)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 140,
                  child: visitorType.visitorLogs.isNotEmpty
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: visitorType.visitorLogs.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            if (index == visitorType.visitorLogs.length - 1) {
                              _paginateList(visitorType.type);
                            }
                            return Container(
                              width: 116,
                              padding: const EdgeInsets.only(
                                top: 14,
                                bottom: 16,
                                left: 14,
                                right: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: theme.colorScheme.background,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => Navigator.pushNamed(
                                                context,
                                                PageRoutes.gatePassPage,
                                                arguments: visitorType
                                                    .visitorLogs[index]),
                                            child: CachedImage(
                                              radius: 30,
                                              imageUrl: visitorType
                                                  .visitorLogs[index].imageUrl,
                                              imagePlaceholder: visitorType
                                                          .type ==
                                                      Constants
                                                          .visitorTypeHouseholdVehicle
                                                  ? "assets/plc_vehicle.png"
                                                  : "assets/plc_profile.png",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () =>
                                              ConfirmDialog.showConfirmation(
                                                      context,
                                                      Text(AppLocalization
                                                          .instance
                                                          .getLocalizationFor(
                                                              "delete_member")),
                                                      Text(AppLocalization
                                                          .instance
                                                          .getLocalizationFor(
                                                              "delete_member_msg")),
                                                      AppLocalization.instance
                                                          .getLocalizationFor(
                                                              "no"),
                                                      AppLocalization.instance
                                                          .getLocalizationFor(
                                                              "yes"))
                                                  .then((value) {
                                            if (value != null &&
                                                value == true) {
                                              BlocProvider.of<FetcherCubit>(
                                                      context)
                                                  .initDeleteVisitorLog(
                                                      visitorType
                                                          .visitorLogs[index]
                                                          .id,
                                                      visitorType.type);
                                            }
                                          }),
                                          child: Icon(
                                            Icons.delete,
                                            size: 16,
                                            color: theme.hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, PageRoutes.gatePassPage,
                                        arguments:
                                            visitorType.visitorLogs[index]),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            visitorType
                                                    .visitorLogs[index].name ??
                                                visitorType.visitorLogs[index]
                                                    .vehicle_number ??
                                                "",
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.qr_code,
                                          color: theme.hintColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // const SizedBox(height: 6),
                                  // Text(
                                  //   subtitle,
                                  //   style: theme.textTheme.bodySmall?.copyWith(
                                  //         color: theme.hintColor.withOpacity(0.7),
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        )
                      : visitorType.isLoading
                          ? ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: visitorType.type ==
                                      Constants.visitorTypeHouseholdVehicle
                                  ? 2
                                  : visitorType.type ==
                                          Constants
                                              .visitorTypeHouseholdDailyHelp
                                      ? 3
                                      : 5,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) => Container(
                                width: 116,
                                padding: const EdgeInsets.only(
                                  top: 14,
                                  bottom: 16,
                                  left: 14,
                                  right: 14,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: theme.colorScheme.background,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Image.asset(visitorType
                                                        .type ==
                                                    Constants
                                                        .visitorTypeHouseholdVehicle
                                                ? "assets/plc_vehicle.png"
                                                : "assets/plc_profile.png"),
                                          ),
                                          const SizedBox(width: 16),
                                          Icon(
                                            Icons.circle,
                                            size: 14,
                                            color: theme.hintColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            child: Container(
                                              height: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(
                                          Icons.square,
                                          color: theme.hintColor,
                                        ),
                                      ],
                                    ),
                                    // const SizedBox(height: 6),
                                    // Text(
                                    //   subtitle,
                                    //   style: theme.textTheme.bodySmall?.copyWith(
                                    //         color: theme.hintColor.withOpacity(0.7),
                                    //         fontWeight: FontWeight.w500,
                                    //       ),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          : ErrorFinalWidget.errorWithRetry(
                              context: context,
                              message: AppLocalization.instance
                                  .getLocalizationFor(visitorType.type ==
                                          Constants.visitorTypeHouseholdVehicle
                                      ? "empty_vehicles"
                                      : "empty_visitors"),
                              imageAsset: visitorType.type ==
                                      Constants.visitorTypeHouseholdVehicle
                                  ? "assets/plc_vehicle.png"
                                  : "assets/plc_profile.png",
                            ),
                ),
                const SizedBox(height: 28),
              ],
            ),
        ],
      ),
    );
  }

  void _paginateList(String type) {
    int visitorTypeIndex =
        visitorTypes.indexWhere((element) => element.type == type);
    if (visitorTypeIndex != -1) {
      if (!visitorTypes[visitorTypeIndex].allDone &&
          !visitorTypes[visitorTypeIndex].isLoading) {
        BlocProvider.of<FetcherCubit>(context).initFetchVisitorLogs(
          type: visitorTypes[visitorTypeIndex].type,
          pageNo: visitorTypes[visitorTypeIndex].page + 1,
        );
        visitorTypes[visitorTypeIndex].isLoading = true;
      }
    }
  }
}

class VisitorType {
  String type;
  late bool isLoading;
  late bool allDone;
  late int page;
  late List<VisitorLog> visitorLogs;

  VisitorType(this.type) {
    isLoading = true;
    allDone = false;
    page = 1;
    visitorLogs = [];
  }
}
