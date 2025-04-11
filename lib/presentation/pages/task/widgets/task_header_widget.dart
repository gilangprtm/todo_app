import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/theme/app_typografi.dart';

class TaskHeaderWidget extends StatelessWidget {
  const TaskHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current date
    final now = DateTime.now();
    final today = DateFormat('EEEE, d MMMM').format(now);

    // Get greeting based on time of day
    final hour = now.hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Selamat Pagi';
    } else if (hour < 17) {
      greeting = 'Selamat Siang';
    } else {
      greeting = 'Selamat Malam';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              today,
              style: AppTypography.bodyText1.copyWith(
                color: AppColors.notionBlack.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              greeting,
              style: AppTypography.headline5.copyWith(
                color: AppColors.notionBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.notionBlack,
          child: const Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }
}
