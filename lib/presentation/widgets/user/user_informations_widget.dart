import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/blocs/auth_bloc/auth_bloc.dart';

class UserInformationsWidget extends StatelessWidget {
  const UserInformationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account Settings',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1B1B),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFF0EDEC)),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  _SettingItem(
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    subtitle:
                        'Update your name, bio, and public profile details',
                    onTap: () => context.push('/UserDetails/details'),
                  ),
                  const _ItemDivider(),
                  _SettingItem(
                    icon: Icons.mail_outline,
                    title: 'Edit Email',
                    subtitle: 'Update your primary email address',
                    onTap: () => context.go('/UserDetails/email'),
                  ),
                  const _ItemDivider(),
                  _SettingItem(
                    icon: Icons.lock_reset,
                    title: 'Edit Password',
                    subtitle: 'Change your account security credentials',
                    onTap: () => context.go('/UserDetails/password'),
                  ),
                  const _ItemDivider(),
                  _SignOutItem(
                    onTap: () {
                      authBloc.add(LogoutEvent());
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF0EDEC),
              ),
              child: Icon(icon, color: const Color(0xFF414755), size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1C1B1B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF414755)),
          ],
        ),
      ),
    );
  }
}

class _SignOutItem extends StatelessWidget {
  final VoidCallback onTap;

  const _SignOutItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFDAD6).withOpacity(0.4),
              ),
              child:
                  const Icon(Icons.logout, color: Color(0xFFBA1A1A), size: 20),
            ),
            const SizedBox(width: 16),
            const Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFFBA1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemDivider extends StatelessWidget {
  const _ItemDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0EDEC),
    );
  }
}
