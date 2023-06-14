import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utilities/utilities.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (kIsWeb &&
            getDeviceByScreenWidth(constraints.maxWidth) !=
                Constants.mobileDevice) {
          return const WebLoginView();
        } else {
          return const MobileLoginView();
        }
      },
    );
  }
}
