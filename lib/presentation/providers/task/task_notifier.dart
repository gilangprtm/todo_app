import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/base/base_state_notifier.dart';
import '../../../data/datasource/local/db/db_local.dart';
import '../../../data/models/subtask_model.dart';
import '../../../data/models/tag_model.dart';
import '../../../data/models/todo_model.dart';
import 'task_state.dart';

class TaskNotifier extends BaseStateNotifier<TaskState> {
  final DBLocal _db;

  TaskNotifier(super.initialState, super.ref, this._db);

  @override
  Future<void> onInit() async {
    await loadTodos();
  }

  // Load todos from the database
  Future<void> loadTodos() async {
    await runAsync('loadTodos', () async {
      state = state.copyWith(isLoading: true);

      try {
        final todos = await _fetchTodos();
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

      // Update the database
      final updatedTodo = todo.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );

      await _db.update(DBLocal.tableTodo, updatedTodo.toMap(), 'id = ?', [
        todo.id,
      ]);

      // Update local state without reloading all todos
      final index = state.todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        final updatedTodos = List<TodoModel>.from(state.todos);
        updatedTodos[index] = updatedTodo.copyWith(
          subtasks: state.todos[index].subtasks,
          tags: state.todos[index].tags,
        );

        // Calculate the new completed count
        final completedCount =
            updatedTodos.where((todo) => todo.status == 2).length;

        state = state.copyWith(
          todos: updatedTodos,
          completedCount: completedCount,
        );
      }
    });
  }

  // Toggle a subtask's completion status
  Future<void> toggleSubtaskStatus(SubtaskModel subtask) async {
    await runAsync('toggleSubtaskStatus', () async {
      // Create updated subtask
      final updatedSubtask = subtask.copyWith(
        isCompleted: !subtask.isCompleted,
        updatedAt: DateTime.now(),
      );

      // Update in database
      await _db.update(DBLocal.tableSubtask, updatedSubtask.toMap(), 'id = ?', [
        subtask.id,
      ]);

      // Update local state without reloading all todos
      final todoIndex = state.todos.indexWhere((t) => t.id == subtask.todoId);
      if (todoIndex != -1) {
        final updatedTodos = List<TodoModel>.from(state.todos);
        final todo = updatedTodos[todoIndex];

        // Find and update the subtask
        final subtasks = List<SubtaskModel>.from(todo.subtasks);
        final subtaskIndex = subtasks.indexWhere((s) => s.id == subtask.id);

        if (subtaskIndex != -1) {
          subtasks[subtaskIndex] = updatedSubtask;

          // Update the todo with updated subtasks
          updatedTodos[todoIndex] = todo.copyWith(subtasks: subtasks);

          // Calculate the new completed count (completedCount is for todos, not subtasks)
          final completedCount =
              updatedTodos.where((todo) => todo.status == 2).length;

          state = state.copyWith(
            todos: updatedTodos,
            completedCount: completedCount,
          );
        }
      }
    });
  }

  // Fetch todos with their subtasks and tags
  Future<List<TodoModel>> _fetchTodos() async {
    try {
      // Get base todo items
      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (state.filterByToday) {
        final today = DateTime.now();
        final startOfDay =
            DateTime(today.year, today.month, today.day).toIso8601String();
        final endOfDay =
            DateTime(
              today.year,
              today.month,
              today.day,
              23,
              59,
              59,
            ).toIso8601String();

        whereClause = 'due_date >= ? AND due_date <= ?';
        whereArgs = [startOfDay, endOfDay];
      } else if (state.selectedDate != null) {
        final date = state.selectedDate;
        final startOfDay =
            DateTime(date.year, date.month, date.day).toIso8601String();
        final endOfDay =
            DateTime(
              date.year,
              date.month,
              date.day,
              23,
              59,
              59,
            ).toIso8601String();

        whereClause = 'due_date >= ? AND due_date <= ?';
        whereArgs = [startOfDay, endOfDay];
      }

      List<Map<String, dynamic>> todoMaps;
      if (whereClause.isNotEmpty) {
        todoMaps = await _db.queryWhere(
          DBLocal.tableTodo,
          whereClause,
          whereArgs,
        );
      } else {
        todoMaps = await _db.queryAll(DBLocal.tableTodo);
      }

      // Convert to TodoModels
      List<TodoModel> todos =
          todoMaps.map((map) => TodoModel.fromMap(map)).toList();

      // For each todo, get subtasks and tags
      List<TodoModel> enrichedTodos = [];
      for (var todo in todos) {
        final subtasks = await _getSubtasksForTodo(todo.id!);
        final tags = await _getTagsForTodo(todo.id!);

        enrichedTodos.add(todo.copyWith(subtasks: subtasks, tags: tags));
      }

      return enrichedTodos;
    } catch (e, stackTrace) {
      logger.e(
        'Error fetching todos',
        error: e,
        stackTrace: stackTrace,
        tag: 'TaskNotifier',
      );
      rethrow;
    }
  }

  // Get subtasks for a specific todo
  Future<List<SubtaskModel>> _getSubtasksForTodo(int todoId) async {
    try {
      final subtaskMaps = await _db.queryWhere(
        DBLocal.tableSubtask,
        'todo_id = ?',
        [todoId],
      );

      return subtaskMaps.map((map) => SubtaskModel.fromMap(map)).toList();
    } catch (e) {
      logger.e(
        'Error fetching subtasks for todo $todoId',
        error: e,
        tag: 'TaskNotifier',
      );
      return [];
    }
  }

  // Get tags for a specific todo
  Future<List<TagModel>> _getTagsForTodo(int todoId) async {
    try {
      final tagMaps = await _db.rawQuery(
        '''
        SELECT t.* FROM ${DBLocal.tableTag} t
        INNER JOIN ${DBLocal.tableTodoTag} tt ON t.id = tt.tag_id
        WHERE tt.todo_id = ?
      ''',
        [todoId],
      );

      return tagMaps.map((map) => TagModel.fromMap(map)).toList();
    } catch (e) {
      logger.e(
        'Error fetching tags for todo $todoId',
        error: e,
        tag: 'TaskNotifier',
      );
      return [];
    }
  }
}
