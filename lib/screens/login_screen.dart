import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        if (kIsWeb && constraints.maxWidth >= 500) {
          return const WebLoginView();
        } else {
          return const MobileLoginView();
        }
      },
    );
  }
}
