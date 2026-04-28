import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/user/user_profile_widget.dart';

class UserDetailsScreen extends StatelessWidget {
  final String interface;

  const UserDetailsScreen({super.key, this.interface = "informations"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserProfileWidget(interface),
    );
  }
}
