import 'package:appwrite_hackathon/providers/auth_provider.dart';
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
  late final _tasks = <Task>[
    Task(
      taskName: 'Make something 1',
      taskStatus: TaskStatus.notStarted,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 2',
      remarks: 'Update something 2',
      isImportant: true,
      deadline: DateTime.now().copyWith(hour: 14, minute: 22),
      taskStatus: TaskStatus.inProgress,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 3',
      taskStatus: TaskStatus.underReview,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 4',
      taskStatus: TaskStatus.notStarted,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 5',
      remarks: 'Update something 5',
      taskStatus: TaskStatus.notStarted,
      isImportant: true,
      deadline: DateTime.now()
          .add(const Duration(days: 1))
          .copyWith(hour: 09, minute: 30),
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 6',
      taskStatus: TaskStatus.completed,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 7',
      isImportant: true,
      taskStatus: TaskStatus.inProgress,
      deadline: DateTime.now().copyWith(year: 2022, hour: 16, minute: 30),
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 8',
      taskStatus: TaskStatus.notStarted,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 9',
      isImportant: true,
      taskStatus: TaskStatus.completed,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
    Task(
      taskName: 'Make something 10',
      taskStatus: TaskStatus.underReview,
      createdAt: DateTime.now(),
      createdBy: 'Shyam(762762)',
    ),
  ];

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
        children: [
          const SearchField(),
          TaskCardLayoutGrid(
            crossAxisCount: 2,
            tasks: _tasks,
          ),
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
