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
      height: 70,
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
          final path = GoRouterState.of(context).uri.path;

          if (state is! TokenRetrieved) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavbarButton(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: path == '/home',
                  onTap: () => context.go('/home'),
                ),
                NavbarButton(
                  icon: Icons.person,
                  label: 'Login',
                  isActive: path == '/login',
                  onTap: () => context.go('/login'),
                ),
              ],
            );
          }

          final userType = User.getUserType(state.userType);

          if (userType == UserType.coach) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavbarButton(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: path == '/home',
                  onTap: () => context.go('/home'),
                ),
                NavbarButton(
                  icon: Icons.calendar_today,
                  label: 'My Schedule',
                  isActive: path == '/my-schedule',
                  onTap: () => context.go('/my-schedule'),
                ),
                NavbarButton(
                  icon: Icons.person,
                  label: 'Account',
                  isActive: path.startsWith('/UserDetails'),
                  onTap: () => context.go('/UserDetails/informations'),
                ),
              ],
            );
          }

          if (userType == UserType.academyOwner) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NavbarButton(
                  icon: Icons.home,
                  label: 'Home',
                  isActive: path == '/home',
                  onTap: () => context.go('/home'),
                ),
                NavbarButton(
                  icon: Icons.maps_home_work,
                  label: 'My Academies',
                  isActive: path == '/AcademysList',
                  onTap: () => context.go('/AcademysList'),
                ),
                NavbarButton(
                  icon: Icons.person,
                  label: 'Account',
                  isActive: path.startsWith('/UserDetails'),
                  onTap: () => context.go('/UserDetails/informations'),
                ),
              ],
            );
          }

          // UserType.user
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavbarButton(
                icon: Icons.home,
                label: 'Home',
                isActive: path == '/home',
                onTap: () => context.go('/home'),
              ),
              NavbarButton(
                icon: Icons.school,
                label: 'My Courses',
                isActive: path == '/my-courses',
                onTap: () => context.go('/my-courses'),
              ),
              NavbarButton(
                icon: Icons.person,
                label: 'Account',
                isActive: path.startsWith('/UserDetails'),
                onTap: () => context.go('/UserDetails/informations'),
              ),
            ],
          );
        },
      ),
    );
  }
}
