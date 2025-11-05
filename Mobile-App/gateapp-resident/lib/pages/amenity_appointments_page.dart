import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/amenity_appointment.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';

class AmenityAppointmentsPage extends StatelessWidget {
  const AmenityAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const AmenityAppointmentsStateful(),
      );
}

class AmenityAppointmentsStateful extends StatefulWidget {
  const AmenityAppointmentsStateful({super.key});

  @override
  State<AmenityAppointmentsStateful> createState() =>
      _AmenityAppointmentsStatefulState();
}

class _AmenityAppointmentsStatefulState
    extends State<AmenityAppointmentsStateful> {
  final List<AmenityAppointment> _amenityAppointments = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchAmenityAppointments(1);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is AmenityAppointmentsLoaded) {
          _isLoading = false;
          _page = state.amenityAppointments.meta.current_page ?? 1;
          _allDone = state.amenityAppointments.meta.current_page ==
              state.amenityAppointments.meta.last_page;
          if (state.amenityAppointments.meta.current_page == 1) {
            _amenityAppointments.clear();
          }
          _amenityAppointments.addAll(state.amenityAppointments.data);
          setState(() {});
        }
        if (state is AmenityAppointmentsFail) {
          _isLoading = false;
          setState(() {});
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
                      AppLocalization.instance
                          .getLocalizationFor("bookedAmenities"),
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: _amenityAppointments.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 30,
                  bottom: 100,
                ),
                itemCount: _amenityAppointments.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  if (index == _amenityAppointments.length - 1) {
                    _paginateList();
                  }
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
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
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 20,
                                    top: 20,
                                    bottom: 14,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _amenityAppointments[index]
                                                    .amenity
                                                    ?.title ??
                                                "...",
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        _amenityAppointments[index]
                                            .bookedForDateTimeSummary,
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                                color: theme.primaryColor),
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
                                      color:
                                          _amenityAppointments[index].status ==
                                                  "accepted"
                                              ? const Color(0xff57a523)
                                              : const Color(0xffe3bb1b),
                                      borderRadius:
                                          const BorderRadiusDirectional.only(
                                        topEnd: Radius.circular(12),
                                        bottomStart: Radius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      AppLocalization.instance
                                          .getLocalizationFor(
                                              "appointment_status_${_amenityAppointments[index].status}")
                                          .toUpperCase(),
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
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
                          const SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: theme.hintColor,
                                      ),
                                      children: [
                                        TextSpan(
                                            text: AppLocalization.instance
                                                .getLocalizationFor(
                                                    "raisedBy")),
                                        TextSpan(
                                          text:
                                              " ${_amenityAppointments[index].resident!.user?.name}",
                                          style: TextStyle(
                                              color: theme.primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  _amenityAppointments[index]
                                          .created_at_formatted ??
                                      "",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.hintColor.withOpacity(0.7)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Divider(height: 1),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 14),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.verified_user,
                                  color: Color(0xff57a523),
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    (_amenityAppointments[index].amount ?? 0) >
                                            0
                                        ? _amenityAppointments[index]
                                                .payment
                                                ?.paymentMethod
                                                .title ??
                                            "cod"
                                        : AppLocalization.instance
                                            .getLocalizationFor("noPayment"),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xff57a523),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  (_amenityAppointments[index].amount ?? 0) > 0
                                      ? (_amenityAppointments[index]
                                              .amount_to_show ??
                                          "0")
                                      : AppLocalization.instance
                                          .getLocalizationFor("free"),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : _isLoading
                ? Loader.loadingWidget(context: context)
                : ErrorFinalWidget.errorWithRetry(
                    context: context,
                    message: AppLocalization.instance
                        .getLocalizationFor("empty_amenity_appointments"),
                    imageAsset: "assets/empty_results.png",
                  ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: () => Navigator.pushNamed(context, PageRoutes.amenitiesPage),
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
                  AppLocalization.instance.getLocalizationFor("bookAmenity"),
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
      BlocProvider.of<FetcherCubit>(context)
          .initFetchAmenityAppointments(_page + 1);
      _isLoading = true;
    }
  }
}
