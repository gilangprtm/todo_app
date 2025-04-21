import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/stats/stats_provider.dart';

class PriorityCompletionWidget extends StatelessWidget {
  const PriorityCompletionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final priorityCompletionRate = ref.watch(
          statsProvider.select((state) => state.priorityCompletionRate),
        );

        if (priorityCompletionRate.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No priority completion data available'),
            ),
          );
        }

        return Column(
          children: [
            // Priority bars
            _buildPriorityBar(
              context,
              'High Priority',
              priorityCompletionRate[2] ?? 0,
              Colors.red,
            ),
            const SizedBox(height: 16),
            _buildPriorityBar(
              context,
              'Medium Priority',
              priorityCompletionRate[1] ?? 0,
              Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildPriorityBar(
              context,
              'Low Priority',
              priorityCompletionRate[0] ?? 0,
              Colors.green,
            ),
          ],
        );
      },
    );
  }

  Widget _buildPriorityBar(
    BuildContext context,
    String label,
    double completionRate,
    Color color,
  ) {
    final percentage = (completionRate * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(
              '$percentage%',
              style: TextStyle(
                color: AppColors.getTextSecondaryColor(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Completion bar
        Stack(
          children: [
            // Background
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            // Foreground
            FractionallySizedBox(
              widthFactor: completionRate,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
