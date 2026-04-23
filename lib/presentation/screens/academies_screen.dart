import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/academies/academies_list_widget.dart';
import 'package:sibaha_app/presentation/widgets/bottom_navbar.dart';

class AcademiesScreen extends StatelessWidget {
  const AcademiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.school, color: Colors.black87, size: 20),
        ),
        title: Container(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ),
      ),
      body: const AcademiesListWidget(),
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
