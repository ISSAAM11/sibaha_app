import 'package:flutter/material.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';
import 'package:sibaha_app/items/home_items/main_element.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainElement(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
