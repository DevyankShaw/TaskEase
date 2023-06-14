import 'package:appwrite_hackathon/providers/providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/models.dart';
import '../utilities/utilities.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loggingOut = false;

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
        title: const Text('Taskify'),
        actions: [
          if (!kIsWeb)
            IconButton(
              tooltip: 'QR Scanner',
              onPressed: () => _openQrScanner(context),
              icon: const Icon(Icons.qr_code_scanner_outlined),
            ),
          _loggingOut
              ? Center(
                  child: SizedBox.fromSize(
                    size: const Size(30, 30),
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
                )
              : IconButton(
                  tooltip: 'Log Out',
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout_outlined),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Task',
        onPressed: () {
          context.push(
            Routes.task.toPath,
            extra: TaskData(),
          );
        },
        child: const Icon(
          Icons.add_circle_outline_outlined,
          size: 28,
        ),
      ),
      body: Column(
        children: const [
          SearchField(),
          TaskCardLayoutGrid(),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      setState(() {
        _loggingOut = true;
      });
      await context.read<AuthProvider>().logout();
    } catch (error, stackTrace) {
      setState(() {
        _loggingOut = false;
      });
      showErrorMessage(context, message: error.toString());
      debugPrint('Error $error occurred at stackTrace $stackTrace');
    }
  }

  _openQrScanner(BuildContext context) {
    context.push(Routes.qrScanner.toPath);
  }
}
