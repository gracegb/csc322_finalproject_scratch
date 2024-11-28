import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:csc322_starter_app/models/event.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
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
      }
    } catch (e) {
      print("Error signing in: $e");
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
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _disconnectGoogle() async {
    try {
      await _googleSignIn.disconnect();
      setState(() {
        _isSignedIn = false;
        _userName = null;
        _userEmail = null;
        _events.clear();
        _selectedEvents.value = [];
      });
      print("User disconnected");
    } catch (e) {
      print("Error disconnecting: $e");
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

      final eventsResponse = await calendarApi.events.list("primary");
      final List<calendar.Event> googleEvents = eventsResponse.items ?? [];

      setState(() {
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
    } catch (e) {
      print("Error fetching Google Calendar events: $e");
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents.value = _getEventsForDay(selectedDay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Calendar Integration'),
        actions: [
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
          if (_isSignedIn)
            IconButton(
              icon: Icon(Icons.switch_account),
              onPressed: _disconnectGoogle,
              tooltip: "Switch Account",
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
