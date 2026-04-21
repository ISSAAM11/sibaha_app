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
      child: Container(
        color: Colors.grey[50],
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Info',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    title: 'My information',
                    onTap: () => context.push('/UserDetails/details'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('More',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    title: 'Edit email',
                    onTap: () => context.go('/UserDetails/email'),
                  ),
                  _buildMenuItem(
                    title: 'Edit password',
                    onTap: () => context.go('/UserDetails/password'),
                  ),
                  Text('Logout',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 15),
                  _buildMenuItem(
                    title: 'Logout',
                    onTap: () {
                      authBloc.add(LogoutEvent());
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  Widget _buildMenuItem({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500)),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
