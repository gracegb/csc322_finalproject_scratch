import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '/widgets/calendar/widget_bottom_nav_bar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Calendar Page'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 30, // Display a range of 30 days
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index - 15));
                final isSelected = _selectedDate.day == date.day &&
                    _selectedDate.month == date.month &&
                    _selectedDate.year == date.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          DateFormat('d MMM').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SfCalendar(
              view: CalendarView.day,
              initialDisplayDate: _selectedDate,
              dataSource: MeetingDataSource(getAppointmentsForSelectedDate()),
              backgroundColor: Colors.white,
              todayHighlightColor: Colors.blueAccent,
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
              headerStyle: CalendarHeaderStyle(
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
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
                  setState(() {
                    _selectedDate = details.date!;
                  });
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddEventDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      // bottomNavigationBar: BottomNavBar(),
    );
  }

  // Generate dummy appointments for the selected date
  List<Appointment> getAppointmentsForSelectedDate() {
    List<Appointment> meetings = <Appointment>[];

    DateTime startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 9, 0);
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

  // Open dialog to add a new event
  void _openAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String title = '';
        String time = '';
        String description = '';

        return AlertDialog(
          title: Text('Add Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Event Title'),
                onChanged: (value) => title = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Event Time (e.g., 8:30-9:30am)'),
                onChanged: (value) => time = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Event Description'),
                onChanged: (value) => description = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && time.isNotEmpty) {
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
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
