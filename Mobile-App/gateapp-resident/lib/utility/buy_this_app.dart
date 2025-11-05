// ignore_for_file: must_be_immutable
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gateapp_user/network/remote_repository.dart';

import 'helper.dart';

///the main class of buy this app package
class BuyThisApp {
  ///opens subscribe dialog for the user to subscribe to us
  ///SubscribeDialog is the Dialog widget
  ///BuildContext is necessary
  static Future showSubscribeDialog(
    BuildContext context, {
    String subscribing = "Subscribing",
    String subscribed = "Subscribed",
    String emailInvalid = "Email Invalid",
    String somethingWentWrong = "Something Went Wrong",
    String stayInTouch = "Stay In Touch",
    String stayConnectedForFuture = "Stay connected for future",
    String updatesAndNewProducts = "updates and new products",
    String enterYourEmailAddress = "Enter your email address",
    String subscribeNow = "Subscribe Now",
  }) =>
      showDialog(
        context: context,
        builder: (context) => SubscribeDialog(
          subscribing: subscribing,
          subscribed: subscribed,
          emailInvalid: emailInvalid,
          somethingWentWrong: somethingWentWrong,
          stayInTouch: stayInTouch,
          stayConnectedForFuture: stayConnectedForFuture,
          updatesAndNewProducts: updatesAndNewProducts,
          enterYourEmailAddress: enterYourEmailAddress,
          subscribeNow: subscribeNow,
        ),
      );

  ///buyThisAppButton will create the button on the screen which will be of fixed size
  ///color parameter can be passed to give the color to the button
  ///default value of color is Colors.red
  ///appName is the name of the current app
  ///app name is also necessary
  ///target is used for redirection
  ///default value of target is Target.Both
  ///ButThisAppButton is the button widget
  static Widget button(String appName, String codeCanyonUrl,
          {Color color = Colors.red,
          Target target = Target.both,
          double height = 48,
          String source = "template_flutter",
          String buyThisAppText = "Buy this app",
          String buyThisText = "Buy this",
          String templateNowText = "template now",
          String templateOnlyMsgText =
              "Flutter template only, no backend integrated",
          String getItOnText = "Get it on",
          String buyThisAppWithText = "Buy this app with",
          String completeBackendText = "Complete Backend",
          String fullAppMsgText = "Full app solution with complete backend.",
          String messageOnText = "Message on"}) =>
      BuyThisAppButton(
          appName: appName,
          codeCanyonUrl: codeCanyonUrl,
          color: color,
          target: target,
          height: height,
          source: source,
          buyThisAppText: buyThisAppText,
          buyThisText: buyThisText,
          templateNowText: templateNowText,
          templateOnlyMsgText: templateOnlyMsgText,
          getItOnText: getItOnText,
          buyThisAppWithText: buyThisAppWithText,
          completeBackendText: completeBackendText,
          fullAppMsgText: fullAppMsgText,
          messageOnText: messageOnText);

  static Widget buttonCustom(BuildContext context, Widget widget,
          String appName, String codeCanyonUrl,
          {Target target = Target.both,
          String source = "template_flutter",
          String buyThisAppText = "Buy this app",
          String buyThisText = "Buy this",
          String templateNowText = "template now",
          String templateOnlyMsgText =
              "Flutter template only, no backend integrated",
          String getItOnText = "Get it on",
          String buyThisAppWithText = "Buy this app with",
          String completeBackendText = "Complete Backend",
          String fullAppMsgText = "Full app solution with complete backend.",
          String messageOnText = "Message on"}) =>
      BuyThisAppCustomButton(
          widget: widget,
          appName: appName,
          codeCanyonUrl: codeCanyonUrl,
          target: target,
          source: source,
          buyThisAppText: buyThisAppText,
          buyThisText: buyThisText,
          templateNowText: templateNowText,
          templateOnlyMsgText: templateOnlyMsgText,
          getItOnText: getItOnText,
          buyThisAppWithText: buyThisAppWithText,
          completeBackendText: completeBackendText,
          fullAppMsgText: fullAppMsgText,
          messageOnText: messageOnText);

  static Widget developerRow(
          {required Color backgroundColor,
          required Color textColor,
          String? developedByText}) =>
      BuyThisApp.developerRowOpus(
          backgroundColor: backgroundColor,
          textColor: textColor,
          developedByText: developedByText);

  static Widget developerRowOpus(
          {required Color backgroundColor,
          required Color textColor,
          String? developedByText}) =>
      DeveloperRow.opus(
          backgroundColor: backgroundColor,
          textColor: textColor,
          developedByText: developedByText);

  static Widget developerRowVerbose(
          {required Color backgroundColor,
          required Color textColor,
          String? developedByText}) =>
      DeveloperRow.verbose(
          backgroundColor: backgroundColor,
          textColor: textColor,
          developedByText: developedByText);

  static Widget developerRowOpusDark(
          {required Color backgroundColor,
          required Color textColor,
          String? developedByText}) =>
      DeveloperRow.opusDark(
          backgroundColor: backgroundColor,
          textColor: textColor,
          developedByText: developedByText);

  static Widget developerRowVerboseDark(
          {required Color backgroundColor,
          required Color textColor,
          String? developedByText}) =>
      DeveloperRow.verboseDark(
          backgroundColor: backgroundColor,
          textColor: textColor,
          developedByText: developedByText);
}

enum Target {
  codecanyon,
  both,
  whatsapp,
}

class SubscribeDialog extends StatelessWidget {
  final String? subscribing;
  final String? subscribed;
  final String? emailInvalid;
  final String? somethingWentWrong;
  final String? stayInTouch;
  final String? stayConnectedForFuture;
  final String? updatesAndNewProducts;
  final String? enterYourEmailAddress;
  final String? subscribeNow;
  final TextEditingController _emailController = TextEditingController();
  SubscribeDialog(
      {Key? key,
      this.subscribing,
      this.subscribed,
      this.emailInvalid,
      this.somethingWentWrong,
      this.stayInTouch,
      this.stayConnectedForFuture,
      this.updatesAndNewProducts,
      this.enterYourEmailAddress,
      this.subscribeNow})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 120, 20, 24),
                margin: const EdgeInsets.only(top: 80),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      stayInTouch ?? "Stay in touch",
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${stayConnectedForFuture ?? "Stay connected for future"}\n${updatesAndNewProducts ?? "updates and new products"}",
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8)),
                        hintText:
                            enterYourEmailAddress ?? "Enter your email address",
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        final RegExp emailPattern = RegExp(
                            // ignore: unnecessary_string_escapes
                            '^[a-zA-Z0-9.!#\$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\$');
                        if (emailPattern.hasMatch(_emailController.text)) {
                          Fluttertoast.showToast(msg: "Subscribing..");
                          try {
                            await RemoteRepository().postUrl(
                                "https://dashboard.vtlabs.dev/api/subscribe", {
                              "email": _emailController.text,
                              "source": "opus_subscribe_page"
                            });
                            Fluttertoast.showToast(msg: "Subscribed");
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          } catch (e) {
                            if (kDebugMode) {
                              print("postUrl: $e");
                            }
                          }
                        } else {
                          Fluttertoast.showToast(msg: "Invalid email.");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffF07492),
                                  Color(0xffEF5776),
                                ]),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color(0xffF07492),
                                  offset: Offset(0, 4),
                                  blurRadius: 5)
                            ]),
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          subscribeNow ?? "Subscribe Now",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              child: Image.asset(
                "assets/popup_img_head.png",
                height: 220,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.white,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      );
}

class BuyThisAppButton extends StatelessWidget {
  final String appName;
  final String codeCanyonUrl;
  final Color color;
  final Target target;
  final double height;
  final String source;
  final String buyThisAppText;
  final String buyThisText;
  final String templateNowText;
  final String templateOnlyMsgText;
  final String getItOnText;
  final String buyThisAppWithText;
  final String completeBackendText;
  final String fullAppMsgText;
  final String messageOnText;

  const BuyThisAppButton(
      {super.key,
      required this.appName,
      required this.codeCanyonUrl,
      required this.color,
      required this.target,
      required this.height,
      required this.source,
      this.buyThisAppText = "Buy this app",
      this.buyThisText = "Buy this",
      this.templateNowText = "template now",
      this.templateOnlyMsgText = "Flutter template only, no backend integrated",
      this.getItOnText = "Get it on",
      this.buyThisAppWithText = "Buy this app with",
      this.completeBackendText = "Complete Backend",
      this.fullAppMsgText = "Full app solution with complete backend.",
      this.messageOnText = "Message on"});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      onPressed: () {
        switch (target) {
          case Target.codecanyon:
            Helper.launchURL(codeCanyonUrl);
            break;
          case Target.whatsapp:
            Helper.launchURL(
                'https://dashboard.vtlabs.dev/whatsapp.php?product_name=$appName&source=$source&redirect=1');
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyThisAppPage(
                    appName: appName.replaceAll(' ', '').toLowerCase(),
                    codeCanyonUrl: codeCanyonUrl,
                    source: source,
                    buyThisText: buyThisText,
                    templateNowText: templateNowText,
                    templateOnlyMsgText: templateOnlyMsgText,
                    getItOnText: getItOnText,
                    buyThisAppWithText: buyThisAppWithText,
                    completeBackendText: completeBackendText,
                    fullAppMsgText: fullAppMsgText,
                    messageOnText: messageOnText),
              ),
            );
            break;
        }
      },
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Text(
        buyThisAppText,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class BuyThisAppCustomButton extends StatelessWidget {
  final Widget widget;
  final String appName;
  final String codeCanyonUrl;
  final Target target;
  final String source;
  final String buyThisAppText;
  final String buyThisText;
  final String templateNowText;
  final String templateOnlyMsgText;
  final String getItOnText;
  final String buyThisAppWithText;
  final String completeBackendText;
  final String fullAppMsgText;
  final String messageOnText;

  const BuyThisAppCustomButton(
      {super.key,
      required this.widget,
      required this.appName,
      required this.codeCanyonUrl,
      required this.target,
      required this.source,
      this.buyThisAppText = "Buy this app",
      this.buyThisText = "Buy this",
      this.templateNowText = "template now",
      this.templateOnlyMsgText = "Flutter template only, no backend integrated",
      this.getItOnText = "Get it on",
      this.buyThisAppWithText = "Buy this app with",
      this.completeBackendText = "Complete Backend",
      this.fullAppMsgText = "Full app solution with complete backend.",
      this.messageOnText = "Message on"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (target) {
          case Target.codecanyon:
            Helper.launchURL(codeCanyonUrl);
            break;
          case Target.whatsapp:
            Helper.launchURL(
              'https://dashboard.vtlabs.dev/whatsapp.php?product_name=$appName&source=$source&redirect=1',
            );
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuyThisAppPage(
                    appName: appName.replaceAll(' ', '').toLowerCase(),
                    codeCanyonUrl: codeCanyonUrl,
                    source: source,
                    buyThisText: buyThisText,
                    templateNowText: templateNowText,
                    templateOnlyMsgText: templateOnlyMsgText,
                    getItOnText: getItOnText,
                    buyThisAppWithText: buyThisAppWithText,
                    completeBackendText: completeBackendText,
                    fullAppMsgText: fullAppMsgText,
                    messageOnText: messageOnText),
              ),
            );
            break;
        }
      },
      child: widget,
    );
  }
}

class BuyThisAppPage extends StatelessWidget {
  final String appName;
  final String codeCanyonUrl;
  final String source;
  final String? buyThisText;
  final String? templateNowText;
  final String? templateOnlyMsgText;
  final String? getItOnText;
  final String? buyThisAppWithText;
  final String? completeBackendText;
  final String? fullAppMsgText;
  final String? messageOnText;

  const BuyThisAppPage({
    super.key,
    required this.appName,
    required this.codeCanyonUrl,
    required this.source,
    this.buyThisText,
    this.templateNowText,
    this.templateOnlyMsgText,
    this.getItOnText,
    this.buyThisAppWithText,
    this.completeBackendText,
    this.fullAppMsgText,
    this.messageOnText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff549A13),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: const Color(0xff549A13),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Text(
                    "${buyThisText ?? "Buy this"}\n${templateNowText ?? "template now"}",
                    style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    templateOnlyMsgText ??
                        "Flutter template only, no backend integrated",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Helper.launchURL(codeCanyonUrl),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(8))),
                    icon: Image.asset(
                      "assets/ic_codecanyon.png",
                      height: 40,
                    ),
                    label: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: "${getItOnText ?? "Get it on"} "),
                        const TextSpan(
                            text: "CodeCanyon",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      style: const TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Text(
                    "${buyThisAppWithText ?? "Buy this app with"}\n${completeBackendText ?? "Complete Backend"}",
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const Spacer(),
                  Text(
                    fullAppMsgText ??
                        "Full app solution with complete backend.",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Helper.launchURL(
                        'https://dashboard.vtlabs.dev/whatsapp.php?product_name=$appName&source=$source&redirect=1'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff549A13)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(8))),
                    icon: Image.asset(
                      "assets/ic_whatsapp.png",
                      height: 40,
                    ),
                    label: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: "${messageOnText ?? "Message on"} "),
                        const TextSpan(
                            text: "WhatsApp",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                      style: const TextStyle(fontSize: 16, letterSpacing: 1),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeveloperRow extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final String? developedByText;
  String? _imageSrc;
  String? _developerSrc;

  DeveloperRow(
      {Key? key,
      required this.backgroundColor,
      required this.textColor,
      this.developedByText})
      : super(key: key) {
    _developerSrc ??= "https://opuslab.works/";
    _imageSrc ??= "assets/logo_opus.png";
  }

  static opus(
      {required Color backgroundColor,
      required Color textColor,
      String? developedByText}) {
    DeveloperRow developerRow = DeveloperRow(
        backgroundColor: backgroundColor,
        textColor: textColor,
        developedByText: developedByText);
    developerRow.developer = "https://opuslab.works/";
    developerRow.imageSrc = "assets/logo_opus.png";
    return developerRow;
  }

  static opusDark(
      {required Color backgroundColor,
      required Color textColor,
      String? developedByText}) {
    DeveloperRow developerRow = DeveloperRow(
        backgroundColor: backgroundColor,
        textColor: textColor,
        developedByText: developedByText);
    developerRow.developer = "https://opuslab.works/";
    developerRow.imageSrc = "assets/logo_opus_white.png";
    return developerRow;
  }

  static verbose(
      {required Color backgroundColor,
      required Color textColor,
      String? developedByText}) {
    DeveloperRow developerRow = DeveloperRow(
        backgroundColor: backgroundColor,
        textColor: textColor,
        developedByText: developedByText);
    developerRow.developer = "https://verbosetechlabs.com/";
    developerRow.imageSrc = "assets/logo_verbose.png";
    return developerRow;
  }

  static verboseDark(
      {required Color backgroundColor,
      required Color textColor,
      String? developedByText}) {
    DeveloperRow developerRow = DeveloperRow(
        backgroundColor: backgroundColor,
        textColor: textColor,
        developedByText: developedByText);
    developerRow.developer = "https://verbosetechlabs.com/";
    developerRow.imageSrc = "assets/logo_verbose_white.png";
    return developerRow;
  }

  set imageSrc(String imageSrc) => _imageSrc = imageSrc;

  set developer(String developer) => _developerSrc = developer;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Helper.launchURL(_developerSrc!),
        child: Container(
          height: 55,
          color: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                developedByText ?? "Developed By",
                style: TextStyle(fontSize: 18, color: textColor),
              ),
              const Spacer(),
              Expanded(
                flex: 5,
                child: Image.asset(_imageSrc!
                    // width: 160,
                    ),
              )
            ],
          ),
        ),
      );
}
