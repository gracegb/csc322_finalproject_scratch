import 'package:flutter/material.dart';

class SelectedDateBox extends StatelessWidget {
  final String date;

  SelectedDateBox({required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 34,
      decoration: BoxDecoration(
        color: Color(0xFF68AAE8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          date,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
