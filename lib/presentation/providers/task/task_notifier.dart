import '../../../core/base/base_state_notifier.dart';
import '../../../data/models/subtask_model.dart';
import '../../../data/models/todo_model.dart';
import '../../../data/datasource/local/services/todo_service.dart';
import 'task_state.dart';

class TaskNotifier extends BaseStateNotifier<TaskState> {
  final TodoService _todoService;

  TaskNotifier(super.initialState, super.ref, this._todoService);

  @override
  Future<void> onInit() async {
    await fetchTasks();
  }

  // Load todos from the database
  Future<void> loadTodos() async {
    await runAsync('loadTodos', () async {
      state = state.copyWith(isLoading: true);

      try {
        List<TodoModel> todos;
        if (state.filterByToday) {
          todos = await _todoService.getTodosForToday();
        } else {
          todos = await _todoService.getTodosForDate(state.selectedDate);
        }

        final completedCount = todos.where((todo) => todo.status == 2).length;

        state = state.copyWith(
          todos: todos,
          completedCount: completedCount,
          isLoading: false,
          clearError: true,
        );
      } catch (e, stackTrace) {
        state = state.copyWith(
          error: e,
          stackTrace: stackTrace,
          isLoading: false,
        );
      }
    });
  }

  // Load previous unfinished todos
  Future<void> loadPreviousTodos() async {
    await runAsync('loadPreviousTodos', () async {
      state = state.copyWith(isLoadingPrevious: true);

      try {
        final previousTodos = await _todoService.getPreviousTodos();

        state = state.copyWith(
          previousTodos: previousTodos,
          isLoadingPrevious: false,
          clearError: true,
        );
      } catch (e, stackTrace) {
        state = state.copyWith(
          error: e,
          stackTrace: stackTrace,
          isLoadingPrevious: false,
        );
      }
    });
  }

  // Toggle filtering by today's date
  void toggleTodayFilter() {
    state = state.copyWith(filterByToday: !state.filterByToday);
    loadTodos();
  }

  // Set a specific date to filter by
  void setSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date, filterByToday: false);
    loadTodos();
  }

  // Toggle a todo's completion status
  Future<void> toggleTodoStatus(TodoModel todo) async {
    await runAsync('toggleTodoStatus', () async {
      // Determine new status: 0 -> 1 -> 2 -> 0 (Pending -> In Progress -> Completed -> Pending)
      final newStatus = (todo.status + 1) % 3;

      // Update the todo via service
      final updatedTodo = await _todoService.updateTodoStatus(todo, newStatus);

      // Update state with updated todo
      List<TodoModel> updatedTodos = List.from(state.todos);
      // Check if the todo is in the today's list
      int todayIndex = updatedTodos.indexWhere((t) => t.id == todo.id);

      List<TodoModel> updatedPreviousTodos = List.from(state.previousTodos);
      // Check if the todo is in the previous list
      int previousIndex = updatedPreviousTodos.indexWhere(
        (t) => t.id == todo.id,
      );

      // Handle based on new status
      if (newStatus == 2) {
        // For completed tasks, update in today's list but remove from previous list
        if (todayIndex != -1) {
          // Update in place for today's tasks, even if completed
          updatedTodos[todayIndex] = updatedTodo;
        }

        // Remove from previous tasks if completed
        if (previousIndex != -1) {
          updatedPreviousTodos.removeAt(previousIndex);
        }
      } else {
        // For non-completed, update in place
        if (todayIndex != -1) {
          updatedTodos[todayIndex] = updatedTodo;
        }
        if (previousIndex != -1) {
          updatedPreviousTodos[previousIndex] = updatedTodo;
        }

        // If status is changed from completed back to non-completed
        // we need to check if it should be added to a list
        if (todo.status == 2) {
          // Was completed, now it's not
          DateTime now = DateTime.now();
          DateTime todoDate = todo.dueDate ?? now;

          // Check if it belongs to today's list
          bool isToday =
              todoDate.year == now.year &&
              todoDate.month == now.month &&
              todoDate.day == now.day;

          if (isToday && todayIndex == -1 && state.filterByToday) {
            // Add to today's list if not already there
            updatedTodos.add(updatedTodo);
          } else if (todoDate.isBefore(
                DateTime(now.year, now.month, now.day),
              ) &&
              previousIndex == -1) {
            // Add to previous list if it's from past and not already there
            updatedPreviousTodos.add(updatedTodo);
          }
        }
      }

      // Calculate the new completed count (for today's tasks only)
      final completedCount =
          updatedTodos.where((todo) => todo.status == 2).length;

      state = state.copyWith(
        todos: updatedTodos,
        previousTodos: updatedPreviousTodos,
        completedCount: completedCount,
      );
    });
  }

  // Toggle a subtask's completion status
  Future<void> toggleSubtaskStatus(SubtaskModel subtask) async {
    await runAsync('toggleSubtaskStatus', () async {
      // Update subtask via service
      final updatedSubtask = await _todoService.updateSubtaskStatus(
        subtask,
        !subtask.isCompleted,
      );

      // Update local state without reloading all todos
      List<TodoModel> updatedTodos = List<TodoModel>.from(state.todos);
      List<TodoModel> updatedPreviousTodos = List<TodoModel>.from(
        state.previousTodos,
      );

      // Check if subtask is in today's todos
      final todoIndex = updatedTodos.indexWhere(
        (t) =>
            t.id == subtask.todoId && t.subtasks.any((s) => s.id == subtask.id),
      );

      // Check if subtask is in previous todos
      final previousTodoIndex = updatedPreviousTodos.indexWhere(
        (t) =>
            t.id == subtask.todoId && t.subtasks.any((s) => s.id == subtask.id),
      );

      // Update subtask in today's todos if found
      if (todoIndex != -1) {
        final todo = updatedTodos[todoIndex];

        // Create new subtasks list with updated subtask
        final updatedSubtasks =
            todo.subtasks.map((s) {
              return s.id == subtask.id ? updatedSubtask : s;
            }).toList();

        // Replace todo with updated version
        updatedTodos[todoIndex] = todo.copyWith(subtasks: updatedSubtasks);
      }

      // Update subtask in previous todos if found
      if (previousTodoIndex != -1) {
        final todo = updatedPreviousTodos[previousTodoIndex];

        // Create new subtasks list with updated subtask
        final updatedSubtasks =
            todo.subtasks.map((s) {
              return s.id == subtask.id ? updatedSubtask : s;
            }).toList();

        // Replace todo with updated version
        updatedPreviousTodos[previousTodoIndex] = todo.copyWith(
          subtasks: updatedSubtasks,
        );
      }

      // Calculate the new completed count (for today's tasks only)
      final completedCount =
          updatedTodos.where((todo) => todo.status == 2).length;

      // Update state with both updated lists
      state = state.copyWith(
        todos: updatedTodos,
        previousTodos: updatedPreviousTodos,
        completedCount: completedCount,
      );
    });
  }

  // Fetch Data
  Future<void> fetchTasks() async {
    state = state.copyWith(isLoading: true);

    await runAsync('fetchTasks', () async {
      try {
        // Get tasks for today
        final todayTodos = await _todoService.getTodosForToday();

        // Get previous tasks
        final previousTodos = await _todoService.getPreviousTodos();

        // Update state
        state = state.copyWith(
          todos: todayTodos,
          previousTodos: previousTodos,
          isLoading: false,
          clearError: true,
        );
      } catch (e, stackTrace) {
        state = state.copyWith(
          isLoading: false,
          error: e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  // Silent refresh - tidak mengubah UI loading state
  Future<void> silentRefresh() async {
    // Jika sedang refresh atau loading, abaikan
    if (state.isRefreshing || state.isLoading) return;

    // Set refresh state tapi tidak mempengaruhi isLoading
    state = state.copyWith(isRefreshing: true);

    await runAsync('silentRefresh', () async {
      try {
        // Ambil data terbaru di background
        final todayTodos = await _todoService.getTodosForToday();
        final previousTodos = await _todoService.getPreviousTodos();

        // Update state tanpa merubah loading state
        state = state.copyWith(
          todos: todayTodos,
          previousTodos: previousTodos,
          isRefreshing: false,
          clearError: true,
        );
      } catch (e) {
        // Silent error handling - error tidak ditampilkan di UI
        state = state.copyWith(isRefreshing: false);
      }
    });
  }

  // Delete a todo
  Future<void> deleteTodo(TodoModel todo) async {
    await runAsync('deleteTodo', () async {
      try {
        // Delete the todo via service
        await _todoService.deleteTodo(todo);

        // Update state by removing the todo
        List<TodoModel> updatedTodos = List.from(state.todos);
        List<TodoModel> updatedPreviousTodos = List.from(state.previousTodos);

        // Remove from today's todos if present
        updatedTodos.removeWhere((t) => t.id == todo.id);

        // Remove from previous todos if present
        updatedPreviousTodos.removeWhere((t) => t.id == todo.id);

        // Calculate the new completed count
        final completedCount =
            updatedTodos.where((todo) => todo.status == 2).length;

        state = state.copyWith(
          todos: updatedTodos,
          previousTodos: updatedPreviousTodos,
          completedCount: completedCount,
          clearError: true,
        );
      } catch (e, stackTrace) {
        state = state.copyWith(error: e, stackTrace: stackTrace);
      }
    });
  }
}
