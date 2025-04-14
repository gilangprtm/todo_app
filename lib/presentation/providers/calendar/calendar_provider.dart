import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_providers.dart';
import 'calendar_notifier.dart';
import 'calendar_state.dart';

/// Provider for Calendar Screen
final calendarProvider = StateNotifierProvider<CalendarNotifier, CalendarState>(
  (ref) {
    final todoService = ref.watch(todoServiceProvider);
    return CalendarNotifier(CalendarState(), ref, todoService);
  },
);
