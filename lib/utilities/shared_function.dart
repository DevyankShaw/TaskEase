import 'package:flutter/material.dart';

import 'utilities.dart';

void showErrorMessage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.redAccent,
    ),
  );
}

void showSuccessMessage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.lightGreenAccent,
    ),
  );
}

void showInfoMessage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
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

Widget loadAsset({required String assetName, double? height}) => Material(
      type: MaterialType.transparency,
      elevation: 10.0,
      child: Image.asset('assets/$assetName', height: height),
    );

Color getTaskCardBackgroundColor(TaskStatus status) {
  switch (status) {
    case TaskStatus.notStarted:
      return Colors.blueGrey.shade200;
    case TaskStatus.inProgress:
      return Colors.yellowAccent.shade200;
    case TaskStatus.underReview:
      return Colors.orangeAccent.shade200;
    case TaskStatus.completed:
      return Colors.greenAccent.shade200;
    default:
      return Colors.grey.shade50;
  }
}

String getTaskStatusName(TaskStatus status) {
  switch (status) {
    case TaskStatus.notStarted:
      return Constants.notStarted;
    case TaskStatus.inProgress:
      return Constants.inProgress;
    case TaskStatus.underReview:
      return Constants.underReview;
    case TaskStatus.completed:
      return Constants.completed;
    default:
      return Constants.na;
  }
}

IconData getTaskStatusIcon(TaskStatus status) {
  switch (status) {
    case TaskStatus.notStarted:
      return Icons.not_started_outlined;
    case TaskStatus.inProgress:
      return Icons.auto_mode_outlined;
    case TaskStatus.underReview:
      return Icons.fact_check_outlined;
    case TaskStatus.completed:
      return Icons.done_all_outlined;
    default:
      return Icons.question_mark_outlined;
  }
}

String getDeviceByScreenWidth(double screenWidth) {
  if (screenWidth < 500) {
    return Constants.mobileDevice;
  } else if (screenWidth >= 500 && screenWidth < 900) {
    return Constants.tabletDevice;
  } else {
    return Constants.desktopDevice;
  }
}
