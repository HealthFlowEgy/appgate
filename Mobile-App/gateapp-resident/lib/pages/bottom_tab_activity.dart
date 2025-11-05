import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/widgets/notification_indicator_icon_widget.dart';
import 'package:gateapp_user/widgets/profile_icon_widget.dart';

import 'activity_tab.dart';

class BottomTabActivity extends StatelessWidget {
  final GlobalKey<ActivityStatefulState> activityTabStatefulKey;
  const BottomTabActivity({super.key, required this.activityTabStatefulKey});

  @override
  Widget build(BuildContext context) =>
      ActivityTabStateful(activityTabKey: activityTabStatefulKey);
}

class ActivityTabStateful extends StatefulWidget {
  final GlobalKey<ActivityStatefulState> activityTabKey;
  const ActivityTabStateful({super.key, required this.activityTabKey});

  @override
  State<ActivityTabStateful> createState() => _ActivityTabStatefulState();
}

class _ActivityTabStatefulState extends State<ActivityTabStateful>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, PageRoutes.notificationsPage),
                  child: const NotificationIndicatorIconWidget(),
                ),
                Expanded(
                  child: Text(
                    AppLocalization.instance.getLocalizationFor("activity"),
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
            Container(
              height: 46,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: theme.hintColor.withOpacity(0.1),
              ),
              child: TabBar(
                labelPadding: EdgeInsets.zero,
                //indicatorWeight: 0.001,
                indicator: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(40),
                ),
                controller: _tabController,
                labelColor: theme.primaryColor,
                tabs: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 500,
                    // decoration: BoxDecoration(
                    //   color: _tabController.index == 0
                    //       ? theme.scaffoldBackgroundColor
                    //       : null,
                    //   borderRadius: BorderRadius.circular(40),
                    // ),
                    child: Tab(
                        text: AppLocalization.instance
                            .getLocalizationFor("today")),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 500,
                    // decoration: BoxDecoration(
                    //   color: _tabController.index == 1
                    //       ? theme.scaffoldBackgroundColor
                    //       : null,
                    //   borderRadius: BorderRadius.circular(40),
                    // ),
                    child: Tab(
                      text: AppLocalization.instance.getLocalizationFor("past"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ActivityTab(
                    isUpcoming: true,
                    activityStatefulKey: widget.activityTabKey,
                  ),
                  const ActivityTab(isUpcoming: false)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
