import 'package:flutter/material.dart';

class DaySchedule extends StatelessWidget {
  final String day;
  final String time;
  const DaySchedule({super.key, required this.day, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Spacer(),
          Text(
            time,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
