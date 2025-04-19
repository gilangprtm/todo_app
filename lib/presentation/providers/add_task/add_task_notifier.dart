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
  final InputTextController descriptionController = InputTextController(
    type: InputTextType.paragraf,
  );
  final InputDatetimeController dateController = InputDatetimeController();
  final InputDatetimeController timeController = InputDatetimeController();
  final InputDropdownController priorityController = InputDropdownController(
    items: [
      DropdownItem(text: 'Low', value: 0),
      DropdownItem(text: 'Medium', value: 1),
      DropdownItem(text: 'High', value: 2),
    ],
  );
  final InputTextController subtaskController = InputTextController();

  AddTaskNotifier(super.initialState, super.ref, this._todoService);

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadTags();
  }

  /// Load all available tags from database
  Future<void> loadTags() async {
    await runAsync('loadTags', () async {
      try {
        final tags = await _todoService.getAllTags();
        state = state.copyWith(availableTags: tags);
      } catch (e, stackTrace) {
        logger.e('Error loading tags', error: e, stackTrace: stackTrace);
      }
    });
  }

  /// Toggle tag selection UI visibility
  void toggleTagSelector() {
    state = state.copyWith(showTagSelector: !state.showTagSelector);
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
    subtaskController.clear();
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
    if (!titleController.isValid) return false;
    if (!dateController.isValid) return false;

    return true;
  }

  /// Submit form untuk membuat tugas baru
  Future<void> submitTask() async {
    if (!_validateForm()) return;

    state = state.copyWith(isSubmitting: true, clearError: true);

    await runAsync('submitTask', () async {
      try {
        // Get date and time values directly from controllers
        final date = dateController.value as DateTime?;
        final time = timeController.value as TimeOfDay?;
        final priority = priorityController.value as int? ?? state.priority;

        // Prepare combined date time if both are set
        DateTime? combinedDateTime;
        if (date != null) {
          combinedDateTime = date;

          // Add time if set
          if (time != null) {
            combinedDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
          }
        }

        // Create todo model
        final newTodo = TodoModel(
          title: titleController.value.trim(),
          description: descriptionController.value.trim(),
          dueDate: combinedDateTime,
          priority: priority,
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

  /// Create a new tag and add it to the database
  Future<void> addNewTag(TagModel tag) async {
    return await runAsync('addNewTag', () async {
      try {
        // Insert tag into database
        await _todoService.createTag(tag);

        // Reload tags to include the new one
        await loadTags();
      } catch (e, stackTrace) {
        logger.e('Error adding new tag', error: e, stackTrace: stackTrace);
        rethrow;
      }
    });
  }
}
