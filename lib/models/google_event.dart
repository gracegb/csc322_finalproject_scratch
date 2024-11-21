class GoogleEvent {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  GoogleEvent({required this.title, required this.startTime, required this.endTime});

  factory GoogleEvent.fromJson(Map<String, dynamic> json) {
    return GoogleEvent(
      title: json['summary'] ?? 'No Title',
      startTime: DateTime.parse(json['start']['dateTime'] ?? json['start']['date']),
      endTime: DateTime.parse(json['end']['dateTime'] ?? json['end']['date']),
    );
  }
}
