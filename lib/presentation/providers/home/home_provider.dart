import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_state.dart';
import 'home_notifier.dart';

/// Provider for Home Screen
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(const HomeState(), ref),
);
