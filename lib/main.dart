import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/models.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'services/services.dart';
import 'utilities/utilities.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    Constants.notificationChannelId, // id
    Constants.notificationChannelName, // title
    description: Constants.notificationChannelDescription, // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          Constants.notificationChannelId,
          Constants.notificationChannelName,
          channelDescription: Constants.notificationChannelDescription,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> requestPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission();

  debugPrint('User granted permission: ${settings.authorizationStatus}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreference.init();
  ClientService.init(
    userToken: SharedPreference.instance.getString(Constants.userToken),
  );
  if (kIsWeb) {
    await requestPermission();
  } else {
    await setupFlutterNotifications();
  }
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => _authProvider,
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Appwrite Hackathon',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
      ),
    );
  }

  late final _authProvider = AuthProvider();

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: _authProvider,
    routes: [
      GoRoute(
        name: Routes.home.toName,
        path: Routes.home.toPath,
        builder: (context, state) => ChangeNotifierProvider<TaskProvider>.value(
          value: _authProvider.taskProvider!,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        name: Routes.login.toName,
        path: Routes.login.toPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: Routes.qrScanner.toName,
        path: Routes.qrScanner.toPath,
        builder: (context, state) => const QrScannerScreen(),
      ),
      GoRoute(
        name: Routes.task.toName,
        path: Routes.task.toPath,
        builder: (context, state) => ChangeNotifierProvider<TaskProvider>.value(
          value: _authProvider.taskProvider!,
          child: TaskScreen(taskData: state.extra as TaskData),
        ),
      ),
    ],
    // redirect to the login page if the user is not logged in
    redirect: (BuildContext context, GoRouterState state) async {
      final bool loggedIn = await _authProvider.isLoggedIn();
      final bool loggingIn = state.matchedLocation == Routes.login.toPath;

      // Go to /login if the user is not logged in
      if (!loggedIn && !loggingIn) {
        return Routes.login.toPath;
      }
      // Go to / if the user is logged in and tries to go to /login.
      else if (loggedIn && loggingIn) {
        return Routes.home.toPath;
      }

      // no need to redirect at all
      return null;
    },
  );
}
