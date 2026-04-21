import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/screens/academy_coaches_screen.dart';
import 'package:sibaha_app/presentation/screens/academy_details_screen.dart';
import 'package:sibaha_app/presentation/screens/academies_screen.dart';
import 'package:sibaha_app/presentation/screens/home_screen.dart';
import 'package:sibaha_app/presentation/screens/login_screen.dart';
import 'package:sibaha_app/presentation/screens/review_screen.dart';
import 'package:sibaha_app/presentation/screens/user/user_details_screen.dart';
import 'package:sibaha_app/presentation/screens/user/user_information_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final authBloc = context.read<AuthBloc>();
        if (authBloc.state is AuthInitial) {
          authBloc.add(AutoAuthEvent());
        }
      });
      _isInitialized = true;
    }
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: LoginScreen()),
      ),
      GoRoute(
        path: '/AcademysList',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: AcademiesScreen()),
      ),
      GoRoute(
        path: '/AcademyDetails/:id',
        pageBuilder: (context, state) {
          final id = state.pathParameters["id"]!;
          return NoTransitionPage(
              child: AcademyDetailsScreen(id: int.parse(id)));
        },
      ),
      GoRoute(
        path: '/AcademyCoachs',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: AcademyCoachesScreen()),
      ),
      GoRoute(
        path: '/ReviewList',
        pageBuilder: (context, state) =>
            NoTransitionPage(child: ReviewScreen()),
      ),
      GoRoute(
        path: '/UserDetails/:interface',
        pageBuilder: (context, state) {
          final interface = state.pathParameters["interface"]!;
          return NoTransitionPage(
              child: UserDetailsScreen(interface: interface));
        },
      ),
      GoRoute(
        path: '/UserInformation/:route',
        pageBuilder: (context, state) {
          final route = state.pathParameters["route"]!;
          return NoTransitionPage(child: UserInformationScreen(route: route));
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sibaha',
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        fontFamily: "BR Cobane",
        useMaterial3: true,
      ),
    );
  }
}
