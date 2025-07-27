import 'package:flutter/material.dart';
import 'package:sibaha_app/items/academy_details_screen/main_element.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';

class AcademyDetails extends StatelessWidget {
  const AcademyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: MainElement()),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
