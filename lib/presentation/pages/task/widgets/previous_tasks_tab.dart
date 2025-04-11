import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/task/task_provider.dart';
import 'task_item_widget.dart';

class PreviousTasksTab extends ConsumerWidget {
  const PreviousTasksTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch the specific parts of state we need
    final isLoadingPrevious = ref.watch(
      taskProvider.select((state) => state.isLoadingPrevious),
    );
    final error = ref.watch(taskProvider.select((state) => state.error));
    final previousTodos = ref.watch(
      taskProvider.select((state) => state.previousTodos),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Previous tasks header with count that only rebuilds when count changes
        Consumer(
          builder: (context, ref, _) {
            final count = ref.watch(
              taskProvider.select((state) => state.previousTodos.length),
            );

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tugas Sebelumnya yang Belum Selesai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimaryColor(context),
                    ),
                  ),
                  Text(
                    '$count tugas',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            );
          },
        ),

        // Loading state
        if (isLoadingPrevious)
          const Expanded(child: Center(child: CircularProgressIndicator())),

        // Empty state
        if (!isLoadingPrevious && error == null && previousTodos.isEmpty)
          const Expanded(
            child: Center(
              child: Text(
                'Tidak ada tugas sebelumnya yang belum selesai',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),

        // Previous task list
        if (!isLoadingPrevious && error == null && previousTodos.isNotEmpty)
          Expanded(
            child: ListView.separated(
              itemCount: previousTodos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final todo = previousTodos[index];
                // Wrap each item in Consumer for even more granular rebuilds
                return Consumer(
                  builder: (context, ref, _) {
                    return TaskItemWidget(
                      todo: todo,
                      onToggleStatus: () {
                        ref.read(taskProvider.notifier).toggleTodoStatus(todo);
                      },
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
