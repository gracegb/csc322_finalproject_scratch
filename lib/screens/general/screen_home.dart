import 'dart:async';
import 'package:csc322_starter_app/providers/provider_google.dart';
import 'package:csc322_starter_app/widgets/home/widget_home_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/home/widget_home_attention.dart';
import '../../widgets/home/widget_home_chats.dart';

// Define HomeEvent class
class HomeEvent {
  final DateTime time;
  final String label;
  final String location;
  final Color color;

  HomeEvent({
    required this.time,
    required this.label,
    required this.location,
    required this.color,
  });
}

class ScreenHome extends ConsumerStatefulWidget {
  static const routeName = '/home';

  @override
  ConsumerState<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends ConsumerState<ScreenHome> {
  // Instance variables managed in this state
  bool _isInit = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<HomeEvent>> _events = {};

  @override
  void didChangeDependencies() {
    // If first time running this code, initialize the state
    if (_isInit) {
      _selectedDay = DateTime.now();
      _fetchEventsForSelectedDay();
      _isInit = false;
      super.didChangeDependencies();
    }
  }

Future<void> _fetchEventsForSelectedDay() async {
  final googleAuth = ref.read(googleSignInProvider);

  // Skip if not signed in
  if (!googleAuth.isSignedIn) return;

  final currentDay = _selectedDay ?? DateTime.now();
  
  // Fetch events for the selected day
  final fetchedEvents = await fetchEventsForDay(currentDay, googleAuth.user);

  if (mounted) {
    setState(() {
      // Convert API events into `HomeEvent` objects
      _events[currentDay] = fetchedEvents.map((event) {
        return HomeEvent(
          time: event.startTime != null
              ? event.startTime!.toLocal() // Convert to local time
              : DateTime(currentDay.year, currentDay.month, currentDay.day),
          label: event.title,
          location: event.location ?? "No Location",
          color: Color(0xFFB3E5FC), // Default color for events
        );
      }).toList();
    });
  }
}




  String _getMonth(int monthIndex) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[monthIndex - 1];
  }

  String _getDayOfWeek(DateTime date) {
    const daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return daysOfWeek[date.weekday];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _fetchEventsForSelectedDay(); // Fetch events for the new selected day
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = _selectedDay ?? DateTime.now();
    final eventsForDay = _events[selectedDay] ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // Adds padding around the content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // CustomEventCard and CustomAttentionCard in a Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomEventCard(
                      date: '${selectedDay.day}',
                      month: _getMonth(selectedDay.month),
                      day: _getDayOfWeek(selectedDay),
                      events: eventsForDay,
                    ),
                  ),
                  SizedBox(width: 16), // Add spacing between the two cards
                  Expanded(
                    flex: 1,
                    child: CustomAttentionCard(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Team chat card
              TeamChatCard(),
            ],
          ),
        ),
      ),
    );
  }
}
