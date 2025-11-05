import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/category.dart';
import 'package:gateapp_user/models/service_booking.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/widgets/cached_image.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/notification_indicator_icon_widget.dart';
import 'package:gateapp_user/widgets/profile_icon_widget.dart';

class BottomTabServices extends StatelessWidget {
  final Key? servicesTabStatefulKey;
  const BottomTabServices({
    super.key,
    this.servicesTabStatefulKey,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: ServicesTabStateful(key: servicesTabStatefulKey),
      );
}

class ServicesTabStateful extends StatefulWidget {
  const ServicesTabStateful({super.key});

  @override
  State<ServicesTabStateful> createState() => ServicesTabStatefulState();
}

class ServicesTabStatefulState extends State<ServicesTabStateful> {
  List<Category> _services = [];
  bool _isLoading = true;
  ServiceBooking? _serviceBooking;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context)
        .initFetchCategoriesWithScope(Constants.scopeService);
    BlocProvider.of<FetcherCubit>(context).initFetchServiceBookings(1);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          _isLoading = false;
          _services = state.categories;
          setState(() {});
        }
        if (state is CategoriesFail) {
          _isLoading = false;
          setState(() {});
        }
        if (state is ServiceBookingsLoaded) {
          _serviceBooking = state.serviceBookingsResponse.data.isNotEmpty
              ? state.serviceBookingsResponse.data.first
              : null;
          setState(() {});
        }
        if (state is ServiceBookingsFail) {
          _serviceBooking = null;
          setState(() {});
        }
      },
      child: ListView(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, PageRoutes.notificationsPage),
                child: const NotificationIndicatorIconWidget(),
              ),
              Expanded(
                child: Text(
                  AppLocalization.instance.getLocalizationFor("services"),
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, PageRoutes.myAccountPage)
                        .then((value) => setState(() {})),
                child: const ProfileIconWidget(),
              ),
            ],
          ),
          const SizedBox(height: 28),
          if (_serviceBooking != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalization.instance.getLocalizationFor("yourBookings"),
                    style: theme.textTheme.titleSmall,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, PageRoutes.serviceBookingsPage),
                    child: Text(
                        AppLocalization.instance.getLocalizationFor("view_all"),
                        style:
                            theme.textTheme.bodySmall?.copyWith(fontSize: 14)),
                  ),
                ],
              ),
            ),
          if (_serviceBooking != null) const SizedBox(height: 20),
          if (_serviceBooking != null)
            Stack(
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
                              _serviceBooking!.service.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _serviceBooking!.details,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelLarge?.copyWith(
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
                                    "${_serviceBooking!.dateFormatted}  |  ${_serviceBooking!.timeFormatted}",
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  AppLocalization.instance.getLocalizationFor(
                                      "service_booking_status_${_serviceBooking!.status}"),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                      color: const Color(0xff5cb31d)),
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
                    imageUrl: _serviceBooking!.service.image_url,
                    width: 70,
                    fit: BoxFit.cover,
                    imagePlaceholder: "assets/empty_image.png",
                  ),
                ),
              ],
            ),
          if (_serviceBooking != null) const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppLocalization.instance.getLocalizationFor("selectService"),
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 20),
          _services.isNotEmpty
              ? GridView.builder(
                  itemCount: _services.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _onServiceSelect(_services[index]),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 70,
                                child: Text(
                                  _services[index].title,
                                  style: theme.textTheme.labelLarge
                                      ?.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        PositionedDirectional(
                          top: 10,
                          end: 10,
                          bottom: -48,
                          child: CachedImage(
                            imageUrl: _services[index].image_url,
                            imagePlaceholder: "assets/empty_image.png",
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _isLoading
                  ? Loader.loadingWidget(context: context)
                  : ErrorFinalWidget.errorWithRetry(
                      context: context,
                      message: AppLocalization.instance
                          .getLocalizationFor("empty_services"),
                      imageAsset: "assets/empty_image.png",
                    ),
        ],
      ),
    );
  }

  void handleFloatingAction() {
    if (_services.isNotEmpty) {
      Navigator.pushNamed(context, PageRoutes.serviceSearchPage,
              arguments: _services)
          .then((value) {
        if (value != null && value is Category) {
          _onServiceSelect(value);
        }
      });
    }
  }

  _onServiceSelect(Category service) =>
      Navigator.pushNamed(context, PageRoutes.addServiceBookingPage,
              arguments: service)
          .then((value) {
        if (value != null && value is ServiceBooking) {
          _serviceBooking = value;
          setState(() {});
        }
      });
}
