import 'package:flutter/material.dart';
import '../../../core/base/base_state_notifier.dart';
import '../../../data/models/tag_model.dart';
import '../../../data/models/todo_model.dart';

/// State untuk halaman Statistics
class StatsState extends BaseState {
  /// Data aktivitas untuk heat map (key: tanggal, value: jumlah aktivitas)
  final Map<DateTime, int> activityData;

  /// Distribusi tugas berdasarkan tag (key: tag, value: jumlah tugas)
  final Map<TagModel, int> tagDistribution;

  /// Tanggal yang dipilih pada heat map
  final DateTime? selectedDate;

  /// Daftar tugas pada tanggal yang dipilih
  final List<TodoModel> tasksOnSelectedDate;

  /// Tingkat penyelesaian berdasarkan prioritas (key: prioritas (0,1,2), value: persentase selesai)
  final Map<int, double> priorityCompletionRate;

  /// Periode tren yang ditampilkan ('week' atau 'month')
  final String trendPeriod;

  /// Data produktivitas mingguan/bulanan (key: 'completed'/'added', value: list data per periode)
  final Map<String, List<int>> productivityTrends;

  /// Rata-rata waktu penyelesaian (key: kategori, value: rata-rata waktu dalam hari)
  final Map<String, double> averageCompletionTime;

  /// Data jam produktif dalam sehari (indeks: jam 0-23, value: jumlah tugas)
  final List<int> productiveHours;

  /// Data achievement dan badges
  final AchievementsData achievements;

  /// Filter rentang waktu yang ditampilkan
  final DateRange dateRange;

  /// Filter tag yang aktif
  final List<String> activeTagFilters;

  /// Filter prioritas yang aktif
  final List<String> activePriorityFilters;

  StatsState({
    super.isLoading = false,
    super.error,
    super.stackTrace,
    this.activityData = const {},
    this.tagDistribution = const {},
    this.selectedDate,
    this.tasksOnSelectedDate = const [],
    this.priorityCompletionRate = const {},
    this.trendPeriod = 'week',
    this.productivityTrends = const {'completed': [], 'added': []},
    this.averageCompletionTime = const {},
    this.productiveHours = const [],
    this.achievements = const AchievementsData(),
    this.dateRange = DateRange.month,
    this.activeTagFilters = const [],
    this.activePriorityFilters = const [],
  });

  /// Total jumlah tugas untuk chart distribusi tag
  int get totalTasks =>
      tagDistribution.values.fold(0, (sum, count) => sum + count);

  @override
  StatsState copyWith({
    bool? isLoading,
    dynamic error,
    StackTrace? stackTrace,
    bool clearError = false,
    Map<DateTime, int>? activityData,
    Map<TagModel, int>? tagDistribution,
    DateTime? selectedDate,
    bool clearSelectedDate = false,
    List<TodoModel>? tasksOnSelectedDate,
    Map<int, double>? priorityCompletionRate,
    String? trendPeriod,
    Map<String, List<int>>? productivityTrends,
    Map<String, double>? averageCompletionTime,
    List<int>? productiveHours,
    AchievementsData? achievements,
    DateRange? dateRange,
    List<String>? activeTagFilters,
    List<String>? activePriorityFilters,
  }) {
    return StatsState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      stackTrace: clearError ? null : stackTrace ?? this.stackTrace,
      activityData: activityData ?? this.activityData,
      tagDistribution: tagDistribution ?? this.tagDistribution,
      selectedDate:
          clearSelectedDate ? null : selectedDate ?? this.selectedDate,
      tasksOnSelectedDate: tasksOnSelectedDate ?? this.tasksOnSelectedDate,
      priorityCompletionRate:
          priorityCompletionRate ?? this.priorityCompletionRate,
      trendPeriod: trendPeriod ?? this.trendPeriod,
      productivityTrends: productivityTrends ?? this.productivityTrends,
      averageCompletionTime:
          averageCompletionTime ?? this.averageCompletionTime,
      productiveHours: productiveHours ?? this.productiveHours,
      achievements: achievements ?? this.achievements,
      dateRange: dateRange ?? this.dateRange,
      activeTagFilters: activeTagFilters ?? this.activeTagFilters,
      activePriorityFilters:
          activePriorityFilters ?? this.activePriorityFilters,
    );
  }
}

/// Model untuk data achievement
class AchievementsData {
  final int currentStreak;
  final int longestStreak;
  final double completionRate;
  final List<BadgeModel> badges;

  const AchievementsData({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.completionRate = 0.0,
    this.badges = const [],
  });
}

/// Model untuk badge
class BadgeModel {
  final String name;
  final IconData icon;
  final Color color;
  final bool unlocked;

  BadgeModel({
    required this.name,
    required this.icon,
    required this.color,
    this.unlocked = false,
  });
}

/// Enum untuk filter rentang waktu
enum DateRange {
  week('Last 7 days'),
  month('Last 30 days'),
  quarter('Last 3 months'),
  year('Last 12 months'),
  all('All time');

  final String label;
  const DateRange(this.label);
}
