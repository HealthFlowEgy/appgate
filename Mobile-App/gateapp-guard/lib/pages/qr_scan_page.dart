import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) => const QrScanStateful();
}

class QrScanStateful extends StatefulWidget {
  const QrScanStateful({super.key});

  @override
  State<QrScanStateful> createState() => _QrScanStatefulState();
}

class _QrScanStatefulState extends State<QrScanStateful> {
  Barcode? result;
  QRViewController? controller;
  StreamSubscription<Barcode>? streamSubscription;
  bool _flashEnabled = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildQrView(context),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 48,
                width: 48,
                margin: const EdgeInsetsDirectional.only(
                  top: 24,
                  end: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black38,
                  border: Border.all(
                    color: Theme.of(context).hintColor.withOpacity(0.3),
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    _flashEnabled ? Icons.flash_off : Icons.flash_on,
                    color: Colors.white,
                  ),
                  onPressed: () => controller?.toggleFlash().then((value) =>
                      setState(() => _flashEnabled = !_flashEnabled)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 48,
                width: 48,
                margin: const EdgeInsetsDirectional.only(
                  top: 24,
                  start: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.black38,
                  border: Border.all(
                    color: Theme.of(context).hintColor.withOpacity(0.3),
                  ),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    streamSubscription ??= controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && scanData.code!.isNotEmpty) {
        streamSubscription?.cancel();
        Navigator.pop(context, scanData.code);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (kDebugMode) {
      print('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    }
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
