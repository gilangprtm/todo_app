import 'package:flutter/material.dart';
import '../../../core/base/base_state_notifier.dart';
import '../../../data/models/tag_model.dart';
import '../../../data/models/subtask_model.dart';

/// State untuk halaman Add Task
class AddTaskState extends BaseState {
  final DateTime? dueDate;
  final TimeOfDay? dueTime;
  final int priority; // 0: low, 1: medium, 2: high
  final List<SubtaskModel> subtasks;
  final List<TagModel> selectedTags;
  final List<TagModel> availableTags;

  // State untuk UI
  final bool isSubmitting;
  final bool showDatePicker;
  final bool showTimePicker;
  final bool showTagSelector;

  // Hasil submit
  final bool isSuccess;
  final String? successMessage;

  AddTaskState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
    this.dueDate,
    this.dueTime,
    this.priority = 0,
    this.subtasks = const [],
    this.selectedTags = const [],
    this.availableTags = const [],
    this.isSubmitting = false,
    this.showDatePicker = false,
    this.showTimePicker = false,
    this.showTagSelector = false,
    this.isSuccess = false,
    this.successMessage,
  });

  @override
  AddTaskState copyWith({
    bool? isLoading,
    dynamic error,
    StackTrace? stackTrace,
    bool clearError = false,
    DateTime? dueDate,
    bool resetDueDate = false,
    TimeOfDay? dueTime,
    bool resetDueTime = false,
    int? priority,
    List<SubtaskModel>? subtasks,
    List<TagModel>? selectedTags,
    List<TagModel>? availableTags,
    bool? isSubmitting,
    bool? showDatePicker,
    bool? showTimePicker,
    bool? showTagSelector,
    bool? isSuccess,
    String? successMessage,
    bool resetSuccessMessage = false,
  }) {
    return AddTaskState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      dueDate: resetDueDate ? null : dueDate ?? this.dueDate,
      dueTime: resetDueTime ? null : dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      subtasks: subtasks ?? this.subtasks,
      selectedTags: selectedTags ?? this.selectedTags,
      availableTags: availableTags ?? this.availableTags,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      showDatePicker: showDatePicker ?? this.showDatePicker,
      showTimePicker: showTimePicker ?? this.showTimePicker,
      showTagSelector: showTagSelector ?? this.showTagSelector,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage:
          resetSuccessMessage ? null : successMessage ?? this.successMessage,
    );
  }
}
