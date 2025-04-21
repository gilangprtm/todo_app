import 'package:flutter/material.dart';
import '../../../core/base/base_state_notifier.dart';
import '../../../data/datasource/local/services/todo_service.dart';
import '../../../data/models/tag_model.dart';
import '../../../data/models/todo_model.dart';
import 'stats_state.dart';
import '../stats/stats_state.dart';

/// Notifier untuk mengelola state halaman Statistics
class StatsNotifier extends BaseStateNotifier<StatsState> {
  final TodoService _todoService;

  StatsNotifier(super.initialState, super.ref, this._todoService);

  @override
  Future<void> onInit() async {
    super.onInit();
    // Akan otomatis dijalankan ketika provider pertama kali dibuat
    await loadStats();
  }

  /// Load semua data statistik
  Future<void> loadStats() async {
    await runAsync('loadStats', () async {
      try {
        state = state.copyWith(isLoading: true, clearError: true);

        // Ambil semua tugas dari database
        final allTodos = await _todoService.getAllTasks();

        // Ambil semua tags
        final allTags = await _todoService.getAllTags();

        // Proses data untuk berbagai statistik
        await Future.wait([
          _processActivityData(allTodos),
          _processTagDistribution(allTodos, allTags),
          _processPriorityCompletionRate(allTodos),
          _processProductivityTrends(allTodos),
          _processCompletionTime(allTodos),
          _processProductiveHours(allTodos),
          _processAchievements(allTodos),
        ]);

        state = state.copyWith(isLoading: false);
      } catch (e, stackTrace) {
        logger.e('Error loading stats', error: e, stackTrace: stackTrace);
        state = state.copyWith(
          isLoading: false,
          error: e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  /// Set the selected date and update tasks for that date
  void setSelectedDate(DateTime date) {
    runAsync('setSelectedDate', () async {
      try {
        // Update the selected date in state
        state = state.copyWith(selectedDate: date);

        // Load tasks for the selected date
        final tasksOnDate = await _todoService.getTodosForDate(date);

        // Update the state with tasks for the selected date
        state = state.copyWith(tasksOnSelectedDate: tasksOnDate);
      } catch (e, stackTrace) {
        logger.e(
          'Error setting selected date',
          error: e,
          stackTrace: stackTrace,
        );
        state = state.copyWith(error: e, stackTrace: stackTrace);
      }
    });
  }

  /// Set periode tren (week/month)
  void setTrendPeriod(String period) {
    if (period != 'week' && period != 'month') return;

    state = state.copyWith(trendPeriod: period);

    // Re-proses tren sesuai periode yang dipilih
    _todoService
        .getAllTasks()
        .then((todos) {
          _processProductivityTrends(todos);
        })
        .catchError((e, stackTrace) {
          logger.e(
            'Error updating trend period',
            error: e,
            stackTrace: stackTrace,
          );
        });
  }

  /// Set rentang waktu yang ditampilkan
  void setDateRange(DateRange range) async {
    await runAsync('setDateRange', () async {
      try {
        state = state.copyWith(dateRange: range, isLoading: true);

        // Reload semua statistik dengan rentang waktu yang baru
        await loadStats();
      } catch (e, stackTrace) {
        logger.e('Error setting date range', error: e, stackTrace: stackTrace);
        state = state.copyWith(
          isLoading: false,
          error: e,
          stackTrace: stackTrace,
        );
      }
    });
  }

  /* HELPER METHODS UNTUK MEMPROSES DATA STATISTIK */

  /// Proses data aktivitas untuk heat map
  Future<void> _processActivityData(List<TodoModel> todos) async {
    final activityMap = <DateTime, int>{};

    // Filter berdasarkan rentang waktu
    final filteredTodos = _filterTodosByDateRange(todos);

    // Hitung jumlah tugas per tanggal (completed + created)
    for (final todo in filteredTodos) {
      // Untuk aktivitas pembuatan tugas
      final createdDate = _dateOnly(todo.createdAt);
      activityMap[createdDate] = (activityMap[createdDate] ?? 0) + 1;

      // Untuk aktivitas penyelesaian tugas
      if (todo.status == 2) {
        // 2 = Completed
        final completedDate = _dateOnly(todo.updatedAt);
        activityMap[completedDate] = (activityMap[completedDate] ?? 0) + 1;
      }
    }

    state = state.copyWith(activityData: activityMap);
  }

  /// Proses distribusi tugas berdasarkan tag
  Future<void> _processTagDistribution(
    List<TodoModel> todos,
    List<TagModel> allTags,
  ) async {
    final tagMap = <TagModel, int>{};

    // Inisialisasi semua tag dengan 0
    for (final tag in allTags) {
      tagMap[tag] = 0;
    }

    // Filter berdasarkan rentang waktu
    final filteredTodos = _filterTodosByDateRange(todos);

    // Hitung jumlah tugas per tag
    for (final todo in filteredTodos) {
      for (final tag in todo.tags) {
        tagMap[tag] = (tagMap[tag] ?? 0) + 1;
      }
    }

    // Hapus tag dengan jumlah 0
    tagMap.removeWhere((key, value) => value == 0);

    state = state.copyWith(tagDistribution: tagMap);
  }

  /// Proses tingkat penyelesaian berdasarkan prioritas
  Future<void> _processPriorityCompletionRate(List<TodoModel> todos) async {
    final priorityMap = <int, double>{0: 0, 1: 0, 2: 0}; // Low, Medium, High
    final priorityTotal = <int, int>{0: 0, 1: 0, 2: 0};
    final priorityCompleted = <int, int>{0: 0, 1: 0, 2: 0};

    // Filter berdasarkan rentang waktu
    final filteredTodos = _filterTodosByDateRange(todos);

    // Hitung jumlah tugas dan tugas selesai per prioritas
    for (final todo in filteredTodos) {
      final priority = todo.priority;
      priorityTotal[priority] = (priorityTotal[priority] ?? 0) + 1;

      if (todo.status == 2) {
        // 2 = Completed
        priorityCompleted[priority] = (priorityCompleted[priority] ?? 0) + 1;
      }
    }

    // Hitung persentase penyelesaian
    for (final priority in priorityTotal.keys) {
      final total = priorityTotal[priority] ?? 0;
      final completed = priorityCompleted[priority] ?? 0;

      priorityMap[priority] = total > 0 ? completed / total : 0;
    }

    state = state.copyWith(priorityCompletionRate: priorityMap);
  }

  /// Proses tren produktivitas mingguan/bulanan
  Future<void> _processProductivityTrends(List<TodoModel> todos) async {
    // Filter berdasarkan rentang waktu
    final filteredTodos = _filterTodosByDateRange(todos);

    // Tentukan periode dan jumlah data berdasarkan trendPeriod
    final int dataPoints = state.trendPeriod == 'week' ? 7 : 30;

    // Siapkan data untuk completed dan added tasks
    final List<int> completedTasks = List.filled(dataPoints, 0);
    final List<int> addedTasks = List.filled(dataPoints, 0);

    // Tentukan tanggal awal
    final DateTime now = DateTime.now();
    final DateTime startDate =
        state.trendPeriod == 'week'
            ? now.subtract(const Duration(days: 6))
            : now.subtract(const Duration(days: 29));

    // Hitung jumlah tugas selesai dan dibuat per hari/minggu
    for (final todo in filteredTodos) {
      final createdDate = _dateOnly(todo.createdAt);

      // Cek apakah masuk dalam rentang waktu yang dipilih
      if (createdDate.isAfter(startDate) ||
          createdDate.isAtSameMomentAs(startDate)) {
        final dayDifference = createdDate.difference(startDate).inDays;
        if (dayDifference >= 0 && dayDifference < dataPoints) {
          addedTasks[dayDifference]++;
        }
      }

      // Cek tugas yang selesai
      if (todo.status == 2) {
        // 2 = Completed
        final completedDate = _dateOnly(todo.updatedAt);

        if (completedDate.isAfter(startDate) ||
            completedDate.isAtSameMomentAs(startDate)) {
          final dayDifference = completedDate.difference(startDate).inDays;
          if (dayDifference >= 0 && dayDifference < dataPoints) {
            completedTasks[dayDifference]++;
          }
        }
      }
    }

    state = state.copyWith(
      productivityTrends: {'completed': completedTasks, 'added': addedTasks},
    );
  }

  /// Proses rata-rata waktu penyelesaian
  Future<void> _processCompletionTime(List<TodoModel> todos) async {
    final categoryTimeSum = <String, double>{};
    final categoryCount = <String, int>{};

    // Filter berdasarkan rentang waktu dan tugas yang sudah selesai
    final filteredTodos =
        _filterTodosByDateRange(todos)
            .where((todo) => todo.status == 2) // 2 = Completed
            .toList();

    // Kategorikan berdasarkan tag pertama (jika ada)
    for (final todo in filteredTodos) {
      String category = 'No Tag';

      if (todo.tags.isNotEmpty) {
        category = todo.tags.first.name;
      }

      // Hitung durasi penyelesaian dalam hari
      final createdDate = todo.createdAt;
      final completedDate = todo.updatedAt;
      final durationDays =
          completedDate.difference(createdDate).inDays.toDouble();

      // Simpan data
      categoryTimeSum[category] =
          (categoryTimeSum[category] ?? 0) + durationDays;
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }

    // Hitung rata-rata
    final Map<String, double> averageTime = {};

    for (final category in categoryTimeSum.keys) {
      final sum = categoryTimeSum[category] ?? 0;
      final count = categoryCount[category] ?? 0;

      if (count > 0) {
        averageTime[category] = sum / count;
      }
    }

    state = state.copyWith(averageCompletionTime: averageTime);
  }

  /// Proses jam produktif dalam sehari
  Future<void> _processProductiveHours(List<TodoModel> todos) async {
    final List<int> hourCounts = List.filled(24, 0);

    // Filter berdasarkan rentang waktu
    final filteredTodos = _filterTodosByDateRange(todos);

    // Hitung jumlah tugas yang selesai per jam
    for (final todo in filteredTodos) {
      if (todo.status == 2) {
        // 2 = Completed
        final completedHour = todo.updatedAt.hour;
        hourCounts[completedHour]++;
      }
    }

    state = state.copyWith(productiveHours: hourCounts);
  }

  /// Proses data achievements
  Future<void> _processAchievements(List<TodoModel> todos) async {
    // Filter berdasarkan rentang waktu
    final filteredTodos = _filterTodosByDateRange(todos);

    // Hitung current streak
    int currentStreak = 0;
    int longestStreak = 0;
    double completionRate = 0;

    // Hitung total dan completed
    final totalTodos = filteredTodos.length;
    final completedTodos =
        filteredTodos.where((todo) => todo.status == 2).length;

    // Hitung completion rate
    if (totalTodos > 0) {
      completionRate = completedTodos / totalTodos;
    }

    // Hitung streak
    final Map<DateTime, bool> activityByDate = {};

    // Tandai tanggal dengan aktivitas penyelesaian tugas
    for (final todo in filteredTodos) {
      if (todo.status == 2) {
        // 2 = Completed
        final completedDate = _dateOnly(todo.updatedAt);
        activityByDate[completedDate] = true;
      }
    }

    // Hitung streak saat ini
    DateTime today = _dateOnly(DateTime.now());
    while (activityByDate[today] == true) {
      currentStreak++;
      today = today.subtract(const Duration(days: 1));
    }

    // Hitung longest streak
    int tempStreak = 0;
    final List<DateTime> dates = activityByDate.keys.toList()..sort();

    for (int i = 0; i < dates.length; i++) {
      if (i > 0 && dates[i].difference(dates[i - 1]).inDays == 1) {
        tempStreak++;
      } else {
        tempStreak = 1;
      }

      if (tempStreak > longestStreak) {
        longestStreak = tempStreak;
      }
    }

    // Buat badges berdasarkan pencapaian
    final List<BadgeModel> badges = [
      // Streak badges
      BadgeModel(
        name: 'Week Streak',
        icon: Icons.local_fire_department,
        color: Colors.orange,
        unlocked: currentStreak >= 7,
      ),
      BadgeModel(
        name: 'Month Streak',
        icon: Icons.whatshot,
        color: Colors.deepOrange,
        unlocked: currentStreak >= 30,
      ),

      // Task completion badges
      BadgeModel(
        name: '10 Tasks',
        icon: Icons.assignment_turned_in,
        color: Colors.blue,
        unlocked: completedTodos >= 10,
      ),
      BadgeModel(
        name: '50 Tasks',
        icon: Icons.assignment_turned_in,
        color: Colors.indigo,
        unlocked: completedTodos >= 50,
      ),
      BadgeModel(
        name: '100 Tasks',
        icon: Icons.assignment_turned_in,
        color: Colors.purple,
        unlocked: completedTodos >= 100,
      ),

      // Completion rate badges
      BadgeModel(
        name: '50% Rate',
        icon: Icons.speed,
        color: Colors.amber,
        unlocked: completionRate >= 0.5,
      ),
      BadgeModel(
        name: '80% Rate',
        icon: Icons.speed,
        color: Colors.green,
        unlocked: completionRate >= 0.8,
      ),
    ];

    state = state.copyWith(
      achievements: AchievementsData(
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        completionRate: completionRate,
        badges: badges,
      ),
    );
  }

  /// Helper untuk mendapatkan tanggal saja (tanpa waktu)
  DateTime _dateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Helper untuk memfilter todos berdasarkan rentang waktu yang dipilih
  List<TodoModel> _filterTodosByDateRange(List<TodoModel> todos) {
    final now = DateTime.now();
    DateTime startDate;

    switch (state.dateRange) {
      case DateRange.week:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case DateRange.month:
        startDate = now.subtract(const Duration(days: 30));
        break;
      case DateRange.quarter:
        startDate = now.subtract(const Duration(days: 90));
        break;
      case DateRange.year:
        startDate = now.subtract(const Duration(days: 365));
        break;
      case DateRange.all:
        return todos; // Return semua tanpa filter
    }

    return todos.where((todo) {
      // Filter berdasarkan waktu pembuatan atau penyelesaian tugas
      final createdDate = todo.createdAt;
      final updatedDate = todo.updatedAt;

      return createdDate.isAfter(startDate) ||
          (todo.status == 2 && updatedDate.isAfter(startDate));
    }).toList();
  }
}
