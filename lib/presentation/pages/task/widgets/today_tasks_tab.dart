import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/task/task_provider.dart';
import '../../../widgets/task_item_widget.dart';
import 'task_list_header_widget.dart';
import 'task_empty_widget.dart';
import 'task_loading_error_widget.dart';

class TodayTasksTab extends ConsumerWidget {
  const TodayTasksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch the specific parts of state we need
    final isLoading = ref.watch(
      taskProvider.select((state) => state.isLoading),
    );
    final error = ref.watch(taskProvider.select((state) => state.error));
    final todos = ref.watch(taskProvider.select((state) => state.todos));

    // Separate completed and non-completed tasks
    final completedTodos = todos.where((todo) => todo.status == 2).toList();
    final activeTodos = todos.where((todo) => todo.status != 2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Task list header
        const TaskListHeaderWidget(),

        const SizedBox(height: 16),

        // Loading state
        if (isLoading)
          const Expanded(child: Center(child: CircularProgressIndicator())),

        // Error state
        if (!isLoading && error != null)
          const Expanded(child: TaskLoadingErrorWidget()),

        // Empty state
        if (!isLoading && error == null && todos.isEmpty)
          const Expanded(child: TaskEmptyWidget()),

        // Task list - note: this only rebuilds when the todos list changes
        if (!isLoading && error == null && todos.isNotEmpty)
          Expanded(
            child: ListView(
              children: [
                // Active tasks section
                if (activeTodos.isNotEmpty) ...[
                  // Active tasks
                  ...activeTodos.map(
                    (todo) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Consumer(
                        builder: (context, ref, _) {
                          return TaskItemWidget(
                            todo: todo,
                            onToggleStatus: () {
                              ref
                                  .read(taskProvider.notifier)
                                  .toggleTodoStatus(todo);
                            },
                            onToggleSubtask: (subtask) {
                              ref
                                  .read(taskProvider.notifier)
                                  .toggleSubtaskStatus(subtask);
                            },
                            showSubtasks: true,
                            simplifiedView: false,
                          );
                        },
                      ),
                    ),
                  ),
                ],

                // Completed tasks section
                if (completedTodos.isNotEmpty) ...[
                  // Section header for completed tasks
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 12),
                    child: Row(
                      children: [
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getTextSecondaryColor(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successColor.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${completedTodos.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.successColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Completed tasks
                  ...completedTodos.map(
                    (todo) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Consumer(
                        builder: (context, ref, _) {
                          return TaskItemWidget(
                            todo: todo,
                            onToggleStatus: () {
                              ref
                                  .read(taskProvider.notifier)
                                  .toggleTodoStatus(todo);
                            },
                            onToggleSubtask: (subtask) {
                              ref
                                  .read(taskProvider.notifier)
                                  .toggleSubtaskStatus(subtask);
                            },
                            showSubtasks: true,
                            simplifiedView: false,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
