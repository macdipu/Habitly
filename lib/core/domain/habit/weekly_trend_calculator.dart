import 'adherence_calculator.dart';
import 'habit_occurrence.dart';
import 'local_date.dart';

/// One calendar week's adherence — [weekStart] is always a Monday.
/// [adherencePercent] is null ("not enough data") for a week with no
/// eligible occurrences (e.g. the habit didn't exist yet).
class WeeklyAdherencePoint {
  final LocalDate weekStart;
  final double? adherencePercent;

  const WeeklyAdherencePoint({required this.weekStart, required this.adherencePercent});
}

/// Buckets occurrences into Monday-start weeks, ascending, to answer "is
/// this habit trending up or down" (BRD §S17 trend chart). Weeks with zero
/// occurrences in the input are never fabricated — only weeks actually
/// present in [occurrences] appear, so a caller with a short range naturally
/// gets a short trend rather than padded empty weeks.
class WeeklyTrendCalculator {
  const WeeklyTrendCalculator();

  List<WeeklyAdherencePoint> weeklyTrend(List<HabitOccurrence> occurrences) {
    const calculator = AdherenceCalculator();
    final byWeekStart = <LocalDate, List<HabitOccurrence>>{};
    for (final occurrence in occurrences) {
      final weekStart = occurrence.date.addDays(-(occurrence.date.weekday - 1));
      byWeekStart.putIfAbsent(weekStart, () => []).add(occurrence);
    }
    final weekStarts = byWeekStart.keys.toList()..sort();
    return weekStarts
        .map((weekStart) => WeeklyAdherencePoint(
              weekStart: weekStart,
              adherencePercent: calculator
                  .adherencePercent(byWeekStart[weekStart]!.map((o) => o.state).toList()),
            ))
        .toList();
  }
}
