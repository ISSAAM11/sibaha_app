import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/core/theme/app_theme.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/screens/academy_coaches_screen.dart';
import 'package:sibaha_app/presentation/screens/academy_details_screen.dart';
import 'package:sibaha_app/presentation/screens/academies_screen.dart';
import 'package:sibaha_app/presentation/screens/coach/my_schedule_screen.dart';
import 'package:sibaha_app/presentation/screens/home_screen.dart';
import 'package:sibaha_app/presentation/screens/pool_details_screen.dart';
import 'package:sibaha_app/presentation/screens/pools_screen.dart';
import 'package:sibaha_app/presentation/screens/forgot_password_email_screen.dart';
import 'package:sibaha_app/presentation/screens/forgot_password_new_password_screen.dart';
import 'package:sibaha_app/presentation/screens/forgot_password_otp_screen.dart';
import 'package:sibaha_app/presentation/screens/login_screen.dart';
import 'package:sibaha_app/presentation/screens/signup_screen.dart';
import 'package:sibaha_app/presentation/screens/review_screen.dart';
import 'package:sibaha_app/presentation/screens/user/my_courses_screen.dart';
import 'package:sibaha_app/presentation/screens/user/user_details_screen.dart';
import 'package:sibaha_app/presentation/screens/user/user_information_screen.dart';
import 'package:sibaha_app/presentation/widgets/shell_scaffold.dart';
import 'package:sibaha_app/presentation/widgets/token_gate.dart';

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
      // Forgot-password flow — no shell/navbar (multi-step modal flow)
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: ForgotPasswordEmailScreen()),
      ),
      GoRoute(
        path: '/forgot-password/otp',
        pageBuilder: (context, state) {
          final email = state.extra as String? ?? '';
          return NoTransitionPage(
              child: ForgotPasswordOtpScreen(email: email));
        },
      ),
      GoRoute(
        path: '/forgot-password/new-password',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, String>? ?? {};
          return NoTransitionPage(
            child: ForgotPasswordNewPasswordScreen(
              email: data['email'] ?? '',
              code: data['code'] ?? '',
            ),
          );
        },
      ),

      // Shell routes — persistent navbar
      ShellRoute(
        builder: (context, state, child) => ShellScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: '/login',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: LoginScreen()),
          ),
          GoRoute(
            path: '/signup',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: SignUpScreen()),
          ),
          GoRoute(
            path: '/my-courses',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MyCoursesScreen()),
          ),
          GoRoute(
            path: '/my-schedule',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: MyScheduleScreen()),
          ),
          GoRoute(
            path: '/AcademysList',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: AcademiesScreen()),
          ),
          GoRoute(
            path: '/AcademyDetails/:id',
            pageBuilder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return NoTransitionPage(child: AcademyDetailsScreen(id: id));
            },
          ),
          GoRoute(
            path: '/poolList',
            pageBuilder: (context, state) =>
                NoTransitionPage(child: PoolsScreen()),
          ),
          GoRoute(
            path: '/poolList/:id',
            pageBuilder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return NoTransitionPage(child: PoolDetailsScreen(id: id));
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
              final interface = state.pathParameters['interface']!;
              return NoTransitionPage(
                  child: TokenGate(
                      child: UserDetailsScreen(interface: interface)));
            },
          ),
          GoRoute(
            path: '/UserInformation/:route',
            pageBuilder: (context, state) {
              final route = state.pathParameters['route']!;
              return NoTransitionPage(
                  child:
                      TokenGate(child: UserInformationScreen(route: route)));
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.read<TokenBloc>().add(TokenFetch());
          }
          if (state is AuthLogout) {
            context.read<TokenBloc>().add(TokenDelete());
            _router.go('/login');
          }
        },
        child: MaterialApp.router(
          title: 'Sibaha',
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: AppTheme.lightTheme,
        ));
  }
}
