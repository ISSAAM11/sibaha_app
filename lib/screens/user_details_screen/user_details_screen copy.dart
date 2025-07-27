import 'package:flutter/material.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';
import 'package:sibaha_app/items/user_details_item/main_element.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainElement(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
