import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/pool_details/pool_details_widget.dart';

class PoolDetailsScreen extends StatelessWidget {
  final int id;

  const PoolDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PoolDetailsWidget(id: id),
    );
  }
}
