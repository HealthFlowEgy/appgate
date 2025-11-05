// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gateapp_user/config/app_config.dart';
import 'package:gateapp_user/config/localization/app_localization.dart';
import 'package:gateapp_user/models/visitor_log.dart';
// import 'package:gateapp_user/utility/permissions_helper.dart';
// import 'package:gateapp_user/widgets/confirm_dialog.dart';
import 'package:gateapp_user/widgets/ticket_painter.dart';
import 'package:gateapp_user/widgets/toaster.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class GatePassPage extends StatelessWidget {
  const GatePassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GatePassStateful(
        visitorLog: ModalRoute.of(context)!.settings.arguments as VisitorLog);
  }
}

class GatePassStateful extends StatefulWidget {
  final VisitorLog visitorLog;
  const GatePassStateful({
    super.key,
    required this.visitorLog,
  });

  @override
  State<GatePassStateful> createState() => _GatePassStatefulState();
}

class _GatePassStatefulState extends State<GatePassStateful> {
  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.maybePop(context),
          icon: Icon(
            Icons.close,
            color: theme.scaffoldBackgroundColor,
          ),
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/watermark.png',
          color: theme.scaffoldBackgroundColor.withOpacity(0.5),
          height: 20,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: IconButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              icon: Icon(
                Icons.home,
                color: theme.scaffoldBackgroundColor,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          WidgetsToImage(
            controller: widgetsToImageController,
            child: CustomPaint(
              painter: TicketPainter(
                borderColor: Colors.black,
                bgColor: theme.scaffoldBackgroundColor,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    AppConfig.appName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: QrImageView(
                      data: widget.visitorLog.code,
                      version: QrVersions.auto,
                      size: 180,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/scratch_overlay.png',
                          width: 180,
                        ),
                        Text(
                          widget.visitorLog.code,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    AppLocalization.instance.getLocalizationFor("showQrCode"),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 90),
                  Text(
                    widget.visitorLog.name ??
                        widget.visitorLog.vehicle_number ??
                        "",
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style:
                          theme.textTheme.titleMedium?.copyWith(fontSize: 14),
                      children: [
                        TextSpan(
                          // text: AppLocalization.instance.getLocalizationFor(
                          //     widget.visitorLog.type == Constants.visitorTypeCab
                          //         ? "cabAt"
                          //         : "guestAt"),
                          text:
                              AppLocalization.instance.getLocalizationFor("at"),
                          style: TextStyle(color: theme.hintColor),
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(
                          text: widget.visitorLog.flat?.title ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 50,
            //padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xff6333bb),
            ),
            child: MaterialButton(
              onPressed: () => _onShare(),
              child: buildRow(theme, Icons.share,
                  AppLocalization.instance.getLocalizationFor("share")),
            ),
            //  Row(
            //     children: [
            //       Expanded(
            //         child: MaterialButton(
            //           onPressed: () => _checkPermissionsAndPerform("share"),
            //           child: buildRow(
            //               theme,
            //               Icons.share,
            //               AppLocalization.instance
            //                   .getLocalizationFor("share")),
            //         ),
            //       ),
            //       VerticalDivider(
            //           color:
            //               theme.scaffoldBackgroundColor.withOpacity(0.5)),
            //       Expanded(
            //         child: MaterialButton(
            //           onPressed: () =>
            //               _checkPermissionsAndPerform("download"),
            //           child: buildRow(
            //               theme,
            //               Icons.download_rounded,
            //               AppLocalization.instance
            //                   .getLocalizationFor("download")),
            //         ),
            //       ),
            //     ],
            //   ),
          ),
        ],
      ),
    );
  }

  Row buildRow(ThemeData theme, IconData icon, String title) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: theme.scaffoldBackgroundColor,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontSize: 15, color: theme.scaffoldBackgroundColor),
          ),
        ],
      );

  // ignore: unused_element
  _checkPermissionsAndPerform(String action) async {
    if (action == "download") {
      _onDownload();
    } else {
      _onShare();
    }

    // bool permissionStatus =
    //     await PermissionsHelper.permissionIsGrantedStorage();
    // if (permissionStatus) {
    //   if (action == "download") {
    //     _onDownload();
    //   } else {
    //     _onShare();
    //   }
    // } else if (!PermissionsHelper.askedOncePermissionStorage) {
    //   bool? yesNo = await ConfirmDialog.showConfirmation(
    //     context,
    //     Text(AppLocalization.instance.getLocalizationFor("storage")),
    //     Text(AppLocalization.instance.getLocalizationFor("storage_msg")),
    //     AppLocalization.instance.getLocalizationFor("cancel"),
    //     AppLocalization.instance.getLocalizationFor("okay"),
    //   );
    //   if (yesNo ?? false) {
    //     await PermissionsHelper.permissionGrantStorage();
    //     PermissionsHelper.askedOncePermissionStorage = true;
    //     _checkPermissionsAndPerform(action);
    //   }
    // } else {
    //   Toaster.showToastCenter(
    //       AppLocalization.instance.getLocalizationFor("permissions_denied"));
    // }
  }

  _onDownload() async {
    Uint8List? bytes = await widgetsToImageController.capture();

    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getDownloadsDirectory())?.absolute.path;
    }
    if (externalStorageDirPath != null) {
      externalStorageDirPath += "/gatepass/${widget.visitorLog.id}.png";
      final savedDir = File(externalStorageDirPath);
      final hasExisted = savedDir.existsSync();
      try {
        if (hasExisted) {
          savedDir.deleteSync(recursive: true);
        }
        savedDir.createSync(recursive: true);
        savedDir.writeAsBytes(bytes!.buffer.asUint8List());
        Toaster.showToastCenter(
            AppLocalization.instance.getLocalizationFor("saved"));
      } catch (e) {
        if (kDebugMode) {
          print("_download: $e");
        }
        Toaster.showToastCenter(
            AppLocalization.instance.getLocalizationFor("something_wrong"));
      }
    } else {
      Toaster.showToastCenter(
          AppLocalization.instance.getLocalizationFor("something_wrong"));
    }
  }

  _onShare() {
    widgetsToImageController.capture().then((bytes) => Share.file(
        AppLocalization.instance.getLocalizationFor("gatePass"),
        "gatepass${widget.visitorLog.id}.png",
        bytes!.buffer.asUint8List(),
        'image/png',
        text: widget.visitorLog.code));
  }
}
