import 'package:csc322_starter_app/providers/provider_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import '/providers/provider_calendar_screen.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  static const routeName = '/calendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _currentWeekStart;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentWeekStart = _getCurrentWeekStart();
    _selectedDate = DateTime.now();
  }

  DateTime _getCurrentWeekStart() {
    final now = DateTime.now();
    return now.subtract(Duration(days: now.weekday % 7));
  }

  List<DateTime> _getCurrentWeekDates() {
    return List<DateTime>.generate(
        7, (index) => _currentWeekStart.add(Duration(days: index)));
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: 7));
      _selectedDate = _selectedDate.add(Duration(days: 7));
      ref.read(selectedDateProvider.notifier).state = _selectedDate;
    });
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStart = _currentWeekStart.subtract(Duration(days: 7));
      _selectedDate = _selectedDate.subtract(Duration(days: 7));
      ref.read(selectedDateProvider.notifier).state = _selectedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Month Label
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0), // Space between header and date boxes
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _goToPreviousWeek,
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(selectedDate),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: _goToNextWeek,
                    ),
                  ],
                ),
              ),
              // Date Boxes
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    _goToNextWeek();
                  } else if (details.primaryVelocity! > 0) {
                    _goToPreviousWeek();
                  }
                },
                child: SizedBox(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _getCurrentWeekDates().map((date) {
                      final isSelected = selectedDate.day == date.day &&
                          selectedDate.month == date.month &&
                          selectedDate.year == date.year;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8), // space between boxes
                        child: GestureDetector(
                          onTap: () {
                            ref.read(selectedDateProvider.notifier).state =
                                date;
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                DateFormat('EEE').format(date),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 4),
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  DateFormat('d').format(date),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Calendar
              Expanded(
                child: SfCalendar(
                  view: CalendarView.day,
                  initialDisplayDate: selectedDate,
                  dataSource: MeetingDataSource(
                      getAppointmentsForSelectedDate(selectedDate)),
                  backgroundColor: Colors.white,
                  todayHighlightColor: Colors.blueAccent,
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(fontSize: 0), // Hides the header text
                    backgroundColor: Colors
                        .transparent, // Makes the header background transparent
                  ),
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeFormat: 'h a',
                    timeIntervalHeight: 60,
                    timeTextStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    timeInterval: Duration(hours: 1),
                    timelineAppointmentHeight: 60,
                    startHour: 0,
                    endHour: 24,
                  ),
                  viewHeaderStyle: ViewHeaderStyle(
                    dayTextStyle: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    dateTextStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  appointmentTextStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  appointmentBuilder:
                      (context, CalendarAppointmentDetails details) {
                    final Appointment appointment = details.appointments.first;
                    return Container(
                      width: details.bounds.width,
                      height: details.bounds.height,
                      decoration: BoxDecoration(
                        color: appointment.color,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: Text(
                          '${appointment.subject}', // Display event title
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  onTap: (CalendarTapDetails details) {
                    if (details.date != null) {
                      setState(() {
                        _selectedDate = details.date!;
                      });
                      ref.read(selectedDateProvider.notifier).state =
                          details.date!;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEventDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  List<Appointment> getAppointmentsForSelectedDate(DateTime selectedDate) {
    final events =
        ref.watch(providerCalendarScreen).getEventsForDate(selectedDate);
    return events.map((event) {
      return Appointment(
        startTime: event.startTime,
        endTime: event.endTime,
        subject: event.name,
        color: event.color,
      );
    }).toList();
  }

  void _openAddEventDialog() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _notesController = TextEditingController();
    final TimeOfDay initialStartTime = TimeOfDay(hour: 9, minute: 0);
    final TimeOfDay initialEndTime = TimeOfDay(hour: 10, minute: 0);
    bool isAllDay = false;
    String repeatOption = 'None'; // Default repeat value
    DateTime?
        endRepeatDate; // Add this variable for the end of the repeat pattern

    showDialog(
      context: context,
      builder: (context) {
        TimeOfDay? selectedStartTime = initialStartTime;
        TimeOfDay? selectedEndTime = initialEndTime;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Event'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Event Title
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Event Title'),
                    ),
                    SizedBox(height: 10),

                    // Notes
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(labelText: 'Notes'),
                    ),
                    SizedBox(height: 10),

                    // All-Day Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('All Day'),
                        Switch(
                          value: isAllDay,
                          onChanged: (value) {
                            setState(() {
                              isAllDay = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Start and End Time
                    if (!isAllDay)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: selectedStartTime!,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  selectedStartTime = pickedTime;
                                });
                              }
                            },
                            child: Text(
                              'Start: ${selectedStartTime?.format(context) ?? 'Select'}',
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final TimeOfDay? pickedTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: selectedEndTime!,
                              );
                              if (pickedTime != null) {
                                setState(() {
                                  selectedEndTime = pickedTime;
                                });
                              }
                            },
                            child: Text(
                              'End: ${selectedEndTime?.format(context) ?? 'Select'}',
                            ),
                          ),
                        ],
                      ),

                    // Repeat Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Repeat'),
                        DropdownButton<String>(
                          value: repeatOption,
                          items: [
                            'None',
                            'Daily',
                            'Weekly',
                            'Monthly',
                            'Yearly'
                          ].map((option) {
                            return DropdownMenuItem(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              repeatOption = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    if (repeatOption != 'None')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('End Repeat'),
                          TextButton(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  endRepeatDate = pickedDate;
                                });
                              }
                            },
                            child: Text(
                              endRepeatDate != null
                                  ? DateFormat('yyyy-MM-dd')
                                      .format(endRepeatDate!)
                                  : 'Select Date',
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isNotEmpty) {
                      final DateTime startTime = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        selectedStartTime?.hour ?? 0,
                        selectedStartTime?.minute ?? 0,
                      );
                      final DateTime endTime = isAllDay
                          ? startTime.add(Duration(hours: 24))
                          : DateTime(
                              _selectedDate.year,
                              _selectedDate.month,
                              _selectedDate.day,
                              selectedEndTime?.hour ?? 0,
                              selectedEndTime?.minute ?? 0,
                            );

                      final event = Event(
                        name: _titleController.text,
                        startTime: startTime,
                        endTime: endTime,
                        color: Colors.purple,
                        notes: _notesController.text,
                        isAllDay: isAllDay,
                        repeat: repeatOption,
                        endRepeat: endRepeatDate,
                      );

                      // Add the new event to the provider
                      ref
                          .read(providerCalendarScreen)
                          .addEvent(_selectedDate, event);

                      Navigator.of(context).pop(); // Close dialog
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
