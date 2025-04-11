import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_color.dart';
import '../../providers/task/task_provider.dart';
import 'widgets/task_header_widget.dart';
import 'widgets/task_progress_widget.dart';
import 'widgets/task_list_header_widget.dart';
import 'widgets/task_item_widget.dart';
import 'widgets/task_empty_widget.dart';
import 'widgets/task_loading_error_widget.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Consumer(
            builder: (context, ref, child) {
              final state = ref.watch(taskProvider);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with date, greeting and avatar
                  const TaskHeaderWidget(),

                  const SizedBox(height: 24),

                  // Today's tasks progress section
                  const TaskProgressWidget(),

                  const SizedBox(height: 24),

                  // Task list header
                  const TaskListHeaderWidget(),

                  const SizedBox(height: 16),

                  // Loading and error states
                  const TaskLoadingErrorWidget(),

                  // Empty state
                  if (!state.isLoading &&
                      state.error == null &&
                      state.todos.isEmpty)
                    const Expanded(child: TaskEmptyWidget()),

                  // Task list
                  if (!state.isLoading &&
                      state.error == null &&
                      state.todos.isNotEmpty)
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.todos.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final todo = state.todos[index];
                          return TaskItemWidget(todo: todo);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
