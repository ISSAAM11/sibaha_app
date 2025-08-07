import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sibaha_app/blocs/academy_bloc/academy_bloc.dart';
import 'package:sibaha_app/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:sibaha_app/blocs/academy_details_bloc/academy_details_bloc.dart';
import 'package:sibaha_app/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/screens/initial_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 255)),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TokenBloc(),
            ),
            BlocProvider(
              create: (context) => AuthBloc(),
            ),
            BlocProvider(
              create: (context) => AcademyBloc(),
            ),
            BlocProvider(
              create: (context) => AcademyDetailsBloc(),
            )
          ],
          child: InitialScreen(),
        ));
  }
}
