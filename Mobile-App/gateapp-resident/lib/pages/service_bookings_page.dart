import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/service_booking.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';

class ServiceBookingsPage extends StatelessWidget {
  const ServiceBookingsPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const ServiceBookingsStateful(),
      );
}

class ServiceBookingsStateful extends StatefulWidget {
  const ServiceBookingsStateful({super.key});

  @override
  State<ServiceBookingsStateful> createState() =>
      _ServiceBookingsStatefulState();
}

class _ServiceBookingsStatefulState extends State<ServiceBookingsStateful> {
  final List<ServiceBooking> _bookings = [];
  bool _isLoading = true;
  int _page = 1;
  bool _allDone = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchServiceBookings(1);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is ServiceBookingsLoaded) {
          _isLoading = false;
          _page = state.serviceBookingsResponse.meta.current_page ?? 1;
          _allDone = state.serviceBookingsResponse.meta.current_page ==
              state.serviceBookingsResponse.meta.last_page;
          if (state.serviceBookingsResponse.meta.current_page == 1) {
            _bookings.clear();
          }
          _bookings.addAll(state.serviceBookingsResponse.data);
          setState(() {});
        }
        if (state is ServiceBookingsFail) {
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
                  Text(
                    AppLocalization.instance
                        .getLocalizationFor("service_bookings"),
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () => BlocProvider.of<FetcherCubit>(context)
              .initFetchServiceBookings(1),
          child: _bookings.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 20,
                  ),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 20),
                  itemCount: _bookings.length,
                  itemBuilder: (context, index) {
                    if (index == _bookings.length - 1 &&
                        !_isLoading &&
                        !_allDone) {
                      _isLoading = true;
                      BlocProvider.of<FetcherCubit>(context)
                          .initFetchServiceBookings(_page + 1);
                    }
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: theme.colorScheme.background,
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 85),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 18),
                                    Text(
                                      _bookings[index].service.title,
                                      style:
                                          theme.textTheme.titleSmall?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _bookings[index].details,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          theme.textTheme.labelLarge?.copyWith(
                                        color: theme.hintColor.withOpacity(0.5),
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: theme.hintColor,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "${_bookings[index].dateFormatted}  |  ${_bookings[index].timeFormatted}",
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          AppLocalization.instance
                                              .getLocalizationFor(
                                                  "service_booking_status_${_bookings[index].status}"),
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                  color:
                                                      const Color(0xff5cb31d)),
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          start: 28,
                          top: 12,
                          bottom: -40,
                          child: CachedImage(
                            imageUrl: _bookings[index].service.image_url,
                            width: 70,
                            fit: BoxFit.cover,
                            imagePlaceholder: "assets/empty_image.png",
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
                                .getLocalizationFor("empty_bookings"),
                            imageAsset: "assets/plc_profile.png",
                          ),
                  ],
                ),
        ),
      ),
    );
  }
}
