import 'package:flutter/material.dart';
import 'widget_centered_text.dart';

class WeekDaysRow extends StatelessWidget {
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) => CenteredText(day, fontSize: 16)).toList(),
    );
  }
}
