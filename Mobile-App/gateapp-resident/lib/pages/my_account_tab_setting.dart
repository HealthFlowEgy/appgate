import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/app_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/config/page_routes.dart';
import 'package:gateapp_user/network/remote_repository.dart';
import 'package:gateapp_user/widgets/confirm_dialog.dart';
import 'package:gateapp_user/widgets/loader.dart';

class MyAccountTabSetting extends StatelessWidget {
  const MyAccountTabSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountSettingStateful();
  }
}

class AccountSettingStateful extends StatefulWidget {
  const AccountSettingStateful({super.key});

  @override
  State<AccountSettingStateful> createState() => _AccountSettingStatefulState();
}

class _AccountSettingStatefulState extends State<AccountSettingStateful> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 240,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(
      //     color: Theme.of(context).hintColor.withOpacity(0.3),
      //   ),
      // ),
      child: ListView(
        // mainAxisSize: MainAxisSize.min,
        children: [
          buildOption(
            context,
            Icons.mail,
            const Color(0xff3ec1d2),
            AppLocalization.instance.getLocalizationFor("support"),
            onTap: () => Navigator.pushNamed(context, PageRoutes.supportPage),
          ),
          const SizedBox(height: 14),
          buildOption(
            context,
            Icons.public,
            const Color(0xff53d23e),
            AppLocalization.instance.getLocalizationFor("changeLanguage"),
            onTap: () {
              Navigator.pushNamed(context, PageRoutes.languagePage);
            },
          ),
          const SizedBox(height: 14),
          buildOption(
            context,
            Icons.assignment,
            const Color(0xfff4b93e),
            AppLocalization.instance.getLocalizationFor("termsNConditions"),
            onTap: () => Navigator.pushNamed(context, PageRoutes.tncPage),
          ),
          const SizedBox(height: 14),
          buildOption(
            context,
            Icons.logout,
            const Color(0xffe26141),
            AppLocalization.instance.getLocalizationFor("logout"),
            onTap: () {
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
            },
          ),
          const SizedBox(height: 14),
          buildOption(
            context,
            Icons.delete_forever,
            Colors.red,
            AppLocalization.instance.getLocalizationFor("delete_account"),
            onTap: () {
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
            },
          ),
        ],
      ),
    );
  }

  Widget buildOption(
      BuildContext context, IconData icon, Color color, String title,
      {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).hintColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              // padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: color,
              ),
              child: Icon(
                icon,
                size: 18,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: 15,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _doLogout() {
    BlocProvider.of<AppCubit>(context).logOut();
    Navigator.pop(context);
  }
}
