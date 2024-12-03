import 'dart:ui';

class Event {
  final String title;
  final String? location;
  final DateTime? startTime;
  final Duration? duration;

  Event(this.title, {this.location, this.startTime, this.duration});
}