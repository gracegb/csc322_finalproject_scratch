import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for managing the selected date
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
