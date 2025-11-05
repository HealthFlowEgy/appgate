import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/utility/app_settings.dart';

class TncPage extends StatelessWidget {
  const TncPage({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalization.instance
                          .getLocalizationFor("termsNConditions"),
                      style: theme.textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        children: [
          Text(
            AppSettings.terms,
            style: theme.textTheme.labelLarge?.copyWith(
              height: 1.8,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
