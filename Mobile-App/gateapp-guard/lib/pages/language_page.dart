import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_guard/bloc/app_cubit.dart';
import 'package:gateapp_guard/bloc/language_cubit.dart';
import 'package:gateapp_guard/config/app_config.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';

class LanguagePage extends StatefulWidget {
  final bool fromRoot;
  const LanguagePage({
    super.key,
    this.fromRoot = false,
  });

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? _selectedLanguage;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: Text(
      //     locale.chooseLanguage,
      //     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
      //           fontSize: 15,
      //           color: Colors.black,
      //         ),
      //   ),
      // ),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalization.instance
                          .getLocalizationFor("selectLanguage"),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppLocalization.instance
                          .getLocalizationFor("selectPreferredAppLanguage"),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadedSlideAnimation(
          fadeDuration: const Duration(milliseconds: 300),
          slideDuration: const Duration(milliseconds: 300),
          beginOffset: const Offset(0, 0.3),
          endOffset: const Offset(0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: BlocBuilder<LanguageCubit, Locale>(
                  builder: (context, currentLocale) {
                    _selectedLanguage ??= currentLocale.languageCode;
                    return ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: 100,
                        top: 30,
                        left: 24,
                        right: 24,
                      ),
                      physics: const BouncingScrollPhysics(),
                      itemCount: AppConfig.languagesSupported.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) => Container(
                        // padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                          ),
                        ),
                        // margin: const EdgeInsets.symmetric(
                        //   horizontal: 20.0,
                        //   vertical: 10.0,
                        // ),
                        child: RadioListTile(
                          title: Text(
                            AppConfig
                                .languagesSupported[AppConfig
                                    .languagesSupported.keys
                                    .elementAt(index)]!
                                .name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          value: AppConfig.languagesSupported.keys
                              .elementAt(index),
                          groupValue: _selectedLanguage,
                          onChanged: (dynamic value) => setState(
                              () => _selectedLanguage = (value as String)),
                          activeColor: theme.primaryColor,
                          fillColor:
                              MaterialStateProperty.all(theme.primaryColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          BlocProvider.of<LanguageCubit>(context)
              .setCurrentLanguage(_selectedLanguage!, true);
          if (widget.fromRoot) {
            BlocProvider.of<AppCubit>(context).initApp();
          } else {
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
