import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/blocs/user_details_bloc/user_details_bloc.dart';
import 'package:sibaha_app/presentation/widgets/user/user_details_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_email_edit_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_informations_widget.dart';
import 'package:sibaha_app/presentation/widgets/user/user_password_edit_widget.dart';

class UserProfileWidget extends StatefulWidget {
  final String interface;

  const UserProfileWidget(this.interface, {super.key});

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  bool _fetchTriggered = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_fetchTriggered) {
      final token =
          (context.read<TokenBloc>().state as TokenRetrieved).token;
      context.read<UserDetailsBloc>().add(FetchUserEvent(token));
      _fetchTriggered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 250,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: BlocListener<UserDetailsBloc, UserDetailsState>(
                      listenWhen: (_, s) => s is UserDetailsTokenExpired,
                      listener: (context, _) {
                        context.read<TokenBloc>().add(TokenRefresh());
                        context
                            .read<UserDetailsBloc>()
                            .add(UserDetailsReset());
                      },
                      child: BlocBuilder<UserDetailsBloc, UserDetailsState>(
                        builder: (context, state) {
                          if (state is UserDetailsLoading ||
                              state is UserDetailsInitial ||
                              state is UserDetailsTokenExpired) {
                            return const CircularProgressIndicator();
                          }
                          if (state is UserDetailsError) {
                            return Text(state.message,
                                style:
                                    const TextStyle(color: Colors.red));
                          }
                          if (state is UserDetailsLoaded) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 231, 231, 231),
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
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
                                const SizedBox(height: 20),
                                Text(
                                  state.data.userType
                                      .toString()
                                      .split('.')
                                      .last,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.data.username,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.interface != "informations")
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
          switch (widget.interface) {
            "informations" => UserInformationsWidget(),
            "details" => const UserDetailsWidget(),
            "email" => const UserEmailEditWidget(),
            "password" => const UserPasswordEditWidget(),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }
}
