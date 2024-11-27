import 'dart:ffi';

import 'package:csc322_starter_app/models/event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const routeName = '/calendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // stores the created events
  Map<DateTime, List<Event>> events = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _eventController.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value =
            _getEventsForDay(selectedDay); // Update notifier
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    final eventsForDay = events[day];
    print('Getting events for day: $day -> $eventsForDay');
    return eventsForDay ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                scrollable: true,
                title: Text("Event Name"),
                content: Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _eventController,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      events.addAll({
                        _selectedDay!: [Event(_eventController.text)]
                      });
                      Navigator.of(context).pop();
                      _selectedEvents.value = _getEventsForDay(_selectedDay!);
                    },
                    child: Text("Submit"),
                  )
                ],
              );
              // return AlertDialog(
              //   scrollable: true,
              //   title: Text("Event Name"),
              //   content: Padding(
              //     padding: EdgeInsets.all(8),
              //     child: TextField(
              //       controller: _eventController,
              //       decoration: InputDecoration(
              //         labelText: "Enter event name",
              //         border: OutlineInputBorder(),
              //       ),
              //     ),
              //   ),
              //   actions: [
              //     ElevatedButton(
              //       onPressed: () {
              //         // Check if the input is empty
              //         if (_eventController.text.isEmpty) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(content: Text('Event name cannot be empty')),
              //           );
              //           return;
              //         }

              //         setState(() {
              //           // Add the event to the selected day
              //           if (_selectedDay != null) {
              //             events[_selectedDay!] = [
              //               ..._getEventsForDay(_selectedDay!),
              //               Event(_eventController.text),
              //             ];
              //             _selectedEvents.value =
              //                 _getEventsForDay(_selectedDay!);
              //           }
              //           _eventController.clear(); // Clear the text field
              //         });
              //         Navigator.of(context).pop(); // Close the dialog
              //       },
              //       child: Text("Submit"),
              //     ),
              //   ],
              // );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            // may not be necessary?
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents.value =
                    _getEventsForDay(selectedDay); // Update notifier
              });
            },
            eventLoader: _getEventsForDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                if (value.isEmpty) {
                  return Center(child: Text('No events for this day!'));
                }
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(value[index].title),
                        onTap: () => print(value[index].title), // For debugging
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Expanded(
          //   child: _selectedDay != null
          //       ? ListView(
          //           children: _getEventsForDay(_selectedDay)
          //               .map((event) => ListTile(
          //                     title: Text(event),
          //                   ))
          //               .toList(),
          //         )
          //       : Center(
          //           child: Text('No events for this day!'),
          //         ),
          // ),
        ],
      ),
    );
  }
}
