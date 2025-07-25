import 'package:flutter/material.dart';

class MainElement extends StatelessWidget {
  const MainElement({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text(
        'academy list',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
