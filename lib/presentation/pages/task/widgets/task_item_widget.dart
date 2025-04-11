import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';
import '../../../../core/mahas/widget/mahas_card.dart';
import '../../../../data/models/todo_model.dart';
import '../../../providers/task/task_provider.dart';

class TaskItemWidget extends ConsumerWidget {
  final TodoModel todo;

  const TaskItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Re-read the todo from the provider to get the latest state
    final todos = ref.watch(taskProvider.select((state) => state.todos));
    final currentTodo = todos.firstWhere(
      (t) => t.id == todo.id,
      orElse: () => todo,
    );

    // Format time
    String timeText = '';
    if (currentTodo.dueDate != null) {
      timeText = DateFormat('HH:mm').format(currentTodo.dueDate!);
    }

    // Get card color based on status
    Color cardColor = Colors.white;
    if (currentTodo.status == 1) {
      // In Progress
      cardColor = Colors.blue.withOpacity(0.05);
    } else if (currentTodo.status == 2) {
      // Completed
      cardColor = Colors.green.withOpacity(0.05);
    }

    // Check if completed
    final isCompleted = currentTodo.status == 2;

    // Get checkbox color based on current status
    Color currentCheckboxColor = Colors.grey;
    if (currentTodo.status == 1) {
      currentCheckboxColor = Colors.blue;
    } else if (currentTodo.status == 2) {
      currentCheckboxColor = Colors.green;
    }

    // Get current status text
    String currentStatusText = '';
    if (currentTodo.status == 0) {
      currentStatusText = 'Pending';
    } else if (currentTodo.status == 1) {
      currentStatusText = 'In Progress';
    } else if (currentTodo.status == 2) {
      currentStatusText = 'Completed';
    }

    return MahasCustomizableCard(
      color: cardColor,
      padding: 16.0,
      margin: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Theme(
                  data: ThemeData(
                    checkboxTheme: CheckboxThemeData(
                      fillColor: MaterialStateProperty.resolveWith(
                        (states) => currentCheckboxColor,
                      ),
                    ),
                  ),
                  child: Checkbox(
                    value: isCompleted,
                    onChanged:
                        (_) => ref
                            .read(taskProvider.notifier)
                            .toggleTodoStatus(currentTodo),
                    shape: const CircleBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTodo.title,
                      style: AppTypography.subtitle1.copyWith(
                        color:
                            isCompleted
                                ? AppColors.notionBlack.withOpacity(0.5)
                                : AppColors.notionBlack,
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentStatusText,
                      style: AppTypography.caption.copyWith(
                        color: currentCheckboxColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (timeText.isNotEmpty) ...[
                Text(
                  timeText,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.notionBlack.withOpacity(0.6),
                  ),
                ),
              ],
              if (currentTodo.priority == 2) ...[
                // High priority
                const SizedBox(width: 8),
                const Icon(Icons.priority_high, size: 18, color: Colors.red),
              ],
            ],
          ),

          if (currentTodo.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  currentTodo.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag.name,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: tag.getColor(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                    );
                  }).toList(),
            ),
          ],

          if (currentTodo.subtasks.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...currentTodo.subtasks.map((subtask) {
              return Padding(
                padding: const EdgeInsets.only(left: 36, top: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: subtask.isCompleted,
                        onChanged:
                            (_) => ref
                                .read(taskProvider.notifier)
                                .toggleSubtaskStatus(subtask),
                        shape: const CircleBorder(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      subtask.title,
                      style: AppTypography.bodyText2.copyWith(
                        color:
                            subtask.isCompleted
                                ? AppColors.notionBlack.withOpacity(0.4)
                                : AppColors.notionBlack,
                        decoration:
                            subtask.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],

          // Show description if available
          if (currentTodo.description != null &&
              currentTodo.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                currentTodo.description!,
                style: AppTypography.bodyText2.copyWith(
                  color: AppColors.notionBlack.withOpacity(0.6),
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
