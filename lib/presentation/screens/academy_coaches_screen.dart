import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/presentation/widgets/academy_details/coach_list.dart';
import 'package:sibaha_app/presentation/widgets/bottom_navbar.dart';

class AcademyCoachesScreen extends StatelessWidget {
  const AcademyCoachesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          'Coach List',
          style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: CoachList(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
