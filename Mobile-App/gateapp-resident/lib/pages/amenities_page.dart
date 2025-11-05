import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/amenity.dart';
import 'package:gateapp_user/widgets/error_final_widget.dart';
import 'package:gateapp_user/widgets/loader.dart';

class AmenitiesPage extends StatelessWidget {
  const AmenitiesPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const AmenitiesStateful(),
      );
}

class AmenitiesStateful extends StatefulWidget {
  const AmenitiesStateful({super.key});

  @override
  State<AmenitiesStateful> createState() => _AmenitiesStatefulState();
}

class _AmenitiesStatefulState extends State<AmenitiesStateful> {
  bool _isLoading = true;
  List<Amenity> amenities = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetcherCubit>(context).initFetchAmenities();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is AmenitiesLoaded) {
          amenities = state.amenities;
          _isLoading = false;
          setState(() {});
        }
        if (state is AmenitiesFail) {
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
                        .getLocalizationFor("selectAmenity"),
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: amenities.isNotEmpty
            ? ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 14),
                itemCount: amenities.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => Navigator.pushNamed(
                      context, PageRoutes.addAmenityAppointmentPage,
                      arguments: amenities[index]),
                  child: Container(
                    height: 54,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: theme.hintColor.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            amenities[index].title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          AppLocalization.instance.getLocalizationFor(
                              amenities[index].isPaid ? "paid" : "free"),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: amenities[index].isPaid
                                ? const Color(0xffe3bb1b)
                                : const Color(0xff5faf1e),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : _isLoading
                ? Loader.loadingWidget(context: context)
                : ErrorFinalWidget.errorWithRetry(
                    context: context,
                    message: AppLocalization.instance
                        .getLocalizationFor("empty_amenities"),
                    imageAsset: "assets/empty_results.png",
                  ),
      ),
    );
  }
}
