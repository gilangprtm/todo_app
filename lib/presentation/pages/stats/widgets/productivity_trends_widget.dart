import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_color.dart';
import '../../../providers/stats/stats_provider.dart';

class ProductivityTrendsWidget extends StatelessWidget {
  const ProductivityTrendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final productivityTrends = ref.watch(
          statsProvider.select((state) => state.productivityTrends),
        );
        final trendPeriod = ref.watch(
          statsProvider.select((state) => state.trendPeriod),
        );

        // Check if we have data
        final completedTasks = productivityTrends['completed'] ?? [];
        final addedTasks = productivityTrends['added'] ?? [];

        if (completedTasks.isEmpty && addedTasks.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No productivity trend data available'),
            ),
          );
        }

        // Get x-axis labels
        final labels = _getLabels(trendPeriod, completedTasks.length);

        return Column(
          children: [
            SizedBox(
              height: 240,
              child: _buildChart(context, completedTasks, addedTasks, labels),
            ),
            const SizedBox(height: 16),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(context, 'Tasks Added', Colors.blue),
                const SizedBox(width: 24),
                _buildLegendItem(context, 'Tasks Completed', Colors.green),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildChart(
    BuildContext context,
    List<int> completedTasks,
    List<int> addedTasks,
    List<String> labels,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
            },
            getDrawingVerticalLine: (value) {
              return FlLine(color: Colors.grey.shade300, strokeWidth: 1);
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 || value.toInt() >= labels.length) {
                    return const SizedBox.shrink();
                  }

                  // Only show some labels to avoid clutter
                  if (labels.length > 10) {
                    if (value.toInt() % 3 != 0 &&
                        value.toInt() != labels.length - 1) {
                      return const SizedBox.shrink();
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[value.toInt()],
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.getTextSecondaryColor(context),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.getTextSecondaryColor(context),
                    ),
                  );
                },
                reservedSize: 28,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade400, width: 1),
              left: BorderSide(color: Colors.grey.shade400, width: 1),
            ),
          ),
          minX: 0,
          maxX: (labels.length - 1).toDouble(),
          minY: 0,
          lineBarsData: [
            // Added tasks line
            LineChartBarData(
              spots:
                  addedTasks.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                  }).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withValues(alpha: 0.1),
              ),
            ),

            // Completed tasks line
            LineChartBarData(
              spots:
                  completedTasks.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.toDouble());
                  }).toList(),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withValues(alpha: 0.1),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipRoundedRadius: 8,
              tooltipPadding: const EdgeInsets.all(8),
              tooltipMargin: 8,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final isAddedLine = spot.barIndex == 0;

                  return LineTooltipItem(
                    '${isAddedLine ? 'Added' : 'Completed'}: ${spot.y.toInt()}',
                    TextStyle(
                      color: isAddedLine ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getTextSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  List<String> _getLabels(String period, int count) {
    if (period == 'week') {
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else {
      // For month, show dates
      final result = <String>[];
      for (int i = 0; i < count; i++) {
        result.add((i + 1).toString());
      }
      return result;
    }
  }
}
