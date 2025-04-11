import '../../../../core/base/base_network.dart';
import '../db/db_local.dart';

class OnboardingService extends BaseService {
  final DBLocal _db;

  OnboardingService({required DBLocal db}) : _db = db;

  Future<void> initializeDatabase() async {
    try {
      await performanceAsync(
        operationName: 'initialize_database',
        function: () async {
          // Initialize database tables
          await _db.database;

          // Create default settings
          await _db.saveSetting('theme_mode', 'light');
          await _db.saveSetting('first_run', 'false');

          // Create a sample todo to ensure we have data in the todo table
          final now = DateTime.now();
          final nowString = now.toIso8601String();

          await _db.insert(DBLocal.tableTodo, {
            'title': 'Welcome to Todo App!',
            'description':
                'This is your first todo item. Tap to edit or complete it.',
            'due_date': now.add(const Duration(days: 1)).toIso8601String(),
            'priority': 1,
            'status': 0,
            'created_at': nowString,
            'updated_at': nowString,
          });

          logger.d(
            'Database initialized successfully',
            tag: 'OnboardingService',
          );
        },
        tag: 'OnboardingService',
      );
    } catch (e, stackTrace) {
      logger.e(
        'Error initializing database',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnboardingService',
      );
      rethrow;
    }
  }

  Future<void> saveSetting(String key, String value) async {
    try {
      await performanceAsync(
        operationName: 'save_setting',
        function: () async {
          await _db.saveSetting(key, value);

          logger.d(
            'Setting saved successfully: $key = $value',
            tag: 'OnboardingService',
          );
        },
        tag: 'OnboardingService',
      );
    } catch (e, stackTrace) {
      logger.e(
        'Error saving setting: $key',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnboardingService',
      );
      rethrow;
    }
  }

  Future<String?> getSetting(String key) async {
    try {
      return await performanceAsync(
        operationName: 'get_setting',
        function: () async {
          final value = await _db.getSetting(key);
          logger.d(
            'Setting retrieved: $key = $value',
            tag: 'OnboardingService',
          );
          return value;
        },
        tag: 'OnboardingService',
      );
    } catch (e, stackTrace) {
      logger.e(
        'Error getting setting: $key',
        error: e,
        stackTrace: stackTrace,
        tag: 'OnboardingService',
      );
      rethrow;
    }
  }
}
