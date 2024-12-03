import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../../providers/provider_google.dart';
import '../../models/event.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  static const routeName = '/calendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};
  late final ValueNotifier<List<Event>> _selectedEvents;

  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(
      _focusedDay.year,
      _focusedDay.month,
      _focusedDay.day,
    );
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _syncTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchGoogleCalendarEvents() async {
    final googleAuthState = ref.watch(googleSignInProvider);

    if (!googleAuthState.isSignedIn) return;

    try {
      final googleUser = googleAuthState.user;
      final authHeaders = await googleUser!.authHeaders;
      final client = GoogleAuthClient(authHeaders);
      final calendarApi = calendar.CalendarApi(client);

      final eventsResponse = await calendarApi.events.list(
        "primary",
        maxResults: 250,
        singleEvents: true,
        orderBy: 'startTime',
        timeMin: DateTime.now().toUtc(),
      );

      final List<calendar.Event> googleEvents = eventsResponse.items ?? [];

      setState(() {
        _events.clear();
        for (var event in googleEvents) {
          final DateTime? startDateTime =
              event.start?.dateTime ?? event.start?.date;
          final DateTime? endDateTime =
              event.end?.dateTime ?? event.end?.date;

          if (startDateTime != null) {
            final eventDate = DateTime(
              startDateTime.year,
              startDateTime.month,
              startDateTime.day,
            );

            final duration = (startDateTime != null && endDateTime != null)
                ? endDateTime.difference(startDateTime)
                : null;

            _events[eventDate] = [
              ...?_events[eventDate],
              Event(
                event.summary ?? "Unnamed Event",
                location: event.location,
                startTime: startDateTime,
                duration: duration,
              ),
            ];
          }
        }
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    } catch (e) {
      _showErrorSnackBar('Failed to fetch events: $e');
    }
  }

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      final googleAuthState = ref.watch(googleSignInProvider);
      if (googleAuthState.isSignedIn) {
        _fetchGoogleCalendarEvents();
      } else {
        timer.cancel();
      }
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final eventsForDay = _events[normalizedDay] ?? [];
    return eventsForDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      );
      _focusedDay = DateTime(
        focusedDay.year,
        focusedDay.month,
        focusedDay.day,
      );
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final googleAuthState = ref.watch(googleSignInProvider);
    final googleAuthNotifier = ref.read(googleSignInProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: googleAuthState.isSignedIn
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome, ${googleAuthState.user?.displayName ?? ''}",
                      style: TextStyle(fontSize: 16)),
                  Text("${googleAuthState.user?.email ?? ''}",
                      style: TextStyle(fontSize: 12)),
                ],
              )
            : Text("Google Calendar Integration"),
        actions: [
          if (googleAuthState.isSignedIn)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _fetchGoogleCalendarEvents,
              tooltip: "Refresh Events",
            ),
          if (googleAuthState.isSignedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: googleAuthNotifier.signOut,
              tooltip: "Sign Out",
            )
          else
            IconButton(
              icon: Icon(Icons.login),
              onPressed: googleAuthNotifier.signIn,
              tooltip: "Sign In",
            ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2020),
            lastDay: DateTime(2030),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: _onDaySelected,
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
                      margin:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(value[index].title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (value[index].startTime != null)
                              Text(
                                "Time: ${value[index].startTime?.toLocal()}",
                              ),
                            if (value[index].duration != null)
                              Text(
                                "Duration: ${value[index].duration?.inMinutes} minutes",
                              ),
                            if (value[index].location != null)
                              Text(
                                "Location: ${value[index].location}",
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
