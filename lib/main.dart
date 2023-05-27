import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'providers/providers.dart';
import 'screens/screens.dart';
import 'utilities/utilities.dart';

void main() {
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
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }

  late final _authProvider = AuthProvider();

  late final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: _authProvider,
    routes: <GoRoute>[
      GoRoute(
        name: Routes.home.toName,
        path: Routes.home.toPath,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: Routes.login.toName,
        path: Routes.login.toPath,
        builder: (context, state) => const LoginScreen(),
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
