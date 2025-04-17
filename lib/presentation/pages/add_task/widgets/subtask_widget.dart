import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';
import '../../../../core/mahas/widget/mahas_button.dart';
import '../../../../core/mahas/inputs/input_text_component.dart';
import '../../../../core/mahas/mahas_type.dart';
import '../../../providers/add_task/add_task_provider.dart';

/// Widget for managing subtasks when creating a new task
class SubtaskWidget extends ConsumerWidget {
  const SubtaskWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addTaskProvider);
    final notifier = ref.read(addTaskProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Subtasks'),
        const SizedBox(height: 8),
        // Subtask input
        Row(
          children: [
            Expanded(
              child: InputTextComponent(
                controller: notifier.subtaskController,
                marginBottom: 0,
              ),
            ),
            const SizedBox(width: 8),
            MahasButton(
              icon: Icon(Icons.add, color: AppColors.getCardColor(context)),
              color: AppColors.getTextPrimaryColor(context),
              type: ButtonType.icon,
              onPressed: () {
                if (notifier.subtaskController.value.isNotEmpty) {
                  notifier.addSubtask(notifier.subtaskController.value);
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Subtask list
        if (state.subtasks.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.subtasks.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final subtask = state.subtasks[index];
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 0,
                  ),
                  title: Row(
                    children: [
                      const SizedBox(width: 16),
                      Text(subtask.title, style: AppTypography.todoSubtask),
                    ],
                  ),
                  trailing: MahasButton(
                    icon: Icon(
                      Icons.delete,
                      color: AppColors.getCardColor(context),
                    ),
                    color: AppColors.errorColor,
                    type: ButtonType.icon,
                    onPressed: () {
                      notifier.removeSubtask(subtask);
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
