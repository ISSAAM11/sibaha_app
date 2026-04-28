import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const _bgUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA3DMT1EOM3TQ0IjmURtISmfUOAzG0s4xxEjYeKM4zoZ5h7HfRQRt_h2FFhEqnXAtRy4Nm5yJK99O2SbfWKb1SIhbYIYYOpx7w0pY2fzAWdlZKK2oYO8DO_S63-nCUfVzEAdHSSNtrqAPaa1-FO39Dnjud0qUrPC40V2gjdDVUGnjjDgl5mxYDyhMxHoVuxAFMX3bwnZ8MRoGVSnSNEuRE3qNuygT6nUTV1mbdc_nknOvk87LKCcM1vQrI9whKT2W7VxWSShkG08WKB';

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
          resizeToAvoidBottomInset: true,
          body: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Image.network(
                _bgUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFD8E2FF), Color(0xFF74F5FF)],
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.white.withOpacity(0.6),
                      Colors.transparent,
                      const Color(0xFF0058BC).withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              SafeArea(
                  child: Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const LoginForm(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}
