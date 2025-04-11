import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';

class TaskEmptyWidget extends StatelessWidget {
  const TaskEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 64,
            color: AppColors.notionBlack.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Tidak ada task hari ini",
            style: AppTypography.headline6.copyWith(
              color: AppColors.notionBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tambahkan task baru dengan tombol + di bawah",
            style: AppTypography.bodyText2.copyWith(
              color: AppColors.notionBlack.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
