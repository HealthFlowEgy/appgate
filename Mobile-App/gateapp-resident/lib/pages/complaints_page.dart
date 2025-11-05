import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/complaint.dart';
import 'package:gateapp_user/models/complaint_update_request.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const ComplaintsStateful(),
      );
}

class ComplaintsStateful extends StatefulWidget {
  const ComplaintsStateful({super.key});

  @override
  State<ComplaintsStateful> createState() => _ComplaintsStatefulState();
}

class _ComplaintsStatefulState extends State<ComplaintsStateful> {
  final ScrollController _scrollController = ScrollController();
  final List<Complaint> _complaints = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchComplaints(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is ComplaintsLoaded) {
          _isLoading = false;
          _page = state.complaints.meta.current_page ?? 1;
          _allDone = state.complaints.meta.current_page ==
              state.complaints.meta.last_page;
          if (state.complaints.meta.current_page == 1) {
            _complaints.clear();
          }
          _complaints.addAll(state.complaints.data);
          setState(() {});
        }
        if (state is ComplaintsFail) {
          _isLoading = false;
          setState(() {});
        }
        if (state is CreateUpdateComplaintLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }
        if (state is CreateUpdateComplaintLoaded) {
          int index = -1;
          for (int i = 0; i < _complaints.length; i++) {
            if (_complaints[i].id == state.complaint.id) {
              index = i;
              break;
            }
          }
          if (index != -1) {
            _complaints[index] = state.complaint;
            setState(() {});
          }
        }
        if (state is CreateUpdateComplaintFail) {
          Toaster.showToastCenter(
              AppLocalization.instance.getLocalizationFor(state.messageKey),
              state.messageKey != "something_wrong");
          Navigator.pop(context);
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
                  Expanded(
                    child: Text(
                      AppLocalization.instance.getLocalizationFor("helpDesk"),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: _complaints.isNotEmpty
            ? ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                  bottom: 100,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemCount: _complaints.length,
                itemBuilder: (context, index) {
                  if (index == _complaints.length - 1) {
                    _paginateList();
                  }
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
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                  top: 20,
                                  bottom: 14,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _complaints[index].category?.title ??
                                              AppLocalization.instance
                                                  .getLocalizationFor(
                                                      "message"),
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(width: 15),
                                        CircleAvatar(
                                          radius: 2,
                                          backgroundColor:
                                              theme.hintColor.withOpacity(0.7),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          AppLocalization.instance
                                              .getLocalizationFor(
                                                  "complaint_type_${_complaints[index].type}"),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                            color: theme.hintColor
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      _complaints[index].message,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: theme.primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              PositionedDirectional(
                                top: 0,
                                end: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 28,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    color: _complaints[index].status == "new"
                                        ? const Color(0xff57a523)
                                        : const Color(0xffe3bb1b),
                                    borderRadius:
                                        const BorderRadiusDirectional.only(
                                      topEnd: Radius.circular(12),
                                      bottomStart: Radius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    _complaints[index].status == "new"
                                        ? AppLocalization.instance
                                            .getLocalizationFor("neww")
                                            .toUpperCase()
                                        : AppLocalization.instance
                                            .getLocalizationFor("resolved")
                                            .toUpperCase(),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.scaffoldBackgroundColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 14,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (_complaints[index].status == "new") {
                                BlocProvider.of<FetcherCubit>(context)
                                    .initUpdateComplaint(
                                        _complaints[index].id,
                                        ComplaintUpdateRequest(
                                            status: "resolved"));
                              }
                              // else if (_complaints[index].status ==
                              //     "resolved") {
                              //   ConfirmDialog.showConfirmation(
                              //           context,
                              //           Text(AppLocalization.instance
                              //               .getLocalizationFor(
                              //                   "mar_unresolved")),
                              //           Text(AppLocalization.instance
                              //               .getLocalizationFor(
                              //                   "mar_unresolved_msg")),
                              //           AppLocalization.instance
                              //               .getLocalizationFor("no"),
                              //           AppLocalization.instance
                              //               .getLocalizationFor("yes"))
                              //       .then((value) {
                              //     if (value != null && value == true) {
                              //       BlocProvider.of<FetcherCubit>(context)
                              //           .initUpdateComplaint(
                              //               _complaints[index].id,
                              //               ComplaintUpdateRequest(
                              //                   status: "new"));
                              //     }
                              //   });
                              // }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _complaints[index].created_at_formatted ??
                                        "",
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                if (_complaints[index].status == "new")
                                  Icon(
                                    _complaints[index].status == "new"
                                        ? Icons.thumb_up
                                        : Icons.undo,
                                    color: const Color(0xff57a523),
                                    size: 16,
                                  ),
                                const SizedBox(width: 6),
                                Text(
                                  _complaints[index].status == "new"
                                      ? AppLocalization.instance
                                          .getLocalizationFor("markAsResolved")
                                      : "",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xff57a523),
                                    fontWeight: FontWeight.w500,
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
            : _isLoading
                ? Loader.loadingWidget(context: context)
                : ErrorFinalWidget.errorWithRetry(
                    context: context,
                    message: AppLocalization.instance
                        .getLocalizationFor("empty_complaints"),
                    imageAsset: "assets/empty_results.png",
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: () => Navigator.pushNamed(context, PageRoutes.addComplaintPage)
              .then((value) {
            if (value != null && value is Complaint) {
              _complaints.insert(0, value);
              setState(() {});
              _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              );
            }
          }),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.primaryColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  size: 16,
                  color: theme.scaffoldBackgroundColor,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalization.instance
                      .getLocalizationFor("raiseNewComplaint"),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _paginateList() {
    if (!_allDone && !_isLoading) {
      BlocProvider.of<FetcherCubit>(context).initFetchComplaints(_page + 1);
      _isLoading = true;
    }
  }
}
