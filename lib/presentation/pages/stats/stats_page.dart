import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/theme/app_typografi.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.ghibliCream,
      body: SafeArea(
        child: Center(
          child: Text(
            'Stats Page',
            style: AppTypography.headline4.copyWith(
              color: AppColors.notionBlack,
            ),
          ),
        ),
      ),
    );
  }
}
