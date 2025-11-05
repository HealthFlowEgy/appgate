import 'package:flutter/material.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';

class NewMessagePopupScreen extends StatelessWidget {
  const NewMessagePopupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 7),
          Image.asset(
            'assets/watermark.png',
            height: 20,
            color: Theme.of(context).hintColor,
          ),
          const Spacer(flex: 7),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Image.asset('assets/plc_profile.png'),
            ),
          ),
          const Spacer(flex: 5),
          Text(
            'Bruno Stevenson',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'A 103',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 6),
          Text(
            AppLocalization.instance.getLocalizationFor("callingYou"),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).hintColor,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xff2ba41e),
                      child: Icon(Icons.call,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      AppLocalization.instance.getLocalizationFor("accept"),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 100),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xffc62729),
                      child: Icon(Icons.close,
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      AppLocalization.instance.getLocalizationFor("deny"),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Theme.of(context).hintColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(flex: 9),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
