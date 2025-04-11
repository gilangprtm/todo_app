import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';
import '../../../../core/mahas/widget/mahas_card.dart';
import '../../../providers/task/task_provider.dart';

class TaskProgressWidget extends StatelessWidget {
  const TaskProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(taskProvider);
        final notifier = ref.read(taskProvider.notifier);

        return MahasCustomizableCard(
          color: Colors.white,
          padding: 16.0,
          margin: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Task Hari Ini",
                    style: AppTypography.subtitle1.copyWith(
                      color: AppColors.getTextPrimaryColor(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () => notifier.toggleTodayFilter(),
                    child: Row(
                      children: [
                        Icon(
                          state.filterByToday
                              ? Icons.calendar_today
                              : Icons.calendar_view_month,
                          size: 16,
                          color: AppColors.getTextSecondaryColor(context),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.filterByToday ? "Hari Ini" : "Semua Task",
                          style: AppTypography.caption.copyWith(
                            color: AppColors.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${state.todos.length} Task",
                          style: AppTypography.headline6.copyWith(
                            color: AppColors.getTextPrimaryColor(context),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${state.completedCount} Selesai",
                          style: AppTypography.bodyText2.copyWith(
                            color: AppColors.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        LinearProgressIndicator(
                          value: state.completionPercentage,
                          backgroundColor: const Color(0xFFE0E0E0),
                          color: const Color(0xFF4CAF50),
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.completionPercentageString,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.getTextSecondaryColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
