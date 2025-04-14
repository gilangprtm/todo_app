import 'dart:async';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/base/base_state_notifier.dart';
import '../../../data/datasource/local/services/todo_service.dart';
import '../../../data/models/todo_model.dart';
import '../../../data/models/subtask_model.dart';
import 'calendar_state.dart';

class CalendarNotifier extends BaseStateNotifier<CalendarState> {
  final TodoService _todoService;
  final ScrollController scrollController = ScrollController();
  bool _isScrollDetected = false;

  CalendarNotifier(super.initialState, super.ref, this._todoService) {
    // Inisialisasi scroll controller
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.offset > 20 && !_isScrollDetected) {
      _isScrollDetected = true;
      // Ubah format calendar ke tampilan minggu ketika user scroll ke bawah
      setCalendarFormat(CalendarFormat.week);
    } else if (scrollController.offset <= 20 && _isScrollDetected) {
      _isScrollDetected = false;
      // Ubah format calendar kembali ke tampilan bulan ketika user scroll ke atas
      setCalendarFormat(CalendarFormat.month);
    }
  }

  @override
  Future<void> onInit() async {
    // Memuat data untuk bulan saat ini saja pada awalnya
    final now = DateTime.now();

    // Update state dengan tanggal hari ini sebagai selected dan focused day
    state = state.copyWith(
      selectedDay: now,
      focusedDay: now,
      currentMonth: '${now.year}-${now.month}',
    );

    // Muat data untuk bulan ini
    await loadTasksForMonth(now.year, now.month);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  // Fetch tasks untuk inisialisasi
  Future<void> fetchTasks() async {
    await runAsync('fetchTasks', () async {
      try {
        // Get current month for initial load
        final now = DateTime.now();
        final year = now.year;
        final month = now.month;

        // Load tasks for current month
        await loadTasksForMonth(year, month);

        // Mark as initialized
        state = state.copyWith(isInitialized: true, clearError: true);
      } catch (e, stackTrace) {
        state = state.copyWith(error: e, stackTrace: stackTrace);
      }
    });
  }

  // Silent refresh - tidak mengubah UI loading state
  Future<void> silentRefresh() async {
    // Jika sedang refresh, loading, atau tasks sedang loading, abaikan
    if (state.isRefreshing || state.isLoading || state.isLoadingTasks) return;

    // Set refresh state tapi tidak mempengaruhi isLoading
    state = state.copyWith(isRefreshing: true);

    await runAsync('silentRefresh', () async {
      try {
        // Get current focused month
        final year = state.focusedDay.year;
        final month = state.focusedDay.month;

        // Hitung tanggal awal dan akhir bulan
        final startOfMonth = DateTime(year, month, 1);
        final endOfMonth =
            month < 12
                ? DateTime(year, month + 1, 0)
                : DateTime(year + 1, 1, 0);

        final monthTasks = await _todoService.getTasksForDateRange(
          startOfMonth,
          endOfMonth,
        );

        // Buat map untuk event markers
        final eventMarkers = <DateTime, List<TodoModel>>{};
        for (final task in monthTasks) {
          if (task.dueDate != null) {
            final dateOnly = DateTime(
              task.dueDate!.year,
              task.dueDate!.month,
              task.dueDate!.day,
            );

            if (eventMarkers[dateOnly] == null) {
              eventMarkers[dateOnly] = [task];
            } else {
              eventMarkers[dateOnly]!.add(task);
            }
          }
        }

        // Update state tanpa mengubah loading states
        state = state.copyWith(
          calendarTasks: monthTasks,
          eventMarkers: eventMarkers,
          isRefreshing: false,
          isInitialized: true,
          clearError: true,
        );
      } catch (e) {
        // Silent error handling
        state = state.copyWith(isRefreshing: false);
      }
    });
  }

  // Load tasks untuk bulan tertentu - HANYA mengurus pengambilan data task
  Future<void> loadTasksForMonth(int year, int month) async {
    await runAsync('loadTasksForMonth', () async {
      // Update currentMonth
      state = state.copyWith(
        currentMonth: '$year-$month',
        isLoadingTasks: true,
      );

      try {
        // Hitung tanggal awal dan akhir bulan
        final startOfMonth = DateTime(year, month, 1);
        final endOfMonth =
            month < 12
                ? DateTime(year, month + 1, 0)
                : DateTime(year + 1, 1, 0);

        final monthTasks = await _todoService.getTasksForDateRange(
          startOfMonth,
          endOfMonth,
        );

        // Buat map untuk event markers
        final eventMarkers = <DateTime, List<TodoModel>>{};
        for (final task in monthTasks) {
          if (task.dueDate != null) {
            final dateOnly = DateTime(
              task.dueDate!.year,
              task.dueDate!.month,
              task.dueDate!.day,
            );

            if (eventMarkers[dateOnly] == null) {
              eventMarkers[dateOnly] = [task];
            } else {
              eventMarkers[dateOnly]!.add(task);
            }
          }
        }

        // Update state HANYA dengan data tasks - tidak mengubah UI state
        state = state.copyWith(
          calendarTasks: monthTasks,
          eventMarkers: eventMarkers,
          isLoadingTasks: false,
          isLoading: false,
          isInitialized: true,
          clearError: true,
        );
      } catch (e, stackTrace) {
        state = state.copyWith(
          error: e,
          stackTrace: stackTrace,
          isLoading: false,
          isLoadingTasks: false,
        );
      }
    });
  }

  // Set selected day - HANYA mengurus UI selection
  void setSelectedDay(DateTime day) {
    state = state.copyWith(selectedDay: day, focusedDay: day);
  }

  // Set calendar format - untuk mengubah tampilan kalender antara bulan/minggu
  void setCalendarFormat(CalendarFormat format) {
    state = state.copyWith(calendarFormat: format);
  }

  // Handle page change dari calendar
  void handleCalendarPageChanged(DateTime page) {
    // Extract the year and month from the page
    final int year = page.year;
    final int month = page.month;

    // Create a new focusedDay that maintains the same day as the selectedDay if possible,
    // or uses the day from the page parameter if no selectedDay exists
    final int day = state.selectedDay?.day ?? page.day;

    // Make sure we don't create an invalid date (e.g., February 30)
    final int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    final int actualDay = day > lastDayOfMonth ? lastDayOfMonth : day;
    final DateTime newFocusedDay = DateTime(year, month, actualDay);

    // Update the state with the new focusedDay and currentMonth
    state = state.copyWith(
      focusedDay: newFocusedDay,
      currentMonth: '$year-$month',
    );

    // Tunggu animasi selesai, baru muat data - delay 700ms
    Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      loadTasksForMonth(year, month);
    });
  }

  // Toggle todo status from calendar view
  Future<void> toggleTodoStatus(TodoModel todo) async {
    await runAsync('toggleTodoStatus', () async {
      try {
        // Determine next status: 0 -> 1 -> 2 -> 0
        final newStatus = (todo.status + 1) % 3;

        // Update via service
        final updatedTodo = await _todoService.updateTodoStatus(
          todo,
          newStatus,
        );

        // Update local state - hanya perbarui tugas dalam calendar state
        final updatedTasks =
            state.calendarTasks.map((task) {
              if (task.id == todo.id) {
                return updatedTodo;
              }
              return task;
            }).toList();

        // Update event markers
        final updatedMarkers = Map<DateTime, List<TodoModel>>.from(
          state.eventMarkers,
        );

        if (todo.dueDate != null) {
          final dateOnly = DateTime(
            todo.dueDate!.year,
            todo.dueDate!.month,
            todo.dueDate!.day,
          );

          if (updatedMarkers[dateOnly] != null) {
            updatedMarkers[dateOnly] =
                updatedMarkers[dateOnly]!.map((task) {
                  if (task.id == todo.id) {
                    return updatedTodo;
                  }
                  return task;
                }).toList();
          }
        }

        // Update state dengan task yang diperbarui
        state = state.copyWith(
          calendarTasks: updatedTasks,
          eventMarkers: updatedMarkers,
        );
      } catch (e, stackTrace) {
        state = state.copyWith(error: e, stackTrace: stackTrace);
      }
    });
  }

  // Toggle subtask status from calendar view
  Future<void> toggleSubtaskStatus(SubtaskModel subtask) async {
    await runAsync('toggleSubtaskStatus', () async {
      try {
        // Toggle status
        final newIsCompleted = !subtask.isCompleted;

        // Update via service
        final updatedSubtask = await _todoService.updateSubtaskStatus(
          subtask,
          newIsCompleted,
        );

        // Update local state
        final updatedTasks =
            state.calendarTasks.map((task) {
              if (task.subtasks.any((s) => s.id == subtask.id)) {
                // Update subtasks list with updated subtask
                final updatedSubtasks =
                    task.subtasks.map((s) {
                      if (s.id == subtask.id) {
                        return updatedSubtask;
                      }
                      return s;
                    }).toList();

                // Return task with updated subtasks
                return task.copyWith(subtasks: updatedSubtasks);
              }
              return task;
            }).toList();

        // Update event markers
        final updatedMarkers = <DateTime, List<TodoModel>>{};

        // Rebuild markers
        for (final task in updatedTasks) {
          if (task.dueDate != null) {
            final dateOnly = DateTime(
              task.dueDate!.year,
              task.dueDate!.month,
              task.dueDate!.day,
            );

            if (updatedMarkers[dateOnly] == null) {
              updatedMarkers[dateOnly] = [task];
            } else {
              updatedMarkers[dateOnly]!.add(task);
            }
          }
        }

        // Update state
        state = state.copyWith(
          calendarTasks: updatedTasks,
          eventMarkers: updatedMarkers,
        );
      } catch (e, stackTrace) {
        state = state.copyWith(error: e, stackTrace: stackTrace);
      }
    });
  }
}
