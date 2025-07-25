import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/screens/academys_screen.dart';
import 'package:sibaha_app/screens/home_screen.dart';
import 'package:sibaha_app/screens/login_screen.dart';

class IntitialScreen extends StatefulWidget {
  const IntitialScreen({super.key});

  @override
  State<IntitialScreen> createState() => _IntitialScreenState();
}

class _IntitialScreenState extends State<IntitialScreen> {
  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/AcademysList',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: AcademysScreen()),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'iatu',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        primaryColorLight: Colors.grey.shade200,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 1.5,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 1,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        colorScheme: const ColorScheme.light(
          onError: Color.fromARGB(255, 102, 0, 0),
        ),
        dialogTheme: const DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        fontFamily: "BR Cobane",
        useMaterial3: true,
      ),
    );
  }
}
