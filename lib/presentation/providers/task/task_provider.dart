import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_providers.dart';
import 'task_notifier.dart';
import 'task_state.dart';

/// Provider for Task Screen
final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return TaskNotifier(TaskState(), ref, todoService);
});
