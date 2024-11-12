import 'package:csc322_starter_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider_auth.dart';
import '../util/services/calendar_service.dart';
import '../models/google_event.dart';

final calendarProvider = StateNotifierProvider<CalendarNotifier, List<GoogleEvent>>((ref) {
  final authProvider = ref.watch(providerAuth);
  return CalendarNotifier(CalendarService(), authProvider.googleAccessToken);
});

class CalendarNotifier extends StateNotifier<List<GoogleEvent>> {
  final CalendarService _calendarService;
  final String? _accessToken;

  CalendarNotifier(this._calendarService, this._accessToken) : super([]);

  Future<void> loadEvents() async {
    if (_accessToken == null) return;
    final events = await _calendarService.fetchCalendarEvents(_accessToken!);
    state = events; // Update state with the list of events
  }
}