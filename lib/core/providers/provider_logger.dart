import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logger untuk provider yang melacak perubahan state
class ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Skip log untuk perubahan state yang tidak perlu dilacak
    if (provider.name?.contains('debug') == true) return;
    if (newValue == previousValue) return;
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (provider.name?.contains('debug') == true) return;
  }
}
