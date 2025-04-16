import 'package:flutter/material.dart';
import '../../../core/base/base_state_notifier.dart';
import '../../../core/mahas/inputs/input_datetime_component.dart';
import '../../../core/mahas/inputs/input_dropdown_component.dart';
import '../../../core/mahas/inputs/input_text_component.dart';
import '../../../data/datasource/local/services/todo_service.dart';
import '../../../data/models/todo_model.dart';
import '../../../data/models/subtask_model.dart';
import '../../../data/models/tag_model.dart';
import '../home/home_notifier.dart';
import 'add_task_state.dart';

/// Notifier untuk halaman Add Task
class AddTaskNotifier extends BaseStateNotifier<AddTaskState> {
  final TodoService _todoService;
  final InputTextController titleController = InputTextController();
  final InputTextController descriptionController = InputTextController();
  final InputDatetimeController dateController = InputDatetimeController();
  final InputDatetimeController timeController = InputDatetimeController();
  final InputDropdownController priorityController = InputDropdownController(
    items: [
      DropdownItem(text: 'Low', value: 0),
      DropdownItem(text: 'Medium', value: 1),
      DropdownItem(text: 'High', value: 2),
    ],
  );

  AddTaskNotifier(super.initialState, super.ref, this._todoService);

  /// Set tanggal jatuh tempo tugas
  Future<void> setDueDate(BuildContext context) async {
    // Toggle date picker UI flag
    state = state.copyWith(showDatePicker: true);

    // Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: state.dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    // Update state with picked date
    if (pickedDate != null) {
      state = state.copyWith(dueDate: pickedDate);

      // If time isn't set yet, show time picker next
      if (state.dueTime == null) {
        setDueTime(context);
      }
    }

    // Hide date picker UI
    state = state.copyWith(showDatePicker: false);
  }

  /// Set waktu jatuh tempo tugas
  Future<void> setDueTime(BuildContext context) async {
    // Toggle time picker UI flag
    state = state.copyWith(showTimePicker: true);

    // Show time picker
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: state.dueTime ?? TimeOfDay.now(),
    );

    // Update state with picked time
    if (pickedTime != null) {
      state = state.copyWith(dueTime: pickedTime);
    }

    // Hide time picker UI
    state = state.copyWith(showTimePicker: false);
  }

  /// Helper method untuk update state dari komponen datetime
  void setState(BuildContext context, {DateTime? setDate, TimeOfDay? setTime}) {
    if (setDate != null) {
      state = state.copyWith(dueDate: setDate);
    }

    if (setTime != null) {
      state = state.copyWith(dueTime: setTime);
    }
  }

  /// Set prioritas tugas
  void setPriority(int priority) {
    if (priority >= 0 && priority <= 2) {
      state = state.copyWith(priority: priority);
    }
  }

  /// Tambah subtask baru
  void addSubtask(String title) {
    if (title.trim().isEmpty) return;

    final newSubtask = SubtaskModel(
      id: -1 * (state.subtasks.length + 1), // Temporary negative ID
      todoId: -1, // Temporary ID, will be set when task is created
      title: title.trim(),
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final updatedSubtasks = List<SubtaskModel>.from(state.subtasks)
      ..add(newSubtask);
    state = state.copyWith(subtasks: updatedSubtasks);
  }

  /// Hapus subtask
  void removeSubtask(SubtaskModel subtask) {
    final updatedSubtasks = List<SubtaskModel>.from(state.subtasks)
      ..removeWhere((s) => s.id == subtask.id);
    state = state.copyWith(subtasks: updatedSubtasks);
  }

  /// Toggle tag selection
  void toggleTag(TagModel tag) {
    final updatedTags = List<TagModel>.from(state.selectedTags);

    if (updatedTags.any((t) => t.id == tag.id)) {
      updatedTags.removeWhere((t) => t.id == tag.id);
    } else {
      updatedTags.add(tag);
    }

    state = state.copyWith(selectedTags: updatedTags);
  }

  /// Validasi form sebelum submit
  bool _validateForm() {
    final title = titleController.value;

    if (title.isEmpty) {
      state = state.copyWith(
        error: 'Judul tugas tidak boleh kosong',
        clearError: false,
      );
      return false;
    }

    return true;
  }

  /// Submit form untuk membuat tugas baru
  Future<void> submitTask() async {
    if (!_validateForm()) return;

    state = state.copyWith(isSubmitting: true, clearError: true);

    await runAsync('submitTask', () async {
      try {
        // Prepare combined date time if both are set
        DateTime? combinedDateTime;
        if (state.dueDate != null) {
          combinedDateTime = state.dueDate!;

          // Add time if set
          if (state.dueTime != null) {
            combinedDateTime = DateTime(
              state.dueDate!.year,
              state.dueDate!.month,
              state.dueDate!.day,
              state.dueTime!.hour,
              state.dueTime!.minute,
            );
          }
        }

        // Create todo model
        final newTodo = TodoModel(
          title: titleController.value.trim(),
          description: descriptionController.value.trim(),
          dueDate: combinedDateTime,
          priority: state.priority,
          status: 0, // Pending by default
          subtasks: state.subtasks,
          tags: state.selectedTags,
        );

        // Save to database
        await _todoService.createTodo(newTodo);

        // Update state with success
        state = state.copyWith(
          isSubmitting: false,
          isSuccess: true,
          successMessage: 'Tugas berhasil dibuat!',
          clearError: true,
        );

        // Reset form after short delay
        Future.delayed(const Duration(milliseconds: 1500), () {
          resetForm();
        });
      } catch (e, stackTrace) {
        state = state.copyWith(
          isSubmitting: false,
          error: e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  // Handle submission
  void handleSubmit(BuildContext context, HomeNotifier homeNotifier) async {
    await submitTask();
    if (state.isSuccess) {
      // Refresh the task list in home screen after adding a task
      homeNotifier.refreshCurrentTab();

      // Close the bottom sheet
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  /// Reset form ke keadaan awal
  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
    timeController.clear();
    priorityController.clear();

    state = state.copyWith(
      dueDate: null,
      resetDueDate: true,
      dueTime: null,
      resetDueTime: true,
      priority: 0,
      subtasks: [],
      selectedTags: [],
      isSuccess: false,
      resetSuccessMessage: true,
      clearError: true,
    );
  }
}
