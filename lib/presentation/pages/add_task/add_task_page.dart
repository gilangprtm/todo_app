import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_color.dart';
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
            marginBottom: 15,
          ),

          // Subtasks section will be implemented in future

          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  state.isSubmitting
                      ? null
                      : () => notifier.handleSubmit(context, homeNotifier),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                disabledBackgroundColor: AppColors.grey,
              ),
              child:
                  state.isSubmitting
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : const Text('Tambah Tugas'),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
