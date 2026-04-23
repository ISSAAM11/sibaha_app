import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/data/models/user.dart';
import 'package:sibaha_app/presentation/blocs/token_bloc/token_bloc.dart';
import 'package:sibaha_app/presentation/widgets/navbar_button.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BlocBuilder<TokenBloc, TokenState>(
        builder: (context, state) {
          final userType = state is TokenRetrieved
              ? User.getUserType(state.userType)
              : UserType.user;
          return userType == UserType.academyOwner
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavbarButton(
                      icon: Icons.search,
                      label: 'Search',
                      isActive: true,
                      onTap: () => context.go("/home"),
                    ),
                    NavbarButton(
                      icon: Icons.maps_home_work_outlined,
                      label: 'My Academies',
                      isActive: false,
                      onTap: () => context.go("/home"),
                    ),
                    NavbarButton(
                      icon: Icons.person_outline,
                      label: 'Account',
                      isActive: false,
                      onTap: () => context.go("/UserDetails/informations"),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavbarButton(
                      icon: Icons.search,
                      label: 'Search',
                      isActive: true,
                      onTap: () => context.go("/home"),
                    ),
                    NavbarButton(
                      icon: Icons.favorite_border,
                      label: 'My List',
                      isActive: false,
                      onTap: () {},
                    ),
                    NavbarButton(
                      icon: Icons.person_outline,
                      label: 'Account',
                      isActive: false,
                      onTap: () => context.go("/UserDetails/informations"),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
