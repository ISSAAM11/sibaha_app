import 'package:flutter/material.dart';
import 'package:sibaha_app/items/bottom_navbar.dart';
import 'package:sibaha_app/items/user_details_item/main_element.dart';
import 'package:sibaha_app/items/user_details_item/user_information.dart';

class UserInformationScreen extends StatelessWidget {
  const UserInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserInformation(),
      bottomNavigationBar: BottomNavbar(),
    );
  }
}
