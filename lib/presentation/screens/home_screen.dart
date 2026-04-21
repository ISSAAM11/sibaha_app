import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/bottom_navbar.dart';
import 'package:sibaha_app/presentation/widgets/home/home_main_widget.dart';

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
        return const Center(child: CircularProgressIndicator());
      }
      return BlocBuilder<TokenBloc, TokenState>(
          builder: (context, tokenState) {
        if (tokenState is TokenExpired) {
          return const Center(child: CircularProgressIndicator());
        }
        if (tokenState is TokenInitial) {
          tokenBloc.add(TokenFetch());
          return const Center(child: CircularProgressIndicator());
        }
        if (tokenState is TokenNotFound) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => authBloc.add(LogoutEvent()),
          );
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          key: _scaffoldKey,
          body: HomeMainWidget(scaffoldKey: _scaffoldKey),
          bottomNavigationBar: BottomNavbar(),
          drawer: Drawer(
            elevation: 0,
            width: double.infinity,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                spacing: 10,
                children: [
                  Spacer(flex: 1),
                  Text('Your city',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    onTap: () {},
                  ),
                  Spacer(flex: 5),
                ],
              ),
            ),
          ),
        );
      });
    });
  }
}
