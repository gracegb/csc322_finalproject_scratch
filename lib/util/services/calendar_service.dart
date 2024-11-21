import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/google_event.dart';

class CalendarService {
  Future<List<GoogleEvent>> fetchCalendarEvents(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://www.googleapis.com/calendar/v3/calendars/primary/events'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['items'] as List)
          .map((item) => GoogleEvent.fromJson(item))
          .toList();
    } else {
      throw Exception("Failed to load calendar events");
    }
  }
}
