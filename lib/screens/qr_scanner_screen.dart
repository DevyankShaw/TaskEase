import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/providers.dart';
import '../utilities/utilities.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String? _deviceToken;
  String? _receiverDeviceToken;
  late Stream<String> _tokenStream;

  void setToken(String? token) {
    debugPrint('Mobile Device Token: $token');
    setState(() {
      _deviceToken = token;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: MobileScanner(
            fit: BoxFit.contain,
            onDetect: (capture) async {
              final data = capture.barcodes.first.rawValue ?? '';

              if (_receiverDeviceToken != null &&
                  _receiverDeviceToken == data) {
                return;
              }

              _receiverDeviceToken = data;

              debugPrint('Receiver Device Token - $_receiverDeviceToken');

              final userToken =
                  await context.read<AuthProvider>().generateJWT();

              debugPrint('User Token - $userToken');

              context.pop();

              // await sendMessage(scannedDeviceToken: receiverDeviceToken);
              // context.pop();
            },
          ),
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    try {
      if (_receiverDeviceToken?.isEmpty ?? true) {
        debugPrint('Something went wrong on getting receiver/web device token');
        return;
      }

      if (_deviceToken?.isEmpty ?? true) {
        debugPrint('Something went wrong on generating sender/mobile device token');
        return;
      }

      final userToken = await context.read<AuthProvider>().generateJWT();

      debugPrint('User Token - $userToken');

      if (userToken?.isEmpty ?? true) {
        debugPrint('Something went wrong on generating jwt / user token');
        return;
      }
    } catch (error, stackTrace) {
      showErrorMessage(context, message: error.toString());
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }
}
