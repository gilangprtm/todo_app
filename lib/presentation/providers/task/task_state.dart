import '../../../core/base/base_state_notifier.dart';
import '../../../data/models/todo_model.dart';

class TaskState extends BaseState {
  final List<TodoModel> todos;
  final List<TodoModel> previousTodos;
  final int completedCount;
  final bool filterByToday;
  final DateTime selectedDate;
  final bool isLoadingPrevious;
  final bool isRefreshing;

  TaskState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
    this.todos = const [],
    this.previousTodos = const [],
    this.completedCount = 0,
    this.filterByToday = true,
    DateTime? selectedDate,
    this.isLoadingPrevious = false,
    this.isRefreshing = false,
  }) : selectedDate = selectedDate ?? DateTime.now();

  @override
  TaskState copyWith({
    bool? isLoading,
    dynamic error,
    StackTrace? stackTrace,
    bool clearError = false,
    List<TodoModel>? todos,
    List<TodoModel>? previousTodos,
    int? completedCount,
    bool? filterByToday,
    DateTime? selectedDate,
    bool? isLoadingPrevious,
    bool? isRefreshing,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      todos: todos ?? this.todos,
      previousTodos: previousTodos ?? this.previousTodos,
      completedCount: completedCount ?? this.completedCount,
      filterByToday: filterByToday ?? this.filterByToday,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoadingPrevious: isLoadingPrevious ?? this.isLoadingPrevious,
      isRefreshing: isRefreshing ?? this.isRefreshing,
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
