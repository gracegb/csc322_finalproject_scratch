import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback goToNextWeek;
  final VoidCallback goToPreviousWeek;

  const CalendarHeader({
    required this.selectedDate,
    required this.goToNextWeek,
    required this.goToPreviousWeek,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: goToPreviousWeek,
          ),
          Text(
            DateFormat('MMMM yyyy').format(selectedDate),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: goToNextWeek,
          ),
        ],
      ),
    );
  }
}
