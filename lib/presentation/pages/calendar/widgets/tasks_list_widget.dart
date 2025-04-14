import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/calendar/calendar_provider.dart';
import '../../../widgets/task_item_widget.dart';
import 'empty_tasks_widget.dart';

class TasksListWidget extends ConsumerWidget {
  const TasksListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);
    final selectedDayTasks = calendarState.selectedDayTasks;
    final isLoading = calendarState.isLoading;
    final isInitialized = calendarState.isInitialized;

    // Initialize the calendar only if not initialized yet
    if (!isLoading && !isInitialized) {
      Future.microtask(() {
        if (!ref.read(calendarProvider).isInitialized) {
          ref.read(calendarProvider.notifier).fetchTasks();
        }
      });
    }

    if (isLoading) {
      // Tampilkan full loading hanya saat pertama kali inisialisasi
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (selectedDayTasks.isEmpty) {
      return EmptyTasksWidget(
        scrollController: ref.read(calendarProvider.notifier).scrollController,
      );
    } else {
      return Expanded(
        child: ListView.separated(
          controller: ref.read(calendarProvider.notifier).scrollController,
          itemCount: selectedDayTasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final task = selectedDayTasks[index];
            return TaskItemWidget(
              todo: task,
              onToggleStatus: () {
                ref.read(calendarProvider.notifier).toggleTodoStatus(task);
              },
              onToggleSubtask: (subtask) {
                ref
                    .read(calendarProvider.notifier)
                    .toggleSubtaskStatus(subtask);
              },
              showSubtasks: true,
              simplifiedView: false,
            );
          },
        ),
      );
    }
  }
}
