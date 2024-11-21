// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '/providers/provider_calendar.dart';

// void showAddEventDialog(
//     BuildContext context, WidgetRef ref, DateTime selectedDate) {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();
//   final TimeOfDay initialStartTime = TimeOfDay(hour: 9, minute: 0);
//   final TimeOfDay initialEndTime = TimeOfDay(hour: 10, minute: 0);
//   bool isAllDay = false;
//   String repeatOption = 'None';
//   DateTime? endRepeatDate;

//   showDialog(
//     context: context,
//     builder: (context) {
//       TimeOfDay? selectedStartTime = initialStartTime;
//       TimeOfDay? selectedEndTime = initialEndTime;

//       return StatefulBuilder(
//         builder: (context, setState) {
//           return AlertDialog(
//             title: Text('Add Event'),
//             content: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxHeight: MediaQuery.of(context).size.height * 0.7,
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextField(
//                       controller: _titleController,
//                       decoration: InputDecoration(labelText: 'Event Title'),
//                     ),
//                     SizedBox(height: 10),
//                     TextField(
//                       controller: _notesController,
//                       decoration: InputDecoration(labelText: 'Notes'),
//                     ),
//                     SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('All Day'),
//                         Switch(
//                           value: isAllDay,
//                           onChanged: (value) {
//                             setState(() {
//                               isAllDay = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     if (!isAllDay)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           TextButton(
//                             onPressed: () async {
//                               final TimeOfDay? pickedTime =
//                                   await showTimePicker(
//                                 context: context,
//                                 initialTime: selectedStartTime!,
//                               );
//                               if (pickedTime != null) {
//                                 setState(() {
//                                   selectedStartTime = pickedTime;
//                                 });
//                               }
//                             },
//                             child: Text(
//                                 'Start: ${selectedStartTime?.format(context) ?? 'Select'}'),
//                           ),
//                           TextButton(
//                             onPressed: () async {
//                               final TimeOfDay? pickedTime =
//                                   await showTimePicker(
//                                 context: context,
//                                 initialTime: selectedEndTime!,
//                               );
//                               if (pickedTime != null) {
//                                 setState(() {
//                                   selectedEndTime = pickedTime;
//                                 });
//                               }
//                             },
//                             child: Text(
//                                 'End: ${selectedEndTime?.format(context) ?? 'Select'}'),
//                           ),
//                         ],
//                       ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Repeat'),
//                         DropdownButton<String>(
//                           value: repeatOption,
//                           items: [
//                             'None',
//                             'Daily',
//                             'Weekly',
//                             'Monthly',
//                             'Yearly'
//                           ].map((option) {
//                             return DropdownMenuItem(
//                               value: option,
//                               child: Text(option),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             setState(() {
//                               repeatOption = value!;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     if (repeatOption != 'None')
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text('End Repeat'),
//                           TextButton(
//                             onPressed: () async {
//                               final pickedDate = await showDatePicker(
//                                 context: context,
//                                 initialDate: DateTime.now(),
//                                 firstDate: DateTime.now(),
//                                 lastDate: DateTime(2100),
//                               );
//                               if (pickedDate != null) {
//                                 setState(() {
//                                   endRepeatDate = pickedDate;
//                                 });
//                               }
//                             },
//                             child: Text(
//                               endRepeatDate != null
//                                   ? DateFormat('yyyy-MM-dd')
//                                       .format(endRepeatDate!)
//                                   : 'Select Date',
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('Cancel'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_titleController.text.isNotEmpty) {
//                     final event = Event(
//                       name: _titleController.text,
//                       startTime: DateTime(
//                         selectedDate.year,
//                         selectedDate.month,
//                         selectedDate.day,
//                         selectedStartTime?.hour ?? 0,
//                         selectedStartTime?.minute ?? 0,
//                       ),
//                       endTime: isAllDay
//                           ? DateTime(selectedDate.year, selectedDate.month,
//                                   selectedDate.day)
//                               .add(Duration(days: 1))
//                           : DateTime(
//                               selectedDate.year,
//                               selectedDate.month,
//                               selectedDate.day,
//                               selectedEndTime?.hour ?? 0,
//                               selectedEndTime?.minute ?? 0,
//                             ),
//                       color: Colors.purple,
//                       notes: _notesController.text,
//                       isAllDay: isAllDay,
//                       repeatOption:
//                           repeatOption, // Pass the selected repeat option
//                       endRepeatDate:
//                           endRepeatDate, // Pass the selected end repeat date
//                     );
//                     ref.read(providerCalendar).addEvent(selectedDate, event);
//                     Navigator.of(context).pop();
//                   }
//                 },
//                 child: Text('Add'),
//               ),
//             ],
//           );
//         },
//       );
//     },
//   );
// }
