import 'package:flutter/material.dart';
import 'package:gateapp_guard/config/localization/app_localization.dart';
import 'package:ndialog/ndialog.dart';

class Loader {
  static bool _isLoaderShowing = false;
  static ProgressDialog? _progressDialog;

  static Widget loadingWidget(
          {required BuildContext context, String? message}) =>
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 260,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
              ),
              Text(
                message != null && message.isNotEmpty
                    ? message
                    : AppLocalization.instance.getLocalizationFor("loading"),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 17),
              ),
            ],
          ),
        ),
      );

  static showLoader(BuildContext context) {
    if (!_isLoaderShowing) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext context) =>
            Center(child: Loader.circularProgressIndicatorPrimary(context)),
      );
      _isLoaderShowing = true;
    }
  }

  static dismissLoader(BuildContext context) {
    if (_isLoaderShowing) {
      Navigator.of(context).pop();
      _isLoaderShowing = false;
    }
  }

  static showProgress(
      BuildContext context, String progressTitleText, String progressBodyText) {
    if (_progressDialog == null) {
      _progressDialog = ProgressDialog(context,
          dismissable: false,
          title: Text(
            progressTitleText,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 17, color: Colors.black),
          ),
          message: Text(
            progressBodyText,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontSize: 14, color: Colors.grey),
          ));
    } else {
      _progressDialog!.setTitle(Text(
        progressTitleText,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontSize: 17, color: Colors.black),
      ));
      _progressDialog!.setMessage(Text(
        progressBodyText,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontSize: 14, color: Colors.grey),
      ));
    }
    _progressDialog!.show();
  }

  static dismissProgress() {
    if (_progressDialog != null) {
      _progressDialog!.dismiss();
      _progressDialog = null;
    }
  }

  static circularProgressIndicatorPrimary(BuildContext context) => Center(
          child: CircularProgressIndicator(
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ));

  static circularProgressIndicatorWhite() => const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ));

  static circularProgressIndicatorDefault() =>
      const Center(child: CircularProgressIndicator());
}
