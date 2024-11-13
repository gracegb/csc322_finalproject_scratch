import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  final String text;
  final double fontSize;

  CenteredText(this.text, {this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
