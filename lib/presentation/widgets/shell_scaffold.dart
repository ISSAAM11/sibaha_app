import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/bottom_navbar.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const BottomNavbar(),
    );
  }
}
