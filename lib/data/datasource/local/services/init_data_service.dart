import '../../../../core/base/base_network.dart';
import '../db/db_local.dart';
import '../../../models/todo_model.dart';
import '../../../models/tag_model.dart';
import '../../../models/subtask_model.dart';

/// Service untuk inisialisasi data contoh aplikasi
class InitDataService extends BaseService {
  final DBLocal _db;

  InitDataService({required DBLocal db}) : _db = db;

  /// Memeriksa apakah data sudah diinisialisasi
  Future<bool> isDataInitialized() async {
    try {
      // Periksa apakah ada tag
      final tags = await _db.queryAll(DBLocal.tableTag);
      return tags.isNotEmpty;
    } catch (e) {
      logger.e('Error checking if data is initialized: $e');
      return false;
    }
  }

  /// Menginisialisasi data contoh untuk aplikasi
  Future<void> initializeData() async {
    try {
      if (await isDataInitialized()) {
        logger.d('Data already initialized', tag: 'InitDataService');
        return;
      }

      await performanceAsync(
        operationName: 'initialize_data',
        function: () async {
          logger.d('Initializing sample data...', tag: 'InitDataService');

          // 1. Create sample tags
          await _initializeTags();

          // 2. Create sample todos with subtasks
          await _initializeTodos();

          logger.d(
            'Sample data initialized successfully',
            tag: 'InitDataService',
          );
        },
        tag: 'InitDataService',
      );
    } catch (e, stackTrace) {
      logger.e(
        'Error initializing sample data',
        error: e,
        stackTrace: stackTrace,
        tag: 'InitDataService',
      );
      rethrow;
    }
  }

  /// Inisialisasi data tag contoh
  Future<void> _initializeTags() async {
    final sampleTags = [
      TagModel(name: 'Work', color: '#FF5733'),
      TagModel(name: 'Personal', color: '#33FF57'),
      TagModel(name: 'Urgent', color: '#FF3366'),
      TagModel(name: 'Study', color: '#3366FF'),
      TagModel(name: 'Health', color: '#33FFEC'),
      TagModel(name: 'Shopping', color: '#EC33FF'),
    ];

    for (var tag in sampleTags) {
      await _db.insert(DBLocal.tableTag, tag.toMap());
    }
  }

  /// Inisialisasi data todo contoh
  Future<void> _initializeTodos() async {
    // Get tags for reference
    final tagsMap = await _db.queryAll(DBLocal.tableTag);
    final tags = tagsMap.map((map) => TagModel.fromMap(map)).toList();

    // Sample todos
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final nextWeek = DateTime(now.year, now.month, now.day + 7);

    final sampleTodos = [
      // Todo 1: Work task due today
      TodoModel(
        title: 'Complete project proposal',
        description: 'Finalize the budget and timeline for the Q3 project',
        dueDate: now,
        priority: 2, // High
        status: 0, // Pending
      ),

      // Todo 2: Study task due tomorrow
      TodoModel(
        title: 'Study for Flutter exam',
        description: 'Review state management and navigation concepts',
        dueDate: tomorrow,
        priority: 1, // Medium
        status: 0, // Pending
      ),

      // Todo 3: Personal task due next week
      TodoModel(
        title: 'Plan weekend trip',
        description: 'Research accommodations and activities',
        dueDate: nextWeek,
        priority: 0, // Low
        status: 0, // Pending
      ),

      // Todo 4: Health task due today
      TodoModel(
        title: 'Go for a 30-minute run',
        description: 'Try to beat yesterday\'s time',
        dueDate: now,
        priority: 1, // Medium
        status: 0, // Pending
      ),

      // Todo 5: Shopping due tomorrow
      TodoModel(
        title: 'Buy groceries',
        description: 'Get ingredients for dinner party',
        dueDate: tomorrow,
        priority: 1, // Medium
        status: 0, // Pending
      ),
    ];

    // Associate todos with tags and subtasks
    for (var i = 0; i < sampleTodos.length; i++) {
      final todo = sampleTodos[i];
      final todoId = await _db.insert(DBLocal.tableTodo, todo.toMap());

      // Associate with appropriate tags
      switch (i) {
        case 0: // Work task
          await _associateTodoWithTag(
            todoId,
            tags.firstWhere((tag) => tag.name == 'Work').id!,
          );
          await _associateTodoWithTag(
            todoId,
            tags.firstWhere((tag) => tag.name == 'Urgent').id!,
          );
          await _addSubtasksForWorkTodo(todoId);
          break;
        case 1: // Study task
          await _associateTodoWithTag(
            todoId,
            tags.firstWhere((tag) => tag.name == 'Study').id!,
          );
          await _addSubtasksForStudyTodo(todoId);
          break;
        case 2: // Personal task
          await _associateTodoWithTag(
            todoId,
            tags.firstWhere((tag) => tag.name == 'Personal').id!,
          );
          await _addSubtasksForTripTodo(todoId);
          break;
        case 3: // Health task
          await _associateTodoWithTag(
            todoId,
            tags.firstWhere((tag) => tag.name == 'Health').id!,
          );
          await _associateTodoWithTag(
            todoId,
            tags.firstWhere((tag) => tag.name == 'Personal').id!,
          );
          break;
        case 4: // Shopping task
          await _associateTodoWithTag(
            todoId,
            tags.firstWhere((tag) => tag.name == 'Shopping').id!,
          );
          await _addSubtasksForShoppingTodo(todoId);
          break;
      }
    }
  }

  /// Associate a todo with a tag
  Future<void> _associateTodoWithTag(int todoId, int tagId) async {
    final now = DateTime.now();
    await _db.insert(DBLocal.tableTodoTag, {
      'todo_id': todoId,
      'tag_id': tagId,
      'created_at': now.toIso8601String(),
    });
  }

  /// Add subtasks for work todo
  Future<void> _addSubtasksForWorkTodo(int todoId) async {
    final subtasks = [
      SubtaskModel(todoId: todoId, title: 'Draft executive summary'),
      SubtaskModel(todoId: todoId, title: 'Create budget spreadsheet'),
      SubtaskModel(todoId: todoId, title: 'Get approval from manager'),
    ];

    for (var subtask in subtasks) {
      await _db.insert(DBLocal.tableSubtask, subtask.toMap());
    }
  }

  /// Add subtasks for study todo
  Future<void> _addSubtasksForStudyTodo(int todoId) async {
    final subtasks = [
      SubtaskModel(todoId: todoId, title: 'Review Provider pattern'),
      SubtaskModel(todoId: todoId, title: 'Practice with Navigator 2.0'),
      SubtaskModel(todoId: todoId, title: 'Complete practice exercises'),
    ];

    for (var subtask in subtasks) {
      await _db.insert(DBLocal.tableSubtask, subtask.toMap());
    }
  }

  /// Add subtasks for trip todo
  Future<void> _addSubtasksForTripTodo(int todoId) async {
    final subtasks = [
      SubtaskModel(todoId: todoId, title: 'Book hotel'),
      SubtaskModel(todoId: todoId, title: 'Make restaurant reservations'),
      SubtaskModel(todoId: todoId, title: 'Plan activities'),
      SubtaskModel(todoId: todoId, title: 'Pack luggage'),
    ];

    for (var subtask in subtasks) {
      await _db.insert(DBLocal.tableSubtask, subtask.toMap());
    }
  }

  /// Add subtasks for shopping todo
  Future<void> _addSubtasksForShoppingTodo(int todoId) async {
    final subtasks = [
      SubtaskModel(todoId: todoId, title: 'Fruits and vegetables'),
      SubtaskModel(todoId: todoId, title: 'Meat and dairy'),
      SubtaskModel(todoId: todoId, title: 'Beverages'),
      SubtaskModel(todoId: todoId, title: 'Snacks'),
    ];

    for (var subtask in subtasks) {
      await _db.insert(DBLocal.tableSubtask, subtask.toMap());
    }
  }
}
