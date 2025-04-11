import '../../../../core/base/base_network.dart';
import '../db/db_local.dart';
import '../services/init_data_service.dart';

class OnboardingService extends BaseService {
  final DBLocal _db;
  final InitDataService _initDataService;

  OnboardingService({
    required DBLocal db,
    required InitDataService initDataService,
  }) : _db = db,
       _initDataService = initDataService;

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

          // Initialize sample data using InitDataService
          await _initDataService.initializeData();

          logger.d(
            'Database initialized successfully with sample data',
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
