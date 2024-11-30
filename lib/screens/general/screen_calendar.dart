import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:csc322_starter_app/models/event.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  static const routeName = '/calendar';

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );

  bool _isSignedIn = false;
  String? _userName;
  String? _userEmail;

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

    if (_googleSignIn.currentUser != null) {
      _isSignedIn = true;
      _userName = _googleSignIn.currentUser?.displayName;
      _userEmail = _googleSignIn.currentUser?.email;
      _fetchGoogleCalendarEvents();
      _startPeriodicSync();
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _syncTimer?.cancel();
    super.dispose();
  }

  Future<void> _signInGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        setState(() {
          _isSignedIn = true;
          _userName = googleUser.displayName;
          _userEmail = googleUser.email;
        });
        await _fetchGoogleCalendarEvents();
        _startPeriodicSync();
      }
    } catch (e) {
      print("Error signing in: $e");
      _showErrorSnackBar('Sign-in failed: $e');
    }
  }

  Future<void> _signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      setState(() {
        _isSignedIn = false;
        _userName = null;
        _userEmail = null;
        _events.clear();
        _selectedEvents.value = [];
      });
      print("User signed out");
      _syncTimer?.cancel();
    } catch (e) {
      print("Error signing out: $e");
      _showErrorSnackBar('Sign-out failed: $e');
    }
  }

  Future<void> _fetchGoogleCalendarEvents() async {
    final googleUser = _googleSignIn.currentUser;
    if (googleUser == null) {
      print("No user is signed in");
      return;
    }

    try {
      final authHeaders = await googleUser.authHeaders;
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
          final DateTime? eventDateTime =
              event.start?.dateTime ?? event.start?.date;
          if (eventDateTime != null) {
            final eventDate = DateTime(
              eventDateTime.year,
              eventDateTime.month,
              eventDateTime.day,
            );

            _events[eventDate] = [
              ...?_events[eventDate],
              Event(event.summary ?? "Unnamed Event"),
            ];
          }
        }
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });

      // print("Fetched Events:");
      // for (var entry in _events.entries) {
      //   print("Date: ${entry.key}, Events: ${entry.value.map((e) => e.title).toList()}");
      // }
    } catch (e) {
      _showErrorSnackBar('Failed to fetch events: $e');
    }
  }

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(Duration(minutes: 5), (timer) {
      if (_isSignedIn) {
        _fetchGoogleCalendarEvents();
      } else {
        timer.cancel();
      }
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    final eventsForDay = _events[normalizedDay] ?? [];
    // print("Events for $normalizedDay: ${eventsForDay.map((e) => e.title).toList()}");
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Calendar Integration'),
        actions: [
          if (_isSignedIn)
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _fetchGoogleCalendarEvents,
              tooltip: "Refresh Events",
            ),
          if (_isSignedIn)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _signOutGoogle,
              tooltip: "Sign Out",
            )
          else
            IconButton(
              icon: Icon(Icons.login),
              onPressed: _signInGoogle,
              tooltip: "Sign In",
            ),
        ],
      ),
      body: Column(
        children: [
          if (_isSignedIn)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Welcome, $_userName ($_userEmail)",
                style: TextStyle(fontSize: 16),
              ),
            ),
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
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(value[index].title),
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
