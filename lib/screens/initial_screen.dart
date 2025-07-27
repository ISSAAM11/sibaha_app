import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/screens/academy_details.dart';
import 'package:sibaha_app/screens/academys_coach_screen.dart';
import 'package:sibaha_app/screens/academys_screen.dart';
import 'package:sibaha_app/screens/home_screen.dart';
import 'package:sibaha_app/screens/login_screen.dart';
import 'package:sibaha_app/screens/review_screen.dart';
import 'package:sibaha_app/screens/user_details_screen/user_details_screen%20copy.dart';
import 'package:sibaha_app/screens/user_details_screen/user_information_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/AcademysList',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: AcademysScreen()),
      ),
      GoRoute(
        path: '/AcademyDetails',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: AcademyDetails()),
      ),
      GoRoute(
        path: '/AcademyCoachs',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: AcademysCoachsScreen()),
      ),
      GoRoute(
        path: '/ReviewList',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: AcademyReviewScreen()),
      ),
      GoRoute(
        path: '/UserDetails',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: UserDetailsScreen()),
      ),
      GoRoute(
        path: '/UserInformation',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: UserInformationScreen()),
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
          onError: Color.fromARGB(255, 0, 0, 0),
        ),
        hoverColor: Colors.grey[200],
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
