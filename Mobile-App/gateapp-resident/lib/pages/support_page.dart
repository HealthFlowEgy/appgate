import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gateapp_user/bloc/fetcher_cubit.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/utility/helper.dart';
import 'package:gateapp_user/widgets/custom_button.dart';
import 'package:gateapp_user/widgets/entry_field.dart';
import 'package:gateapp_user/widgets/loader.dart';
import 'package:gateapp_user/widgets/toaster.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => FetcherCubit(),
        child: const SupportStateful(),
      );
}

class SupportStateful extends StatefulWidget {
  const SupportStateful({super.key});

  @override
  State<SupportStateful> createState() => _SupportStatefulState();
}

class _SupportStatefulState extends State<SupportStateful> {
  final TextEditingController _supportController = TextEditingController();
  @override
  void dispose() {
    _supportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<FetcherCubit, FetcherState>(
      listener: (context, state) {
        if (state is SupportLoading) {
          Loader.showLoader(context);
        } else {
          Loader.dismissLoader(context);
        }

        if (state is SupportLoaded) {
          Toaster.showToastTop(AppLocalization.instance
              .getLocalizationFor("support_has_been_submitted"));
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
                            .getLocalizationFor("getSupport"),
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppLocalization.instance
                            .getLocalizationFor("askOrSuggest"),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.hintColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 40),
          children: [
            // EntryField(
            //   label: '',
            //   hintText:
            //       AppLocalization.instance.getLocalizationFor("enterTopic"),
            // ),
            // const SizedBox(height: 30),
            EntryField(
              label: '',
              controller: _supportController,
              hintText: AppLocalization.instance
                  .getLocalizationFor("enterYourMessage"),
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            CustomButton(
              title:
                  AppLocalization.instance.getLocalizationFor("submitMessage"),
              onTap: () {
                if (_supportController.text.trim().length < 10 ||
                    _supportController.text.trim().length > 140) {
                  Toaster.showToastCenter(
                      context.getLocalizationFor("invalid_length_message"));
                } else {
                  Helper.closeKeyboard(context);
                  BlocProvider.of<FetcherCubit>(context)
                      .initSupportSubmit(_supportController.text.trim());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
