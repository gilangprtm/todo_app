import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mahas/widget/mahas_button.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/mahas/inputs/input_text_component.dart';
import '../../../core/mahas/inputs/input_datetime_component.dart';
import '../../../core/mahas/inputs/input_dropdown_component.dart';
import '../../../core/utils/mahas.dart';
import '../../providers/add_task/add_task_provider.dart';
import '../../providers/home/home_provider.dart';
import 'widgets/tag_selection_widget.dart';
import 'widgets/subtask_widget.dart';

class AddTaskPage extends ConsumerWidget {
  const AddTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addTaskProvider);
    final notifier = ref.read(addTaskProvider.notifier);
    final homeNotifier = ref.read(homeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            notifier.resetForm();
            Mahas.back();
          },
        ),
        surfaceTintColor: AppColors.getCardColor(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Padding(
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
                        label: 'Tanggal & Waktu',
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
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: SubtaskWidget(),
                ),

                // Tag selection section
                const Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: TagSelectionWidget(),
                ),

                // Submit button
                const SizedBox(height: 24),

                MahasButton(
                  text: 'Create Task',
                  color: AppColors.getTextPrimaryColor(context),
                  isFullWidth: true,
                  isLoading: state.isSubmitting,
                  onPressed:
                      state.isSubmitting
                          ? null
                          : () => notifier.handleSubmit(context, homeNotifier),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
