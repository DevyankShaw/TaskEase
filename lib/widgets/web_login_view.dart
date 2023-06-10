import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../utilities/utilities.dart';
import '../providers/providers.dart';

class WebLoginView extends StatefulWidget {
  const WebLoginView({super.key});

  @override
  State<WebLoginView> createState() => _WebLoginViewState();
}

class _WebLoginViewState extends State<WebLoginView> {
  String? _deviceToken;
  bool _loggingIn = false;
  late Stream<String> _tokenStream;

  void setToken(String? token) {
    debugPrint('Web Device Token: $token');
    setState(() {
      _deviceToken = token;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getToken(vapidKey: Constants.webPushCertificateKey)
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    FirebaseMessaging.onMessage.listen((message) async {
      setState(() {
        _loggingIn = true;
      });

      final userToken = message.data['userToken'];
      final deviceToken = message.data['deviceToken'];

      await onMessageReceived(userToken: userToken, deviceToken: deviceToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.tight(const Size(500, 500)),
        child: Stack(
          children: [
            loadAsset(assetName: 'qr_view.png'),
            Positioned(
              right: 125,
              bottom: 185,
              child: SizedBox(
                width: 150,
                height: 150,
                child: _deviceToken != null && !_loggingIn
                    ? QrImageView(
                        data: _deviceToken!,
                        version: QrVersions.auto,
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onMessageReceived({
    required String userToken,
    required String deviceToken,
  }) async {
    try {
      await context.read<AuthProvider>().loginWithJWT(
            userToken: userToken,
            deviceToken: deviceToken,
          );
    } catch (error, stackTrace) {
      setState(() {
        _loggingIn = false;
      });
      showErrorMessage(context, message: error.toString());
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }
}
