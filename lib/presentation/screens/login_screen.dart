import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return BlocBuilder(
        bloc: authBloc,
        builder: (context, state) {
          if (authBloc.state is AuthSuccess) {
            tokenBloc.add(TokenFetch());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              GoRouter.of(context).go('/home');
            });
          }
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: SafeArea(child: LoginForm()),
          );
        });
  }
}
