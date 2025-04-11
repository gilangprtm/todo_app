import '../../../core/base/base_state_notifier.dart';
import '../../../data/models/todo_model.dart';

class TaskState extends BaseState {
  final List<TodoModel> todos;
  final int completedCount;
  final bool filterByToday;
  final DateTime selectedDate;

  TaskState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
    this.todos = const [],
    this.completedCount = 0,
    this.filterByToday = true,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  @override
  TaskState copyWith({
    bool? isLoading,
    Object? error,
    StackTrace? stackTrace,
    bool clearError = false,
    List<TodoModel>? todos,
    int? completedCount,
    bool? filterByToday,
    DateTime? selectedDate,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      todos: todos ?? this.todos,
      completedCount: completedCount ?? this.completedCount,
      filterByToday: filterByToday ?? this.filterByToday,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  // Helper method to get completion percentage
  double get completionPercentage {
    if (todos.isEmpty) return 0.0;
    return completedCount / todos.length;
  }

  // Helper method to get formatted completion percentage
  String get completionPercentageString {
    return '${(completionPercentage * 100).toInt()}% Selesai';
  }
}
