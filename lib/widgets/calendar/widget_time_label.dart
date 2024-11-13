import 'package:flutter/material.dart';

class TimeLabel extends StatelessWidget {
  final String time;

  TimeLabel(this.time);

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: TextStyle(
        color: Color(0xFF9E9E9E),
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
