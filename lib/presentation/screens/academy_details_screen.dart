import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/academy_details/academy_details_widget.dart';
import 'package:sibaha_app/presentation/widgets/bottom_navbar.dart';

class AcademyDetailsScreen extends StatelessWidget {
  final int id;

  const AcademyDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AcademyDetailsWidget(id: id),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
