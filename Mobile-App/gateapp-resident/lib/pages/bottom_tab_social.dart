import 'package:flutter/material.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/media_data.dart';
import 'package:gateapp_user/widgets/notification_indicator_icon_widget.dart';
import 'package:gateapp_user/widgets/profile_icon_widget.dart';

import 'social_tab_chats.dart';
import 'social_tab_posts.dart';
import 'social_tab_residents.dart';

class BottomTabSocial extends StatelessWidget {
  final Key? socialTabStatefulKey;
  const BottomTabSocial({super.key, this.socialTabStatefulKey});

  @override
  Widget build(BuildContext context) =>
      SocialTabStateful(key: socialTabStatefulKey);
}

class SocialTabStateful extends StatefulWidget {
  const SocialTabStateful({super.key});

  @override
  State<SocialTabStateful> createState() => SocialTabStatefulState();
}

class SocialTabStatefulState extends State<SocialTabStateful>
    with TickerProviderStateMixin {
  final GlobalKey<PostsStatefulState> _postsTabKey = GlobalKey();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
                      text:
                          AppLocalization.instance.getLocalizationFor("posts"),
                    ),
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
                      text:
                          AppLocalization.instance.getLocalizationFor("chats"),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 500,
                    // decoration: BoxDecoration(
                    //   color: _tabController.index == 2
                    //       ? theme.scaffoldBackgroundColor
                    //       : null,
                    //   borderRadius: BorderRadius.circular(40),
                    // ),
                    child: Tab(
                      text: AppLocalization.instance
                          .getLocalizationFor("residents"),
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
                  SocialTabPosts(
                    mine: false,
                    postsTabStatefulKey: _postsTabKey,
                  ),
                  const SocialTabChats(),
                  const SocialTabResidents(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handleFloatingAction() {
    if (_tabController.index == 0) {
      Navigator.pushNamed(context, PageRoutes.addPostPage).then((value) {
        if (value != null &&
            value is MediaData &&
            _postsTabKey.currentState != null) {
          _postsTabKey.currentState!.addInList(value);
        }
      });
    } else if (_tabController.index == 1) {
      _tabController.animateTo(2);
    }
  }
}
