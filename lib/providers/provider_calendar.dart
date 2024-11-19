import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Event model
class Event {
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final String notes;
  final bool isAllDay;
  final String repeat; // Recurrence pattern (e.g., "None", "Daily")
  final DateTime? endRepeat;

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

// Calendar provider for global event management
final providerCalendar = ChangeNotifierProvider<ProviderCalendar>((ref) {
  return ProviderCalendar();
});

class ProviderCalendar extends ChangeNotifier {
  final Map<DateTime, List<Event>> _events = {};

  List<Event> getEventsForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    List<Event> eventsForDate = [];

    // Add non-recurring events directly
    if (_events[normalizedDate] != null) {
      eventsForDate.addAll(_events[normalizedDate]!);
    }

    // Check recurring events across all stored events
    for (var eventList in _events.values) {
      for (var event in eventList) {
        if (event.repeat != 'None' &&
            _isRecurringEventOnDate(event, normalizedDate)) {
          eventsForDate.add(event);
        }
      }
    }

    return eventsForDate;
  }

  bool _isRecurringEventOnDate(Event event, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    DateTime occurrenceDate =
        DateTime(event.startTime.year, event.startTime.month, event.startTime.day);

    final endRepeat = event.endRepeat ?? DateTime.now().add(Duration(days: 365));

    // Check if the event falls within its valid recurrence range
    if (normalizedDate.isBefore(occurrenceDate) || normalizedDate.isAfter(endRepeat)) {
      return false;
    }

    // Loop through occurrences to check if the event recurs on the selected date
    while (occurrenceDate.isBefore(endRepeat.add(Duration(days: 1)))) {
      if (occurrenceDate.year == normalizedDate.year &&
          occurrenceDate.month == normalizedDate.month &&
          occurrenceDate.day == normalizedDate.day) {
        return true;
      }
      occurrenceDate = _getNextRecurringDate(occurrenceDate, event.repeat);
    }

    return false;
  }

  DateTime _getNextRecurringDate(DateTime current, String repeatPattern) {
    switch (repeatPattern) {
      case 'Daily':
        return current.add(Duration(days: 1));
      case 'Weekly':
        return current.add(Duration(days: 7));
      case 'Monthly':
        return DateTime(current.year, current.month + 1, current.day);
      case 'Yearly':
        return DateTime(current.year + 1, current.month, current.day);
      default:
        return current;
    }
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
