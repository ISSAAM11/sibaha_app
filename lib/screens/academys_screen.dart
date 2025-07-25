import 'package:flutter/material.dart';
import 'package:sibaha_app/items/academy_list_items/main_element.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';

class AcademysScreen extends StatelessWidget {
  const AcademysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainElement(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
