import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';
import '../../../../core/mahas/widget/mahas_card.dart';
import '../../../../data/models/todo_model.dart';
import '../../../providers/task/task_provider.dart';

class TaskItemWidget extends StatelessWidget {
  final TodoModel todo;

  const TaskItemWidget({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
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

        final isDark = Theme.of(context).brightness == Brightness.dark;

        // Get card color based on status
        final cardColor = AppColors.getStatusBackgroundColor(
          context,
          currentTodo.status,
        );

        // Check if completed
        final isCompleted = currentTodo.status == 2;

        // Get checkbox color based on current status
        final currentCheckboxColor = AppColors.getStatusColor(
          context,
          currentTodo.status,
        );

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
                          fillColor: WidgetStateProperty.resolveWith(
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
                                    ? AppColors.getTextSecondaryColor(context)
                                    : AppColors.getTextPrimaryColor(context),
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
                        color: AppColors.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                  if (currentTodo.priority == 2) ...[
                    // High priority
                    const SizedBox(width: 8),
                    Icon(
                      Icons.priority_high,
                      size: 18,
                      color: isDark ? Colors.red[300] : Colors.red,
                    ),
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                          child: Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                fillColor: WidgetStateProperty.resolveWith(
                                  (states) =>
                                      subtask.isCompleted
                                          ? (isDark
                                              ? Colors.green[300]
                                              : Colors.green)
                                          : (isDark
                                              ? Colors.grey[700]
                                              : Colors.grey[400]),
                                ),
                              ),
                            ),
                            child: Checkbox(
                              value: subtask.isCompleted,
                              onChanged:
                                  (_) => ref
                                      .read(taskProvider.notifier)
                                      .toggleSubtaskStatus(subtask),
                              shape: const CircleBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          subtask.title,
                          style: AppTypography.bodyText2.copyWith(
                            color:
                                subtask.isCompleted
                                    ? AppColors.getTextSecondaryColor(context)
                                    : AppColors.getTextPrimaryColor(context),
                            decoration:
                                subtask.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
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
                      color: AppColors.getTextSecondaryColor(context),
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
      },
    );
  }
}
