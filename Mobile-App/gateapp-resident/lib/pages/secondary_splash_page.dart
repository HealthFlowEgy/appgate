import 'package:flutter/material.dart';
import 'package:gateapp_user/widgets/loader.dart';

class SecondarySplashPage extends StatelessWidget {
  const SecondarySplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     fit: BoxFit.fill,
          //     image: AssetImage("assets/bg.png"),
          //   ),
          // ),
          child: Loader.circularProgressIndicatorPrimary(context),
        ),
      );
}
