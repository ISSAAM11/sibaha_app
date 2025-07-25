import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/blocs/bloc/auth_bloc_bloc.dart';
import 'package:sibaha_app/items/login_items/main_element.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBlocBloc = BlocProvider.of<AuthBlocBloc>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(child: MainElement()),
    );
  }
}
