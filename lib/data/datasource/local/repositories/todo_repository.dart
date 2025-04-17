import '../../../../core/base/base_network.dart';
import '../db/db_local.dart';

class TodoRepository extends BaseRepository {
  final DBLocal _db;

  TodoRepository(this._db);

  // Fetch all todos for calendar view
  Future<List<Map<String, dynamic>>> fetchAllTodos() async {
    try {
      // Get all tasks regardless of date or status using queryAll
      return await _db.queryAll(DBLocal.tableTodo);
    } catch (e, stackTrace) {
      logError(
        'Error fetching all todos',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch todos for today
  Future<List<Map<String, dynamic>>> fetchTodosForToday() async {
    try {
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

      // Tidak memfilter berdasarkan status agar semua task terambil
      String whereClause = 'due_date >= ? AND due_date <= ?';
      List<dynamic> whereArgs = [startOfDay, endOfDay];

      return await _db.queryWhere(DBLocal.tableTodo, whereClause, whereArgs);
    } catch (e, stackTrace) {
      logError(
        'Error fetching todos for today',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch todos for a specific date
  Future<List<Map<String, dynamic>>> fetchTodosForDate(DateTime date) async {
    try {
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

      String whereClause = 'due_date >= ? AND due_date <= ?';
      List<dynamic> whereArgs = [startOfDay, endOfDay];

      return await _db.queryWhere(DBLocal.tableTodo, whereClause, whereArgs);
    } catch (e, stackTrace) {
      logError(
        'Error fetching todos for date: ${date.toString()}',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch previous incomplete todos
  Future<List<Map<String, dynamic>>> fetchPreviousTodos() async {
    try {
      final today = DateTime.now();
      final startOfDay =
          DateTime(today.year, today.month, today.day).toIso8601String();

      // Get tasks with due date before today and not completed
      String whereClause = 'due_date < ? AND status != 2';
      List<dynamic> whereArgs = [startOfDay];

      return await _db.queryWhere(DBLocal.tableTodo, whereClause, whereArgs);
    } catch (e, stackTrace) {
      logError(
        'Error fetching previous todos',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch subtasks for a todo
  Future<List<Map<String, dynamic>>> fetchSubtasksForTodo(int todoId) async {
    try {
      return await _db.queryWhere(DBLocal.tableSubtask, 'todo_id = ?', [
        todoId,
      ]);
    } catch (e, stackTrace) {
      logError(
        'Error fetching subtasks for todo $todoId',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch tags for a todo
  Future<List<Map<String, dynamic>>> fetchTagsForTodo(int todoId) async {
    try {
      return await _db.rawQuery(
        '''
        SELECT t.* FROM ${DBLocal.tableTag} t
        INNER JOIN ${DBLocal.tableTodoTag} tt ON t.id = tt.tag_id
        WHERE tt.todo_id = ?
        ''',
        [todoId],
      );
    } catch (e, stackTrace) {
      logError(
        'Error fetching tags for todo $todoId',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Update todo status
  Future<void> updateTodoStatus(int todoId, int newStatus) async {
    try {
      await _db.update(
        DBLocal.tableTodo,
        {'status': newStatus, 'updated_at': DateTime.now().toIso8601String()},
        'id = ?',
        [todoId],
      );
      logInfo(
        'Todo status updated successfully: $todoId -> $newStatus',
        tag: 'TodoRepository',
      );
    } catch (e, stackTrace) {
      logError(
        'Error updating todo status for todo $todoId',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Update subtask status
  Future<void> updateSubtaskStatus(int subtaskId, bool isCompleted) async {
    try {
      await _db.update(
        DBLocal.tableSubtask,
        {
          'is_completed': isCompleted ? 1 : 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        'id = ?',
        [subtaskId],
      );
      logInfo(
        'Subtask status updated successfully: $subtaskId -> $isCompleted',
        tag: 'TodoRepository',
      );
    } catch (e, stackTrace) {
      logError(
        'Error updating subtask status for subtask $subtaskId',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch todos for a specific date range
  Future<List<Map<String, dynamic>>> fetchTodosForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final startDateIso = startDate.toIso8601String();
      final endDateIso = endDate.toIso8601String();

      String whereClause = 'due_date >= ? AND due_date <= ?';
      List<dynamic> whereArgs = [startDateIso, endDateIso];

      return await _db.queryWhere(DBLocal.tableTodo, whereClause, whereArgs);
    } catch (e, stackTrace) {
      logError(
        'Error fetching todos for date range: ${startDate.toString()} to ${endDate.toString()}',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch todo by ID
  Future<List<Map<String, dynamic>>> fetchTodoById(int todoId) async {
    try {
      return await _db.queryWhere(DBLocal.tableTodo, 'id = ?', [todoId]);
    } catch (e, stackTrace) {
      logError(
        'Error fetching todo by ID: $todoId',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Insert new todo
  Future<int> insertTodo(Map<String, dynamic> todoMap) async {
    try {
      // Set created_at and updated_at if not provided
      if (!todoMap.containsKey('created_at')) {
        todoMap['created_at'] = DateTime.now().toIso8601String();
      }
      if (!todoMap.containsKey('updated_at')) {
        todoMap['updated_at'] = DateTime.now().toIso8601String();
      }

      final id = await _db.insert(DBLocal.tableTodo, todoMap);
      logInfo('Todo inserted successfully with ID: $id', tag: 'TodoRepository');
      return id;
    } catch (e, stackTrace) {
      logError(
        'Error inserting todo',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Insert new subtask
  Future<int> insertSubtask(Map<String, dynamic> subtaskMap) async {
    try {
      // Set created_at and updated_at if not provided
      if (!subtaskMap.containsKey('created_at')) {
        subtaskMap['created_at'] = DateTime.now().toIso8601String();
      }
      if (!subtaskMap.containsKey('updated_at')) {
        subtaskMap['updated_at'] = DateTime.now().toIso8601String();
      }

      final id = await _db.insert(DBLocal.tableSubtask, subtaskMap);
      logInfo(
        'Subtask inserted successfully with ID: $id',
        tag: 'TodoRepository',
      );
      return id;
    } catch (e, stackTrace) {
      logError(
        'Error inserting subtask',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Link todo with tag
  Future<void> linkTodoWithTag(int todoId, int tagId) async {
    try {
      await _db.insert(DBLocal.tableTodoTag, {
        'todo_id': todoId,
        'tag_id': tagId,
        'created_at': DateTime.now().toIso8601String(),
      });
      logInfo(
        'Todo-Tag relationship created: Todo $todoId -> Tag $tagId',
        tag: 'TodoRepository',
      );
    } catch (e, stackTrace) {
      logError(
        'Error linking todo with tag: Todo $todoId -> Tag $tagId',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Fetch all tags
  Future<List<Map<String, dynamic>>> fetchAllTags() async {
    try {
      return await _db.queryAll(DBLocal.tableTag);
    } catch (e, stackTrace) {
      logError(
        'Error fetching all tags',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }

  // Insert new tag
  Future<int> insertTag(Map<String, dynamic> tagMap) async {
    try {
      // Set created_at if not provided
      if (!tagMap.containsKey('created_at')) {
        tagMap['created_at'] = DateTime.now().toIso8601String();
      }

      final id = await _db.insert(DBLocal.tableTag, tagMap);
      logInfo('Tag inserted successfully with ID: $id', tag: 'TodoRepository');
      return id;
    } catch (e, stackTrace) {
      logError(
        'Error inserting tag',
        error: e,
        stackTrace: stackTrace,
        tag: 'TodoRepository',
      );
      rethrow;
    }
  }
}
