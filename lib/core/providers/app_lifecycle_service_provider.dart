import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/app_lifecycle_service.dart';

/// Provider untuk AppLifecycleService
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  final service = AppLifecycleService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});
