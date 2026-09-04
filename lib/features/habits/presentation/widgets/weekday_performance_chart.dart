import 'package:customer/core/domain/habit/weekday_performance_calculator.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/habit_occurrence.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

/// "Which days do I actually keep this habit on" (BRD §S17). A gray bar
/// means "not enough data" for that weekday within range — never a red or
/// alarming color, same neutral-not-shaming rule as the rest of the app.
class WeekdayPerformanceChart extends StatelessWidget {
  final List<HabitOccurrence> occurrences;

  const WeekdayPerformanceChart({super.key, required this.occurrences});

  @override
  Widget build(BuildContext context) {
    const calculator = WeekdayPerformanceCalculator();
    final byWeekday = calculator.byWeekday(
      occurrences.map((o) => (date: o.date, state: o.state)).toList(),
    );

    final hasAnyData = byWeekday.any((w) => w.adherencePercent != null);
    if (!hasAnyData) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Not enough data yet',
            style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: BarChart(
        BarChartData(
          maxY: 100,
          minY: 0,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index > 6) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      _weekdayLabels[index],
                      style: context.labelSmall?.copyWith(color: context.onSurfaceVariant),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: List.generate(7, (i) {
            final percent = byWeekday[i].adherencePercent;
            final hasData = percent != null;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: hasData ? percent : 4,
                  color: hasData ? context.primary : context.neutralMiss,
                  width: 18,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
