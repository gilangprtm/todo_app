import '../../../core/base/base_state_notifier.dart';
import '../../../data/models/todo_model.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarState extends BaseState {
  // Untuk calendar view
  final DateTime? selectedDay;
  final DateTime focusedDay;
  final String currentMonth;
  final Map<DateTime, List<TodoModel>> eventMarkers;
  final List<TodoModel> calendarTasks;
  final bool isLoadingTasks;
  final bool isInitialized;
  final CalendarFormat calendarFormat;
  final bool isRefreshing; // Flag untuk silent refresh

  CalendarState({
    super.isLoading = true,
    super.error,
    super.stackTrace,
    this.selectedDay,
    DateTime? focusedDay,
    String? currentMonth,
    Map<DateTime, List<TodoModel>>? eventMarkers,
    List<TodoModel>? calendarTasks,
    this.isLoadingTasks = false,
    this.isInitialized = false,
    CalendarFormat? calendarFormat,
    this.isRefreshing = false,
  }) : focusedDay = focusedDay ?? DateTime.now(),
       currentMonth =
           currentMonth ?? '${DateTime.now().year}-${DateTime.now().month}',
       eventMarkers = eventMarkers ?? {},
       calendarTasks = calendarTasks ?? [],
       calendarFormat = calendarFormat ?? CalendarFormat.month;

  @override
  CalendarState copyWith({
    bool? isLoading,
    dynamic error,
    StackTrace? stackTrace,
    bool clearError = false,
    DateTime? selectedDay,
    DateTime? focusedDay,
    String? currentMonth,
    Map<DateTime, List<TodoModel>>? eventMarkers,
    List<TodoModel>? calendarTasks,
    bool? isLoadingTasks,
    bool? isInitialized,
    CalendarFormat? calendarFormat,
    bool? isRefreshing,
  }) {
    return CalendarState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      currentMonth: currentMonth ?? this.currentMonth,
      eventMarkers: eventMarkers ?? this.eventMarkers,
      calendarTasks: calendarTasks ?? this.calendarTasks,
      isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
      isInitialized: isInitialized ?? this.isInitialized,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  // Getter untuk mendapatkan tasks pada selectedDay
  List<TodoModel> get selectedDayTasks {
    if (selectedDay == null) return [];

    final dateOnly = DateTime(
      selectedDay!.year,
      selectedDay!.month,
      selectedDay!.day,
    );

    return eventMarkers[dateOnly] ?? [];
  }

  // Get tasks for selected day
  List<TodoModel> getTasksForSelectedDay(DateTime date) {
    return calendarTasks.where((task) {
      if (task.dueDate == null) return false;
      final taskDate = task.dueDate!;
      return taskDate.year == date.year &&
          taskDate.month == date.month &&
          taskDate.day == date.day;
    }).toList();
  }
}
