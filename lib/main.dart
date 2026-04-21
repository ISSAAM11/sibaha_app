import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/data/repositories/academy_repository.dart';
import 'package:sibaha_app/data/repositories/auth_repository.dart';
import 'package:sibaha_app/data/repositories/user_repository.dart';
import 'package:sibaha_app/data/services/academy_service.dart';
import 'package:sibaha_app/data/services/auth_service.dart';
import 'package:sibaha_app/data/services/user_service.dart';
import 'package:sibaha_app/presentation/blocs/academy_bloc/academy_bloc.dart';
import 'package:sibaha_app/presentation/blocs/academy_details_bloc/academy_details_bloc.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:sibaha_app/presentation/screens/initial_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(AuthService())),
        RepositoryProvider(create: (_) => AcademyRepository(AcademyService())),
        RepositoryProvider(create: (_) => UserRepository(UserService())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => TokenBloc(
              authRepository: ctx.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => AuthBloc(
              authRepository: ctx.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => AcademyBloc(
              academyRepository: ctx.read<AcademyRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => AcademyDetailsBloc(
              academyRepository: ctx.read<AcademyRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => UserDetailsBloc(
              userRepository: ctx.read<UserRepository>(),
            ),
          ),
        ],
        child: const InitialScreen(),
      ),
    );
  }
}
