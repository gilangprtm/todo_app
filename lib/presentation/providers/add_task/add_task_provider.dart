import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_providers.dart';
import 'add_task_notifier.dart';
import 'add_task_state.dart';

/// Provider untuk form Add Task
final addTaskProvider = StateNotifierProvider<AddTaskNotifier, AddTaskState>((
  ref,
) {
  final todoService = ref.watch(todoServiceProvider);
  return AddTaskNotifier(AddTaskState(), ref, todoService);
});
