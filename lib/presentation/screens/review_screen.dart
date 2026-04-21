import 'package:flutter/material.dart';
import 'package:sibaha_app/presentation/widgets/academy_details/review_list.dart';

class ReviewScreen extends StatelessWidget {
  const ReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReviewList(),
    );
  }
}
