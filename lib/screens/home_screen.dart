import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:sibaha_app/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';
import 'package:sibaha_app/items/home_items/main_element.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final tokenBloc = BlocProvider.of<TokenBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
      if (authState is AuthLogout) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => GoRouter.of(context).go('/login'),
        );
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return BlocBuilder<TokenBloc, TokenState>(builder: (context, tokenState) {
        if (tokenState is TokenExpired) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (tokenState is TokenInitial) {
          tokenBloc.add(TokenFetch());
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (tokenState is TokenNotFound) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => authBloc.add(LogoutEvent()),
          );
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          key: _scaffoldKey,
          body: MainElement(scaffoldKey: _scaffoldKey),
          bottomNavigationBar: BottomNavbar(),
        );
      });
    });
  }
}
