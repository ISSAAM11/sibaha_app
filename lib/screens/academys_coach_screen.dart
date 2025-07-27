import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/items/academy_details_screen/coatch_list.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';

class AcademysCoachsScreen extends StatelessWidget {
  const AcademysCoachsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
        ),
        title: Text(
          'Coach List',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: CoachListScreen(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
