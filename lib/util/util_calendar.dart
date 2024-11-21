// import 'package:csc322_starter_app/models/event.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';

// class CalendarUtil {
//   static List<Appointment> getAppointments(List<Event> events) {
//     List<Appointment> appointments = [];
//     for (var event in events) {
//       if (event.repeatOption == 'None') {
//         appointments.add(
//           Appointment(
//             startTime: event.startTime,
//             endTime: event.endTime,
//             subject: event.name,
//             color: event.color,
//             notes: event.notes,
//             isAllDay: event.isAllDay,
//           ),
//         );
//       } else {
//         // Generate repeated events
//         DateTime current = event.startTime;
//         while (current.isBefore(event.endRepeatDate!)) {
//           appointments.add(
//             Appointment(
//               startTime: current,
//               endTime: current.add(event.endTime.difference(event.startTime)),
//               subject: event.name,
//               color: event.color,
//               notes: event.notes,
//               isAllDay: event.isAllDay,
//             ),
//           );

//           // Increment based on repeatOption
//           if (event.repeatOption == 'Daily') {
//             current = current.add(Duration(days: 1));
//           } else if (event.repeatOption == 'Weekly') {
//             current = current.add(Duration(days: 7));
//           } else if (event.repeatOption == 'Monthly') {
//             current = DateTime(current.year, current.month + 1, current.day);
//           } else if (event.repeatOption == 'Yearly') {
//             current = DateTime(current.year + 1, current.month, current.day);
//           }
//         }
//       }
//     }
//     return appointments;
//   }
// }
