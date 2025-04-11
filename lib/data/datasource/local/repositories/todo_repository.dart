import '../../../../core/base/base_network.dart';
import '../db/db_local.dart';

class TodoRepository extends BaseRepository {
  final DBLocal _db;

  TodoRepository(this._db);

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
}
