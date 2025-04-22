import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_color.dart';
import '../../core/theme/app_typografi.dart';
import '../../core/mahas/widget/mahas_card.dart';
import '../../core/mahas/widget/mahas_alert.dart';
import '../../core/mahas/mahas_type.dart';
import '../../data/models/todo_model.dart';
import '../../data/models/subtask_model.dart';

class TaskItemWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onToggleStatus;
  final Function(SubtaskModel)? onToggleSubtask;
  final VoidCallback? onDelete;
  final bool showSubtasks;
  final bool simplifiedView;

  const TaskItemWidget({
    super.key,
    required this.todo,
    required this.onToggleStatus,
    this.onToggleSubtask,
    this.onDelete,
    this.showSubtasks = true,
    this.simplifiedView = false,
  });

  @override
  Widget build(BuildContext context) {
    // Format time
    String timeText = '';
    if (todo.dueDate != null) {
      timeText = DateFormat('HH:mm').format(todo.dueDate!);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get card color based on status
    final cardColor = AppColors.getStatusBackgroundColor(context, todo.status);

    // Check if completed
    final isCompleted = todo.status == 2;

    // Get checkbox color based on current status
    final currentCheckboxColor = AppColors.getStatusColor(context, todo.status);

    // Get current status text
    String currentStatusText = '';
    if (todo.status == 0) {
      currentStatusText = 'Pending';
    } else if (todo.status == 1) {
      currentStatusText = 'In Progress';
    } else if (todo.status == 2) {
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
                    onChanged: (_) => onToggleStatus(),
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
                      todo.title,
                      style: AppTypography.subtitle1.copyWith(
                        color:
                            isCompleted
                                ? AppColors.getTextSecondaryColor(context)
                                : AppColors.getTextPrimaryColor(context),
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null,
                        fontWeight:
                            isCompleted ? FontWeight.normal : FontWeight.w600,
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
              if (todo.priority == 2) ...[
                // High priority
                const SizedBox(width: 8),
                Icon(
                  Icons.priority_high,
                  size: 18,
                  color: isDark ? Colors.red[300] : Colors.red,
                ),
              ],
              // Add delete button
              if (onDelete != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: isDark ? Colors.red[300] : Colors.red,
                  ),
                  onPressed: () => _showDeleteConfirmation(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                  tooltip: 'Delete task',
                ),
              ],
            ],
          ),

          if (todo.tags.isNotEmpty && !simplifiedView) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  todo.tags.map((tag) {
                    return Chip(
                      label: Text(
                        tag.name,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          decoration:
                              isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      backgroundColor:
                          isCompleted
                              ? tag.getColor().withValues(
                                alpha: 0.6,
                              ) // Reduce opacity if completed
                              : tag.getColor(),
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

          // Subtasks section - shown based on showSubtasks flag
          if (todo.subtasks.isNotEmpty) ...[
            const SizedBox(height: 8),
            if (showSubtasks && onToggleSubtask != null) ...[
              // Full subtask view with toggles
              ...todo.subtasks.map((subtask) {
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
                                isCompleted
                                    ? null // Disable subtask toggling if parent task is completed
                                    : (_) => onToggleSubtask!(subtask),
                            shape: const CircleBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        subtask.title,
                        style: AppTypography.bodyText2.copyWith(
                          color:
                              subtask.isCompleted || isCompleted
                                  ? AppColors.getTextSecondaryColor(context)
                                  : AppColors.getTextPrimaryColor(context),
                          decoration:
                              subtask.isCompleted || isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else ...[
              // Simplified counter view
              Padding(
                padding: const EdgeInsets.only(left: 36),
                child: Text(
                  '${todo.subtasks.length} subtasks',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.getTextSecondaryColor(context),
                  ),
                ),
              ),
            ],
          ],

          // Show description if available
          if (todo.description != null &&
              todo.description!.isNotEmpty &&
              !simplifiedView) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                todo.description!,
                style: AppTypography.bodyText2.copyWith(
                  color: AppColors.getTextSecondaryColor(context),
                  fontStyle: FontStyle.italic,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
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

  // Show a confirmation dialog before deleting
  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return MahasAlertDialog(
          alertType: AlertType.confirmation,
          content: Text('Are you sure you want to delete "${todo.title}"?'),
          positiveButtonText: 'Delete',
          negativeButtonText: 'Cancel',
          // Don't navigate in callbacks, the MahasAlertDialog does that automatically
          onPositivePressed: () {
            if (onDelete != null) {
              onDelete!();
              // Show success dialog after deletion
              _showDeleteSuccessDialog(context);
            }
          },
          // We don't need to do anything on cancel
          onNegativePressed: null,
        );
      },
    );
  }

  // Show success dialog after task deletion
  void _showDeleteSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return MahasAlertDialog(
          alertType: AlertType.succes,
          title: 'Task Deleted!',
          content: Text('The task "${todo.title}" was successfully deleted.'),
          showNegativeButton: false,
          showPositiveButton: false,
        );
      },
    );
  }
}
