import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibaha_app/items/navbar_button.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          NavbarButton(
            icon: Icons.search,
            label: 'Search',
            isActive: true,
            onTap: () => print('Search pressed'),
          ),
          NavbarButton(
            icon: Icons.favorite_border,
            label: 'My List',
            isActive: false,
            onTap: () => print('My List pressed'),
          ),
          NavbarButton(
            icon: Icons.person_outline,
            label: 'Account',
            isActive: false,
            onTap: () => context.go("/UserDetails"),
          ),
        ],
      ),
    );
  }
}
