import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasource/local/db/db_local.dart';
import '../../data/datasource/local/services/onboarding_service.dart';
import '../../data/datasource/local/services/init_data_service.dart';
import '../../data/datasource/local/services/theme_service.dart';
import '../../data/datasource/local/services/todo_service.dart';
import 'repository_providers.dart';

// Create a shared DBLocal instance for all services
final dbProvider = Provider<DBLocal>((ref) => DBLocal());

final initDataServiceProvider = Provider<InitDataService>((ref) {
  final db = ref.watch(dbProvider);
  return InitDataService(db: db);
});

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final db = ref.watch(dbProvider);
  final initDataService = ref.watch(initDataServiceProvider);
  return OnboardingService(db: db, initDataService: initDataService);
});

// Todo service provider
final todoServiceProvider = Provider<TodoService>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return TodoService(repository);
});

// Theme service provider
final themeServiceProvider = Provider<ThemeService>((ref) {
  final db = ref.watch(dbProvider);
  return ThemeService(db: db);
});
