import 'package:appwrite_hackathon/providers/auth_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../utilities/utilities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      showFlutterNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout_outlined),
          ),
          if (!kIsWeb)
            IconButton(
              onPressed: () => _openQrScanner(context),
              icon: const Icon(Icons.qr_code_scanner_outlined),
            ),
        ],
      ),
      body: const Center(child: Text('Home Screen')),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await context.read<AuthProvider>().logout();
    } catch (error, stackTrace) {
      showErrorMessage(context, message: error.toString());
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }

  _openQrScanner(BuildContext context) {
    context.push(Routes.qrScanner.toPath);
  }
}
