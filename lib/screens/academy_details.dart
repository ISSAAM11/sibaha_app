import 'package:flutter/material.dart';
import 'package:sibaha_app/items/academy_details_screen/main_element.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';

class AcademyDetails extends StatelessWidget {
  final int id;

  const AcademyDetails({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: MainElement(id: id)),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
