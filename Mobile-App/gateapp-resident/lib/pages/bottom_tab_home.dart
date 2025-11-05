import 'package:flutter/material.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/visitor_log.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/widgets/notification_indicator_icon_widget.dart';
import 'package:gateapp_user/widgets/profile_icon_widget.dart';

import 'bottom_navigation_page.dart';

class BottomTabHome extends StatelessWidget {
  final BottomTabCallbacks bottomTabCallbacks;
  const BottomTabHome({super.key, required this.bottomTabCallbacks});

  @override
  Widget build(BuildContext context) => HomeTabStateful(bottomTabCallbacks);
}

class HomeTabStateful extends StatefulWidget {
  final BottomTabCallbacks bottomTabCallbacks;
  const HomeTabStateful(this.bottomTabCallbacks, {super.key});

  @override
  State<HomeTabStateful> createState() => _HomeTabStatefulState();
}

class _HomeTabStatefulState extends State<HomeTabStateful> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final List<HomeItem> visitors = [
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("addGuest"),
        image: "assets/visitor_types/allow_guest.png",
        onTap: () => _addVisitorLog(Constants.visitorTypeGuest),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("addDelivery"),
        image: "assets/visitor_types/allow_deliveryman.png",
        onTap: () => _addVisitorLog(Constants.visitorTypeDelivery),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("addService"),
        image: "assets/visitor_types/allow_serviceman.png",
        onTap: () => _addVisitorLog(Constants.visitorTypeService),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("addCab"),
        image: "assets/visitor_types/allow_cab.png",
        onTap: () => _addVisitorLog(Constants.visitorTypeCab),
      ),
    ];
    final List<HomeItem> community = [
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("helpDesk"),
        subTitle: AppLocalization.instance
            .getLocalizationFor("complaintAndSuggestions"),
        image: "assets/community/image1.png",
        onTap: () => Navigator.pushNamed(context, PageRoutes.complaintsPage),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("noticeBoard"),
        subTitle:
            AppLocalization.instance.getLocalizationFor("societyAnnouncements"),
        image: "assets/community/image2.png",
        onTap: () => Navigator.pushNamed(context, PageRoutes.announcementsPage),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("dueSocietyPayment"),
        subTitle: AppLocalization.instance
            .getLocalizationFor("directPaymentOfSocietyDues"),
        image: "assets/community/image3.png",
        onTap: () =>
            Navigator.pushNamed(context, PageRoutes.paymentRequestsPage),
      ),
      HomeItem(
        title: AppLocalization.instance.getLocalizationFor("bookedAmenities"),
        subTitle: AppLocalization.instance
            .getLocalizationFor("preBookSocietyAmenities"),
        image: "assets/community/image4.png",
        onTap: () =>
            Navigator.pushNamed(context, PageRoutes.amenityAppointmentsPage),
      ),
    ];
    return SafeArea(
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
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
                  AppConfig.appName,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppLocalization.instance.getLocalizationFor("preApproveVisitors"),
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppLocalization.instance
                  .getLocalizationFor("addVisitorDetailsForQuickEntries"),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.hintColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 123,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: visitors.length,
              separatorBuilder: (context, index) => const SizedBox(width: 6),
              itemBuilder: (context, index) => InkWell(
                onTap: visitors[index].onTap,
                child: Container(
                  width: 94,
                  decoration: buildBoxDecoration(context, theme),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          visitors[index].title,
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontSize: 12),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Spacer(),
                            Image.asset(
                              visitors[index].image,
                              width: 55,
                              height: 65,
                              alignment: AlignmentDirectional.bottomEnd,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppLocalization.instance.getLocalizationFor("community"),
              style: theme.textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              AppLocalization.instance
                  .getLocalizationFor("everythingAboutSocietyManagement"),
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.hintColor.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: community.length,
            //separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => InkWell(
              onTap: community[index].onTap,
              child: Container(
                decoration: buildBoxDecoration(context, theme),
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  community[index].title,
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: theme.primaryColor),
                                ),
                                // if (index == 1) const SizedBox(width: 8),
                                // if (index == 1)
                                //   CircleAvatar(
                                //     radius: 8,
                                //     backgroundColor: const Color(0xffe73030),
                                //     child: Center(
                                //       child: Text(
                                //         "2",
                                //         style:
                                //             theme.textTheme.bodySmall?.copyWith(
                                //           height: 1,
                                //           color: theme.scaffoldBackgroundColor,
                                //           fontSize: 10,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              community[index].subTitle!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: theme.hintColor.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                          end: index == 2 ? 0.0 : 18.0),
                      child: Image.asset(
                        community[index].image,
                        alignment: Alignment.bottomCenter,
                        height: 54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context, ThemeData theme) =>
      BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffebf5fb)),
      );

  _addVisitorLog(String visitorType) =>
      Navigator.pushNamed(context, PageRoutes.addVisitorLogPage,
              arguments: visitorType)
          .then((value) {
        if (value != null && value is VisitorLog) {
          widget.bottomTabCallbacks.refreshActivityLog();
          Navigator.pushNamed(context, PageRoutes.gatePassPage,
              arguments: value);
        }
      });
}

class HomeItem {
  String title;
  String? subTitle;
  String image;
  Function()? onTap;

  HomeItem(
      {required this.title, this.subTitle, required this.image, this.onTap});
}
