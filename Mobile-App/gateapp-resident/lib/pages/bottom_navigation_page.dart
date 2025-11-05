import 'package:flutter/material.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/utility/app_settings.dart';
import 'package:gateapp_user/utility/buy_this_app.dart';
import 'package:gateapp_user/utility/constants.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/utility/locale_data_layer.dart';
import 'package:gateapp_user/widgets/quick_support_dialog.dart';

import 'activity_tab.dart';
import 'bottom_tab_activity.dart';
import 'bottom_tab_home.dart';
import 'bottom_tab_services.dart';
import 'bottom_tab_social.dart';

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context) => const BottomNavigationStateful();
}

class BottomNavigationStateful extends StatefulWidget {
  const BottomNavigationStateful({super.key});

  @override
  State<BottomNavigationStateful> createState() =>
      _BottomNavigationStatefulState();
}

class _BottomNavigationStatefulState extends State<BottomNavigationStateful>
    implements BottomTabCallbacks {
  int _currentIndex = 0;
  bool _isQuickSupportOpen = false;

  final GlobalKey<ActivityStatefulState> _activityTabKey = GlobalKey();
  final GlobalKey<SocialTabStatefulState> _socialTabKey = GlobalKey();
  final GlobalKey<ServicesTabStatefulState> _servicesTabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkForBuyNow();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvoked: (didPop) {
        if (!didPop) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
          ),
          child: FloatingActionButton(
            onPressed: () => _onFabAction(),
            backgroundColor: const Color(0xff622FBC),
            child: _getFabIcon(),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: 30),
          child: IndexedStack(
            index: _currentIndex,
            children: [
              BottomTabHome(bottomTabCallbacks: this),
              BottomTabActivity(activityTabStatefulKey: _activityTabKey),
              BottomTabSocial(socialTabStatefulKey: _socialTabKey),
              BottomTabServices(servicesTabStatefulKey: _servicesTabKey),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: theme.primaryColor,
          padding: const EdgeInsetsDirectional.only(end: 72),
          child: BottomNavigationBar(
            backgroundColor: theme.primaryColor,
            elevation: 10,
            selectedItemColor: theme.scaffoldBackgroundColor,
            unselectedItemColor: theme.hintColor,
            currentIndex: _currentIndex,
            iconSize: 20,
            selectedLabelStyle:
                theme.textTheme.bodySmall?.copyWith(height: 1.6),
            unselectedLabelStyle:
                theme.textTheme.bodySmall?.copyWith(height: 1.6),
            // showSelectedLabels: false,
            // showUnselectedLabels: false,
            // backgroundColor: theme.primaryColorDark,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon:
                    Image.asset("assets/bottom_icons/ic_home.png", scale: 2.5),
                activeIcon: Image.asset("assets/bottom_icons/ic_homeact.png",
                    scale: 2.5),
                label: AppLocalization.instance.getLocalizationFor("home"),
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/bottom_icons/ic_activity.png",
                    scale: 2.5),
                activeIcon: Image.asset(
                    "assets/bottom_icons/ic_activityact.png",
                    scale: 2.5),
                label: AppLocalization.instance.getLocalizationFor("activity"),
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/bottom_icons/ic_social.png",
                    scale: 2.5),
                activeIcon: Image.asset("assets/bottom_icons/ic_socialact.png",
                    scale: 2.5),
                label: AppLocalization.instance.getLocalizationFor("social"),
              ),
              BottomNavigationBarItem(
                icon: Image.asset("assets/bottom_icons/ic_service.png",
                    scale: 2.5),
                activeIcon: Image.asset("assets/bottom_icons/ic_serviceact.png",
                    scale: 2.5),
                label: AppLocalization.instance.getLocalizationFor("service"),
              ),
            ],
            onTap: (int index) => setState(() => _currentIndex = index),
          ),
        ),
      ),
    );
  }

  Icon _getFabIcon() {
    switch (_currentIndex) {
      case 2:
        return const Icon(Icons.add);
      case 3:
        return const Icon(Icons.search);
      default:
        return _isQuickSupportOpen
            ? const Icon(Icons.close)
            : const Icon(Icons.security);
    }
  }

  void _onFabAction() {
    switch (_currentIndex) {
      case 2:
        if (_socialTabKey.currentState != null) {
          _socialTabKey.currentState!.handleFloatingAction();
        }
        break;
      case 3:
        if (_servicesTabKey.currentState != null) {
          _servicesTabKey.currentState!.handleFloatingAction();
        }
        break;
      default:
        _quickSupport();
        break;
    }
  }

  _quickSupport() {
    setState(() => _isQuickSupportOpen = true);
    showDialog(
      context: context,
      builder: (context) => const QuickSupportDialog(),
    ).then((value) {
      setState(() => _isQuickSupportOpen = false);
      if (value != null && value is String) {
        switch (value) {
          case "support_admin":
            Navigator.pushNamed(
              context,
              PageRoutes.addComplaintAdminPage,
              arguments: Constants.complaintTypeMessageAdmin,
            );
            break;
          case "support_security":
            Navigator.pushNamed(
              context,
              PageRoutes.addComplaintAdminPage,
              arguments: Constants.complaintTypeMessageGuard,
            );
            break;
          case "support_fire":
            Helper.launchURL("tel:${AppSettings.fireAlert}");
            break;
          case "support_lift":
            Helper.launchURL("tel:${AppSettings.liftAlert}");
            break;
          case "support_animal":
            Helper.launchURL("tel:${AppSettings.animalAlert}");
            break;
          case "support_visitor":
            Helper.launchURL("tel:${AppSettings.visitorAlert}");
            break;
        }
      }
    });
  }

  @override
  refreshActivityLog() => _activityTabKey.currentState?.doRefresh();

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

abstract class BottomTabCallbacks {
  refreshActivityLog();
}
