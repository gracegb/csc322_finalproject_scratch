import 'package:flutter/material.dart';
import '/widgets/calendar/widget_bottom_nav_bar.dart';
import '/widgets/calendar/widget_centered_text.dart';
import '/widgets/calendar/widget_event_card.dart';
import '/widgets/calendar/widget_selected_date_box.dart';
import '/widgets/calendar/widget_time_label.dart';
import '/widgets/calendar/widget_week_days_row.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),
          Positioned(
            left: 0,
            top: 745,
            child: BottomNavBar(),
          ),
          Positioned(
            left: 82,
            top: 72,
            child: CenteredText('November 2024', fontSize: 20),
          ),
          Positioned(
            left: 38,
            top: 71,
            child: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
          ),
          Positioned(
            left: 267,
            top: 72,
            child: IconButton(icon: Icon(Icons.calendar_today), onPressed: () {}),
          ),
          Positioned(
            left: 307,
            top: 72,
            child: IconButton(icon: Icon(Icons.settings), onPressed: () {}),
          ),
          Positioned(
            left: 14,
            top: 137,
            child: WeekDaysRow(),
          ),
          Positioned(
            left: 14,
            top: 256,
            child: TimeLabel('8 am'),
          ),
          Positioned(
            left: 14,
            top: 324,
            child: TimeLabel('9 am'),
          ),
          Positioned(
            left: 14,
            top: 414,
            child: TimeLabel('10 am'),
          ),
          Positioned(
            left: 14,
            top: 485,
            child: TimeLabel('11 am'),
          ),
          Positioned(
            left: 14,
            top: 563,
            child: TimeLabel('12 pm'),
          ),
          Positioned(
            left: 14,
            top: 647,
            child: TimeLabel('1 pm'),
          ),
          Positioned(
            left: 127,
            top: 161,
            child: SelectedDateBox(date: '12'),
          ),
          Positioned(
            left: 77,
            top: 297,
            child: EventCard(
              title: 'STA310-A',
              time: '8:30-9:30am',
              color: Color(0xA5BCFDB3),
            ),
          ),
        ],
      ),
    );
  }
}
