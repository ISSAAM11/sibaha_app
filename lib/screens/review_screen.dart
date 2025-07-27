import 'package:flutter/material.dart';
import 'package:sibaha_app/items/academy_details_screen/review_list.dart';

class AcademyReviewScreen extends StatelessWidget {
  const AcademyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReviewList(),
    );
  }
}
