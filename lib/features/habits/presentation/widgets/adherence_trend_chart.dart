import 'package:customer/core/domain/habit/weekly_trend_calculator.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/habit_occurrence.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// "Is this habit trending up or down" (BRD §S17) — weekly adherence over
/// the loaded range. Weeks with no eligible occurrences are dropped from
/// the line entirely (see [WeeklyTrendCalculator]) rather than drawn as a
/// misleading 0%.
class AdherenceTrendChart extends StatelessWidget {
  final List<HabitOccurrence> occurrences;

  const AdherenceTrendChart({super.key, required this.occurrences});

  @override
  Widget build(BuildContext context) {
    const calculator = WeeklyTrendCalculator();
    final weeks = calculator
        .weeklyTrend(occurrences.map((o) => (date: o.date, state: o.state)).toList())
        .where((w) => w.adherencePercent != null)
        .toList();

    if (weeks.length < 2) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Not enough weekly data yet',
            style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
          ),
        ),
      );
    }

    final spots = [
      for (final (i, week) in weeks.indexed) FlSpot(i.toDouble(), week.adherencePercent!),
    ];

    return SizedBox(
      height: 140,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 100,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: (weeks.length - 1).toDouble().clamp(1, double.infinity),
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index != 0 && index != weeks.length - 1) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateFormat.MMMd().format(weeks[index].weekStart.toDateTime()),
                      style: context.labelSmall?.copyWith(color: context.onSurfaceVariant),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.2,
              color: context.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: context.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
