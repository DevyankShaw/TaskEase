import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WebLoginView extends StatelessWidget {
  const WebLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: QrImageView(
        data: '1234567890',
        version: QrVersions.auto,
        size: 200.0,
      ),
    );
  }
}
