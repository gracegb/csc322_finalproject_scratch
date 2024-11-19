import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class Event {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final String notes;
  final bool isAllDay;
  final String repeat; // Recurrence pattern (e.g., "None", "Daily")
  final DateTime? endRepeat; // Optional end date for recurrence

  Event({
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.notes = '',
    this.isAllDay = false,
    this.repeat = 'None',
    this.endRepeat,
  });
}

final providerCalendarScreen = ChangeNotifierProvider<ProviderCalendarScreen>((ref) {
  return ProviderCalendarScreen();
});

class ProviderCalendarScreen extends ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  List<Event> getEventsForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _events[normalizedDate] ?? [];
  }

  void addEvent(DateTime date, Event event) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!_events.containsKey(normalizedDate)) {
      _events[normalizedDate] = [];
    }
    _events[normalizedDate]?.add(event);
    notifyListeners();
  }
}
