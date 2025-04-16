import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mahas/mahas_type.dart';
import '../../../core/mahas/widget/mahas_button.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_typografi.dart';
import '../../../core/mahas/inputs/input_text_component.dart';
import '../../../core/mahas/inputs/input_datetime_component.dart';
import '../../../core/mahas/inputs/input_dropdown_component.dart';
import '../../providers/add_task/add_task_provider.dart';
import '../../providers/home/home_provider.dart';

class AddTaskPage extends ConsumerWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addTaskProvider);
    final notifier = ref.read(addTaskProvider.notifier);
    final homeNotifier = ref.read(homeProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error message
          if (state.error != null)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            ),

          // Success message
          if (state.isSuccess)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                state.successMessage ?? 'Task berhasil dibuat!',
                style: const TextStyle(color: Colors.green),
              ),
            ),

          // Title field
          InputTextComponent(
            controller: notifier.titleController,
            label: 'Judul Tugas',
            required: true,
          ),

          // Description field
          InputTextComponent(
            controller: notifier.descriptionController,
            label: 'Deskripsi',
          ),

          // Due date & time pickers
          Row(
            children: [
              Expanded(
                flex: 2,
                child: InputDatetimeComponent(
                  controller: notifier.dateController,
                  label: 'Tenggat Waktu',
                  type: InputDatetimeType.date,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InputDatetimeComponent(
                  controller: notifier.timeController,
                  type: InputDatetimeType.time,
                  label: ' ',
                ),
              ),
            ],
          ),

          // Priority selector
          InputDropdownComponent(
            controller: notifier.priorityController,
            label: 'Prioritas',
          ),

          // Subtasks section
          Column(
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
                    icon: Icon(
                      Icons.add,
                      color: AppColors.getCardColor(context),
                    ),
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
                    separatorBuilder:
                        (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final subtask = state.subtasks[index];
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 0,
                        ),
                        title: Text(
                          subtask.title,
                          style: AppTypography.todoSubtask,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () => notifier.removeSubtask(subtask),
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),

          // Tag selection section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tags'),
                  TextButton.icon(
                    onPressed: () => notifier.toggleTagSelector(),
                    icon: Icon(
                      state.showTagSelector
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18,
                      color: AppColors.getTextPrimaryColor(context),
                    ),
                    label: Text(
                      state.showTagSelector ? 'Hide' : 'Show',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.getTextPrimaryColor(context),
                      ),
                    ),
                  ),
                ],
              ),

              // Selected tags display
              if (state.selectedTags.isNotEmpty) ...[
                SizedBox(
                  height: 36,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          state.selectedTags
                              .map(
                                (tag) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Chip(
                                    label: Text(
                                      tag.name,
                                      style: AppTypography.todoTag.copyWith(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    backgroundColor: tag.getColor(),
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    onDeleted: () => notifier.toggleTag(tag),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ],

              // Tag selector
              if (state.showTagSelector) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Row(
                            children:
                                state.availableTags
                                    .map(
                                      (tag) => Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8,
                                        ),
                                        child: OutlinedButton(
                                          onPressed:
                                              () => notifier.toggleTag(tag),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor:
                                                state.selectedTags.any(
                                                      (t) => t.id == tag.id,
                                                    )
                                                    ? tag
                                                        .getColor()
                                                        .withOpacity(0.7)
                                                    : Colors.transparent,
                                            side: BorderSide(
                                              color:
                                                  state.selectedTags.any(
                                                        (t) => t.id == tag.id,
                                                      )
                                                      ? Colors.transparent
                                                      : Colors.grey.shade300,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 0,
                                            ),
                                            minimumSize: const Size(0, 28),
                                          ),
                                          child: Text(
                                            tag.name,
                                            style: TextStyle(
                                              color:
                                                  state.selectedTags.any(
                                                        (t) => t.id == tag.id,
                                                      )
                                                      ? Colors.white
                                                      : Colors.black87,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    MahasButton(
                      icon: Icon(
                        Icons.add,
                        color: AppColors.getCardColor(context),
                      ),
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
              ],
              const SizedBox(height: 16),
            ],
          ),

          MahasButton(
            onPressed:
                state.isSubmitting
                    ? null
                    : () => notifier.handleSubmit(context, homeNotifier),
            isLoading: state.isSubmitting,
            text: 'ADD',
            color: AppColors.getTextPrimaryColor(context),
            isFullWidth: true,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
