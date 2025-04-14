import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/calendar/calendar_provider.dart';

class TaskListHeaderWidget extends ConsumerWidget {
  const TaskListHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(
      calendarProvider.select((state) => state.selectedDay),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        selectedDay != null
            ? 'Tasks for ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}'
            : 'Tasks',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.getTextPrimaryColor(context),
        ),
      ),
    );
  }
}
