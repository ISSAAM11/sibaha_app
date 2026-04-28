import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';

class TokenGate extends StatelessWidget {
  final Widget child;

  const TokenGate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TokenBloc, TokenState>(
      listenWhen: (_, current) => current is TokenNotFound,
      listener: (context, _) {
        context.go('/login');
      },
      child: BlocBuilder<TokenBloc, TokenState>(
        builder: (context, state) {
          if (state is TokenRetrieved) return child;
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
