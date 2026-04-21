import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/academies/academies_list_widget.dart';
import 'package:sibaha_app/presentation/widgets/bottom_navbar.dart';

class AcademiesScreen extends StatelessWidget {
  const AcademiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AcademiesListWidget(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
