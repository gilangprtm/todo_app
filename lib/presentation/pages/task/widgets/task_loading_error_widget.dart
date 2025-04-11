import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';
import '../../../providers/task/task_provider.dart';

class TaskLoadingErrorWidget extends ConsumerWidget {
  const TaskLoadingErrorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskProvider);

    // Loading indicator
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Error message
    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(
                "Terjadi kesalahan saat memuat data",
                style: AppTypography.bodyText1.copyWith(
                  color: AppColors.notionBlack,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(taskProvider.notifier).loadTodos(),
                child: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    // Return empty container if no loading or error
    return const SizedBox.shrink();
  }
}
