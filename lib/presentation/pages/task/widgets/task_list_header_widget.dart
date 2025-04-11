import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';

class TaskListHeaderWidget extends StatelessWidget {
  const TaskListHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Daftar Task",
          style: AppTypography.subtitle1.copyWith(
            color: AppColors.notionBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Status legend
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Pending",
              style: AppTypography.caption.copyWith(
                color: AppColors.notionBlack.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "In Progress",
              style: AppTypography.caption.copyWith(
                color: AppColors.notionBlack.withOpacity(0.6),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Completed",
              style: AppTypography.caption.copyWith(
                color: AppColors.notionBlack.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
