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
            color: AppColors.getTextPrimaryColor(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        // Status legend
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.getStatusColor(context, 0),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Pending",
              style: AppTypography.caption.copyWith(
                color: AppColors.getTextSecondaryColor(context),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.getStatusColor(context, 1),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "In Progress",
              style: AppTypography.caption.copyWith(
                color: AppColors.getTextSecondaryColor(context),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.getStatusColor(context, 2),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "Completed",
              style: AppTypography.caption.copyWith(
                color: AppColors.getTextSecondaryColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
