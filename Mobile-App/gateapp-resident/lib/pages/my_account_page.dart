import 'package:flutter/material.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/models/resident_profile.dart';
import 'package:gateapp_user/utility/buy_this_app.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/cached_image.dart';

import 'my_account_tab_household.dart';
import 'my_account_tab_setting.dart';
import 'social_tab_posts.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});

  @override
  Widget build(BuildContext context) => const MyAccountStateful();
}

class MyAccountStateful extends StatefulWidget {
  const MyAccountStateful({super.key});

  @override
  State<MyAccountStateful> createState() => _MyAccountStatefulState();
}

class _MyAccountStatefulState extends State<MyAccountStateful>
    with TickerProviderStateMixin {
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
      appBar: AppBar(
        actions: [
          if (AppConfig.isDemoMode)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BuyThisApp.button(
                'appsgate',
                'http://bit.ly/cc_flutter_schooltime',
                target: Target.whatsapp,
                color: theme.primaryColor,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<ResidentProfile?>(
            future: LocalDataLayer().getResidentProfileMe(),
            builder: (BuildContext context,
                    AsyncSnapshot<ResidentProfile?> snapshot) =>
                GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, PageRoutes.myProfilePage)
                      .then((value) => setState(() {})),
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.hintColor.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        children: [
                          CachedImage(
                            radius: 25,
                            imageUrl: snapshot.data?.user?.imageUrl,
                            imagePlaceholder: "assets/plc_profile.png",
                            height: 50,
                          ),
                          const SizedBox(width: 28),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.hasData && snapshot.data != null
                                      ? snapshot.data!.user!.name
                                      : 'Setup Profile',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppLocalization.instance
                                      .getLocalizationFor("viewProfile"),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.hintColor.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Icon(
                          //   Icons.qr_code,
                          //   color: theme.hintColor,
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.business,
                            color: theme.hintColor,
                          ),
                          const SizedBox(width: 28),
                          Text(
                            snapshot.hasData && snapshot.data != null
                                ? snapshot.data!.getAddressToShow()
                                : 'Setup Profile',
                            style: theme.textTheme.labelLarge
                                ?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 46,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.hintColor.withOpacity(0.1),
            ),
            child: TabBar(
              labelPadding: EdgeInsets.zero,
              //indicatorWeight: 0.0001,
              indicator: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
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
                  //       ? Theme.of(context).scaffoldBackgroundColor
                  //       : null,
                  //   borderRadius: BorderRadius.circular(40),
                  // ),
                  child: Tab(
                    text: AppLocalization.instance.getLocalizationFor("posts"),
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
                    text: AppLocalization.instance
                        .getLocalizationFor("household"),
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
                    text:
                        AppLocalization.instance.getLocalizationFor("settings"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Flexible(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SocialTabPosts(mine: true),
                MyAccountTabHouseHold(),
                MyAccountTabSetting(),
              ],
            ),
          ),
          if (AppConfig.isDemoMode)
            Container(
              color: theme.scaffoldBackgroundColor,
              child: BuyThisApp.developerRowVerbose(
                backgroundColor: Colors.transparent,
                textColor: theme.primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
