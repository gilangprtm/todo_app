import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_providers.dart';
import 'stats_notifier.dart';
import 'stats_state.dart';

/// Provider untuk halaman Statistics
final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  final todoService = ref.watch(todoServiceProvider);
  return StatsNotifier(StatsState(), ref, todoService);
});
