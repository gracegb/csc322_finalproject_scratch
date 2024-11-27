// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';

// class ReusableCalendar extends StatelessWidget {
//   final DateTime focusedDay;
//   final DateTime selectedDay;
//   final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
//   final Map<DateTime, List<String>> events;

//   const ReusableCalendar ({
//     Key? key,
//     required this.focusedDay,
//     required this.selectedDay,
//     required this.onDaySelected,
//     required this.events,
//   }) : super(key: key);

//   List<String> _getEventsForDay(DateTime day) {
//     return events[day] ?? [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TableCalendar(
//       firstDay: DateTime(2020),
//       lastDay: DateTime(2030),
//       focusedDay: focusedDay,
//       calendarFormat: CalendarFormat.month,
//       selectedDayPredicate: (day) => isSameDay(selectedDay, day),
//       onDaySelected: onDaySelected,
//       eventLoader: _getEventsForDay,
//       headerStyle: HeaderStyle(
//         formatButtonVisible: false,
//         titleCentered: true,
//       ),
//       calendarStyle: CalendarStyle(
//         todayDecoration: BoxDecoration(
//           color: Colors.blueAccent,
//           shape: BoxShape.circle,
//         ),
//         selectedDecoration: BoxDecoration(
//           color: Colors.orange,
//           shape: BoxShape.circle,
//         ),
//       ),
//     );
//   }
// }
