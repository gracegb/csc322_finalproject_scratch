import 'dart:ui';

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
