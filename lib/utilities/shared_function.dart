import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
    ),
  );
}

void showSuccessMessage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.greenAccent,
    ),
  );
}

void showInfoMessage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.blueAccent,
    ),
  );
}

Future<void> sendPushMessage({
  required String receiverDeviceToken,
  required String payload,
}) async {
  if (receiverDeviceToken.isEmpty) {
    debugPrint('Unable to send FCM message, no token exists.');
    return;
  }

  try {} catch (e) {
    rethrow;
  }
}

Widget getLogo({required String logoPath, double? height}) => Material(
      type: MaterialType.transparency,
      elevation: 10.0,
      child: Image.asset(logoPath, height: height),
    );
