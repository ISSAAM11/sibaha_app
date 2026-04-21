import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:sibaha_app/presentation/widgets/user/user_details_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_email_edit_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_informations_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_password_edit_widget.dart';

class UserProfileWidget extends StatelessWidget {
  final String interface;

  const UserProfileWidget(this.interface, {super.key});

  @override
  Widget build(BuildContext context) {
    final tokenBloc = BlocProvider.of<TokenBloc>(context);
    final userDetailsBloc = BlocProvider.of<UserDetailsBloc>(context);

    return BlocBuilder<TokenBloc, TokenState>(builder: (context, tokenState) {
      if (tokenState is TokenExpired) {
        return const Center(child: CircularProgressIndicator());
      }
      if (tokenState is TokenInitial) {
        tokenBloc.add(TokenFetch());
        return const Center(child: CircularProgressIndicator());
      }
      if (tokenState is TokenNotFound) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => BlocProvider.of<AuthBloc>(context).add(LogoutEvent()),
        );
        return const Center(child: CircularProgressIndicator());
      }
      return Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: SafeArea(
                    child: Center(
                      child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
                        builder: (context, state) {
                          if (state is UserDetailsInitial) {
                            context.read<UserDetailsBloc>().add(FetchUserEvent(
                                (tokenState as TokenRetrieved).token));
                            return SizedBox();
                          } else if (state is UserDetailsLoading) {
                            return CircularProgressIndicator();
                          } else if (state is UserDetailsTokenExpired) {
                            tokenBloc.add(TokenRefresh());
                            userDetailsBloc.add(UserDetailsReset());
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is UserDetailsError) {
                            return Text(state.message,
                                style: TextStyle(color: Colors.red));
                          } else if (state is UserDetailsLoaded) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromARGB(255, 231, 231, 231),
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=240&h=240&fit=crop&crop=face',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  state.data.userType
                                      .toString()
                                      .split('.')
                                      .last,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.data.username,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
                if (interface != "informations")
                  Positioned(
                    top: 20,
                    left: 20,
                    child: BackButton(
                      onPressed: () =>
                          context.go("/UserDetails/informations"),
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            switch (interface) {
              "informations" => UserInformationsWidget(),
              "details" => UserDetailsWidget(),
              "email" => UserEmailEditWidget(),
              "password" => UserPasswordEditWidget(),
              _ => Container(),
            },
          ],
        ),
      );
    });
  }
}
