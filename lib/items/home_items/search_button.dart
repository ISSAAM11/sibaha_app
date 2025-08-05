import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SearchButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 75,
        height: 75,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 23, color: Colors.blue),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
