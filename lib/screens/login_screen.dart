import 'package:flutter/material.dart';
import 'package:sibaha_app/items/login_items/main_element.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(child: MainElement()),
    );
  }
}
