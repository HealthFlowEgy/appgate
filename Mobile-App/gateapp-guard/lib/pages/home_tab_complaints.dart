import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/bloc/fetcher_complaints_cubit.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/models/complaint.dart';
import 'package:gateapp_guard/utility/buy_this_app.dart';
import 'package:gateapp_guard/widgets/cached_image.dart';
import 'package:gateapp_guard/widgets/error_final_widget.dart';
import 'package:gateapp_guard/widgets/loader.dart';

class HomeTabComplaints extends StatelessWidget {
  const HomeTabComplaints({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherComplaintsCubit(),
        child: const ComplaintsStateful(),
      );
}

class ComplaintsStateful extends StatefulWidget {
  const ComplaintsStateful({super.key});

  @override
  State<ComplaintsStateful> createState() => _ComplaintsStatefulState();
}

class _ComplaintsStatefulState extends State<ComplaintsStateful>
    with AutomaticKeepAliveClientMixin {
  List<Complaint> _complaints = [];
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherComplaintsCubit>(context).initFetchComplaints();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherComplaintsCubit, FetcherComplaintsState>(
      listener: (context, state) {
        if (state is ComplaintsLoaded) {
          _isLoading = false;
          _complaints = state.complaints.data;
          setState(() {});
        }
        if (state is ComplaintsFail) {
          _isLoading = false;
          setState(() {});
        }
      },
      child: Scaffold(
          body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
                onRefresh: () =>
                    BlocProvider.of<FetcherComplaintsCubit>(context)
                        .initFetchComplaints(refresh: true),
                child: _complaints.isNotEmpty
                    ? ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 14,
                        ),
                        separatorBuilder: (context, index) =>
                            const Divider(height: 40),
                        itemCount: _complaints.length,
                        itemBuilder: (context, index) {
                          if (index == _complaints.length - 1 && !_isLoading) {
                            _isLoading = true;
                            BlocProvider.of<FetcherComplaintsCubit>(context)
                                .initFetchComplaints(paginate: true);
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 8.0),
                                    child: CachedImage(
                                      imageUrl:
                                          _complaints[index].user?.imageUrl,
                                      height: 48,
                                      width: 48,
                                      radius: 24,
                                      imagePlaceholder:
                                          "assets/plc_profile.png",
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _complaints[index].user?.name ?? "",
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(fontSize: 18),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            _complaints[index].flat?.title ??
                                                "",
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(fontSize: 15),
                                          ),
                                          const SizedBox(width: 14),
                                          CircleAvatar(
                                            radius: 2,
                                            backgroundColor: theme.hintColor,
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            _complaints[index]
                                                    .created_at_formatted ??
                                                "",
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 15.0),
                                child: Text(
                                  _complaints[index].message,
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(fontSize: 18),
                                ),
                              ),
                            ],
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
                                      .getLocalizationFor("empty_complaints"),
                                  imageAsset: "assets/empty_results.png",
                                ),
                        ],
                      )),
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
      )),
    );
  }
}
