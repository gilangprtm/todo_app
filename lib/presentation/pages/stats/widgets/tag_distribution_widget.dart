import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../data/models/tag_model.dart';
import '../../../providers/stats/stats_provider.dart';

class TagDistributionWidget extends StatelessWidget {
  const TagDistributionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final tagDistribution = ref.watch(
          statsProvider.select((state) => state.tagDistribution),
        );

        if (tagDistribution.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No tag data available'),
            ),
          );
        }

        final totalTasks = tagDistribution.values.fold(
          0,
          (sum, count) => sum + count,
        );

        // Sort tags by count (descending)
        final sortedTags =
            tagDistribution.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

        // Limit to top 10 tags for better visualization
        final displayTags = sortedTags.take(10).toList();

        // Calculate 'Others' category if needed
        int othersCount = 0;
        if (sortedTags.length > 10) {
          othersCount = sortedTags
              .skip(10)
              .fold(0, (sum, entry) => sum + entry.value);
        }

        return Column(
          children: [
            // Pie chart for tag distribution
            SizedBox(
              height: 250,
              child: _buildPieChart(
                context,
                displayTags,
                othersCount,
                totalTasks,
              ),
            ),

            // Legend
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: _buildLegend(context, displayTags, othersCount),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPieChart(
    BuildContext context,
    List<MapEntry<TagModel, int>> tags,
    int othersCount,
    int totalTasks,
  ) {
    // Create pie chart sections
    final sections = <PieChartSectionData>[];

    // Add sections for each tag
    for (int i = 0; i < tags.length; i++) {
      final tag = tags[i].key;
      final count = tags[i].value;
      final percentage = totalTasks > 0 ? count / totalTasks * 100 : 0;

      sections.add(
        PieChartSectionData(
          color: tag.getColor(),
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 85,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: _Badge(
            tag.name.substring(0, tag.name.length > 2 ? 2 : tag.name.length),
            tag.getColor(),
          ),
          badgePositionPercentageOffset: 0.98,
        ),
      );
    }

    // Add 'Others' section if needed
    if (othersCount > 0) {
      final percentage = totalTasks > 0 ? othersCount / totalTasks * 100 : 0;

      sections.add(
        PieChartSectionData(
          color: Colors.grey,
          value: othersCount.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 85,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          badgeWidget: const _Badge('..', Colors.grey),
          badgePositionPercentageOffset: 0.98,
        ),
      );
    }

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {},
        ),
        sections: sections,
        sectionsSpace: 2,
        centerSpaceRadius: 40,
        startDegreeOffset: -90,
      ),
    );
  }

  Widget _buildLegend(
    BuildContext context,
    List<MapEntry<TagModel, int>> tags,
    int othersCount,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        // Tag legends
        ...tags.map(
          (entry) => _buildLegendItem(
            context,
            entry.key.name,
            entry.value,
            entry.key.getColor(),
          ),
        ),

        // 'Others' legend if needed
        if (othersCount > 0)
          _buildLegendItem(context, 'Others', othersCount, Colors.grey),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String name,
    int count,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text('$name ($count)', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
