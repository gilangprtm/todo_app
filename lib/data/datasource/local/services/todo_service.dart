import '../../../../core/base/base_network.dart';
import '../../../models/subtask_model.dart';
import '../../../models/tag_model.dart';
import '../../../models/todo_model.dart';
import '../repositories/todo_repository.dart';

class TodoService extends BaseService {
  final TodoRepository _repository;

  TodoService(this._repository);

  // Get todos for today
  Future<List<TodoModel>> getTodosForToday() async {
    return await performanceAsync(
      operationName: 'get_todos_for_today',
      function: () async {
        final todoMaps = await _repository.fetchTodosForToday();
        final todos = todoMaps.map((map) => TodoModel.fromMap(map)).toList();
        return await _enrichTodosWithRelations(todos);
      },
      tag: 'TodoService',
    );
  }

  // Get todos for a specific date
  Future<List<TodoModel>> getTodosForDate(DateTime date) async {
    return await performanceAsync(
      operationName: 'get_todos_for_date',
      function: () async {
        final todoMaps = await _repository.fetchTodosForDate(date);
        final todos = todoMaps.map((map) => TodoModel.fromMap(map)).toList();
        return await _enrichTodosWithRelations(todos);
      },
      tag: 'TodoService',
    );
  }

  // Get previous unfinished todos
  Future<List<TodoModel>> getPreviousTodos() async {
    return await performanceAsync(
      operationName: 'get_previous_todos',
      function: () async {
        final todoMaps = await _repository.fetchPreviousTodos();
        final todos = todoMaps.map((map) => TodoModel.fromMap(map)).toList();
        return await _enrichTodosWithRelations(todos);
      },
      tag: 'TodoService',
    );
  }

  // Update todo status
  Future<TodoModel> updateTodoStatus(TodoModel todo, int newStatus) async {
    return await performanceAsync(
      operationName: 'update_todo_status',
      function: () async {
        if (todo.id == null) {
          throw Exception("Cannot update todo without ID");
        }

        await _repository.updateTodoStatus(todo.id!, newStatus);

        // Return updated todo
        final updatedTodo = todo.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );

        return updatedTodo;
      },
      tag: 'TodoService',
    );
  }

  // Update subtask status
  Future<SubtaskModel> updateSubtaskStatus(
    SubtaskModel subtask,
    bool isCompleted,
  ) async {
    return await performanceAsync(
      operationName: 'update_subtask_status',
      function: () async {
        if (subtask.id == null) {
          throw Exception("Cannot update subtask without ID");
        }

        await _repository.updateSubtaskStatus(subtask.id!, isCompleted);

        // Return updated subtask
        final updatedSubtask = subtask.copyWith(
          isCompleted: isCompleted,
          updatedAt: DateTime.now(),
        );

        return updatedSubtask;
      },
      tag: 'TodoService',
    );
  }

  // Helper method to enrich todos with subtasks and tags
  Future<List<TodoModel>> _enrichTodosWithRelations(
    List<TodoModel> todos,
  ) async {
    List<TodoModel> enrichedTodos = [];

    for (var todo in todos) {
      if (todo.id == null) {
        enrichedTodos.add(todo);
        continue;
      }

      // Get subtasks
      final subtaskMaps = await _repository.fetchSubtasksForTodo(todo.id!);
      final subtasks =
          subtaskMaps.map((map) => SubtaskModel.fromMap(map)).toList();

      // Get tags
      final tagMaps = await _repository.fetchTagsForTodo(todo.id!);
      final tags = tagMaps.map((map) => TagModel.fromMap(map)).toList();

      // Add enriched todo
      enrichedTodos.add(todo.copyWith(subtasks: subtasks, tags: tags));
    }

    return enrichedTodos;
  }
}
