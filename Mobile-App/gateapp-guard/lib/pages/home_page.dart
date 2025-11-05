import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/bloc/app_cubit.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:gateapp_guard/config/page_routes.dart';
import 'package:gateapp_guard/models/guard_profile.dart';
import 'package:gateapp_guard/network/remote_repository.dart';
import 'package:gateapp_guard/utility/buy_this_app.dart';
import 'package:gateapp_guard/utility/locale_data_layer.dart';
import 'package:gateapp_guard/widgets/confirm_dialog.dart';
import 'package:gateapp_guard/widgets/loader.dart';

import 'home_tab_allow_visitor.dart';
import 'home_tab_complaints.dart';
import 'home_tab_visitor_logs.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const HomeStateful();
}

class HomeStateful extends StatefulWidget {
  const HomeStateful({super.key});

  @override
  State<HomeStateful> createState() => _HomeStatefulState();
}

class _HomeStatefulState extends State<HomeStateful>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _checkForBuyNow();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        title: FutureBuilder<GuardProfile?>(
          future: LocalDataLayer().getGuardProfileMe(),
          builder:
              (BuildContext context, AsyncSnapshot<GuardProfile?> snapshot) =>
                  Text(
            snapshot.data?.project?.address ?? "",
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.scaffoldBackgroundColor),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          //indicatorColor: Colors.transparent,
          indicator: const BoxDecoration(
            color: Colors.transparent,

            //borderRadius: BorderRadius.circular(40),
          ),
          //labelStyle: theme.textTheme.bodySmall,
          //unselectedLabelStyle: theme.textTheme.bodySmall,
          tabs: [
            Tab(
              icon: const Icon(
                Icons.home,
                size: 40,
              ),
              text: AppLocalization.instance.getLocalizationFor("home"),
            ),
            Tab(
              icon: const Icon(
                Icons.swap_vert_circle,
                size: 40,
              ),
              text: AppLocalization.instance.getLocalizationFor("inOut"),
            ),
            Tab(
              icon: const Icon(
                Icons.mail,
                size: 40,
              ),
              text: AppLocalization.instance.getLocalizationFor("messages"),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => _dialogMore(),
            ).then((value) {
              switch (value) {
                case "nav_profile":
                  Navigator.pushNamed(context, PageRoutes.profilePage);
                  break;
                case "nav_language":
                  Navigator.pushNamed(context, PageRoutes.languagePage);
                  break;
                case "nav_logout":
                  ConfirmDialog.showConfirmation(
                          context,
                          Text(AppLocalization.instance
                              .getLocalizationFor("logout")),
                          Text(AppLocalization.instance
                              .getLocalizationFor("logout_msg")),
                          AppLocalization.instance.getLocalizationFor("no"),
                          AppLocalization.instance.getLocalizationFor("yes"))
                      .then((value) {
                    if (value != null && value == true) {
                      _doLogout();
                    }
                  });
                  break;
                case "nav_delete_account":
                  ConfirmDialog.showConfirmation(
                          context,
                          Text(AppLocalization.instance
                              .getLocalizationFor("delete_account")),
                          Text(AppLocalization.instance
                              .getLocalizationFor("delete_account_msg")),
                          AppLocalization.instance.getLocalizationFor("no"),
                          AppLocalization.instance.getLocalizationFor("yes"))
                      .then((value) {
                    if (value != null && value == true) {
                      Loader.showLoader(context);
                      RemoteRepository().deleteUser().then((value) {
                        Loader.dismissLoader(context);
                        _doLogout();
                      });
                    }
                  });
                  break;
              }
            }),
            icon: Icon(
              Icons.more_vert,
              color: theme.scaffoldBackgroundColor,
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeTabAllowVisitor(),
          HomeTabVisitorLogs(),
          HomeTabComplaints(),
        ],
      ),
    );
  }

  Dialog _dialogMore() => Dialog(
        alignment: AlignmentDirectional.topEnd,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context, "nav_profile"),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text(
                    AppLocalization.instance.getLocalizationFor("myProfile"),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context, "nav_language"),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text(
                    AppLocalization.instance
                        .getLocalizationFor("changeLanguage"),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context, "nav_logout"),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text(
                    AppLocalization.instance.getLocalizationFor("logout"),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => Navigator.pop(context, "nav_delete_account"),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: Text(
                    AppLocalization.instance
                        .getLocalizationFor("delete_account"),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 18),
                  ),
                ),
              ),
              if (AppConfig.isDemoMode) const SizedBox(height: 12),
              if (AppConfig.isDemoMode)
                BuyThisApp.button(
                  'appsgate',
                  'http://bit.ly/cc_flutter_schooltime',
                  target: Target.whatsapp,
                  color: Theme.of(context).primaryColor,
                ),
            ],
          ),
        ),
      );

  _doLogout() => BlocProvider.of<AppCubit>(context).logOut();

  _checkForBuyNow() async {
    if (!(await LocalDataLayer().isBuyThisAppPromted()) &&
        AppConfig.isDemoMode) {
      Future.delayed(const Duration(seconds: 10), () async {
        if (mounted) {
          BuyThisApp.showSubscribeDialog(context);
          await LocalDataLayer().setBuyThisAppPromted();
        }
      });
    }
  }
}
