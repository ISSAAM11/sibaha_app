import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/bottom_navbar.dart';

class UserInformationScreen extends StatelessWidget {
  final String route;

  const UserInformationScreen({super.key, this.route = "details"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
