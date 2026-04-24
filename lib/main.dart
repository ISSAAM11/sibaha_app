import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/core/di/service_locator.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';
import 'package:sibaha_app/data/repositories/auth_repository.dart';
import 'package:sibaha_app/data/repositories/pool_repository.dart';
import 'package:sibaha_app/data/repositories/user_repository.dart';
import 'package:sibaha_app/presentation/blocs/academy_bloc/academy_bloc.dart';
import 'package:sibaha_app/presentation/blocs/academy_details_bloc/academy_details_bloc.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/blocs/pool_bloc/pool_bloc.dart';
import 'package:sibaha_app/presentation/blocs/pool_details_bloc/pool_details_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:sibaha_app/presentation/screens/initial_screen.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TokenBloc(
            authRepository: getIt<AuthRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => AuthBloc(
            authRepository: getIt<AuthRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => AcademyBloc(
            academyRepository: getIt<AcademyRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => AcademyDetailsBloc(
            academyRepository: getIt<AcademyRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => PoolBloc(
            poolRepository: getIt<PoolRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => PoolDetailsBloc(
            poolRepository: getIt<PoolRepository>(),
          ),
        ),
        BlocProvider(
          create: (_) => UserDetailsBloc(
            userRepository: getIt<UserRepository>(),
          ),
        ),
      ],
      child: const InitialScreen(),
    );
  }
}
