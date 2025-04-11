import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasource/local/repositories/todo_repository.dart';
import 'service_providers.dart';

// Repository providers
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final db = ref.watch(dbProvider);
  return TodoRepository(db);
});
