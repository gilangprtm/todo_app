import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/mahas.dart';
import 'base_state_notifier.dart';

/// A ConsumerStatefulWidget that handles the lifecycle of a BaseStateNotifier
class BaseConsumerStatefulWidget extends ConsumerStatefulWidget {
  final Widget Function(BuildContext context, WidgetRef ref) builder;

  const BaseConsumerStatefulWidget({
    super.key,
    required this.builder,
  });

  @override
  ConsumerState<BaseConsumerStatefulWidget> createState() =>
      _BaseConsumerStatefulWidgetState();
}

class _BaseConsumerStatefulWidgetState
    extends ConsumerState<BaseConsumerStatefulWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, ref);
  }

  @override
  void dispose() {
    // Clean up when widget is disposed
    Mahas.clearArguments();
    Mahas.clearParameters();
    super.dispose();
  }
}

/// A widget that automatically handles BaseStateNotifier lifecycle
/// Replaces ProviderPage from the Provider implementation
class StateNotifierConsumerPage<T extends BaseStateNotifier<S>,
    S extends BaseState> extends ConsumerWidget {
  final StateNotifierProvider<T, S> provider;
  final Widget Function(BuildContext context, S state, T notifier) builder;

  const StateNotifierConsumerPage({
    super.key,
    required this.provider,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    // Set context and call onReady (onInit is called in the constructor)
    notifier.setContext(context);

    // Use post-frame callback to ensure onReady is called after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.onReady();
    });

    return builder(context, state, notifier);
  }
}

/// Extension method to access a StateNotifier from a StateNotifierProvider
extension StateNotifierConsumerExtension on WidgetRef {
  /// Get the state notifier from a provider
  T notifier<T extends BaseStateNotifier<S>, S extends BaseState>(
    StateNotifierProvider<T, S> provider,
  ) {
    return read(provider.notifier);
  }

  /// Select a specific part of the state
  R select<T extends BaseStateNotifier<S>, S extends BaseState, R>(
    StateNotifierProvider<T, S> provider,
    R Function(S state) selector,
  ) {
    return watch(provider.select(selector));
  }
}

/// A widget that displays an appropriate widget based on the loading state
class AsyncValueWidget<T> extends ConsumerWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget Function()? loading;

  const AsyncValueWidget({
    super.key,
    required this.asyncValue,
    required this.data,
    this.error,
    this.loading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return asyncValue.when(
      data: data,
      loading:
          loading ?? () => const Center(child: CircularProgressIndicator()),
      error:
          error ?? (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }
}
