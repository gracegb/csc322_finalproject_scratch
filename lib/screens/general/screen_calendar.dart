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
    return List<DateTime>.generate(7, (index) => _currentWeekStart.add(Duration(days: index)));
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
      appBar: AppBar(
        title: Text('Custom Calendar Page'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Month Label
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0), // Space between header and date boxes
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: _goToPreviousWeek,
                    ),
                    Text(
                      DateFormat('MMMM yyyy').format(selectedDate),
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8), // space between boxes
                        child: GestureDetector(
                          onTap: () {
                            ref.read(selectedDateProvider.notifier).state = date;
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
                                  color: isSelected ? Colors.blueAccent : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  DateFormat('d').format(date),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : Colors.black,
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
                  dataSource: MeetingDataSource(getAppointmentsForSelectedDate(selectedDate)),
                  backgroundColor: Colors.white,
                  todayHighlightColor: Colors.blueAccent,
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(fontSize: 0), // Hides the header text
                    backgroundColor: Colors.transparent, // Makes the header background transparent
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
                    startHour: 8,
                    endHour: 20,
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
                  appointmentBuilder: (context, CalendarAppointmentDetails details) {
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
                          appointment.subject,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  onTap: (CalendarTapDetails details) {
                    if (details.date != null) {
                      ref.read(selectedDateProvider.notifier).state = details.date!;
                      setState(() {
                        _selectedDate = details.date!;
                      });
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
    List<Appointment> meetings = <Appointment>[];

    DateTime startTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 9, 0);
    DateTime endTime = startTime.add(const Duration(hours: 1));

    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Meeting with Team',
      color: Colors.blue,
    ));

    startTime = startTime.add(Duration(hours: 2));
    endTime = startTime.add(Duration(hours: 1));

    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Project Update',
      color: Colors.green,
    ));

    startTime = startTime.add(Duration(hours: 2));
    endTime = startTime.add(Duration(hours: 1));

    meetings.add(Appointment(
      startTime: startTime,
      endTime: endTime,
      subject: 'Client Call',
      color: Colors.red,
    ));

    return meetings;
  }

  void _openAddEventDialog() {
    // Open a dialog to add a new event
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
