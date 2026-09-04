import 'adherence_calculator.dart';
import 'habit_occurrence.dart';

/// One weekday's adherence within a range — [isoWeekday] 1=Monday..7=Sunday.
/// [adherencePercent] is null ("not enough data") when the habit was never
/// scheduled/eligible on this weekday within the range.
class WeekdayAdherence {
  final int isoWeekday;
  final double? adherencePercent;

  const WeekdayAdherence({required this.isoWeekday, required this.adherencePercent});
}

/// Buckets occurrences by day-of-week to answer "which days do I actually
/// keep this habit on" (BRD §S17 weekday-performance breakdown). Reuses
/// [AdherenceCalculator]'s exact success/eligibility definition per weekday
/// bucket, so a 100% Monday means the same thing a 100% overall adherence
/// does.
class WeekdayPerformanceCalculator {
  const WeekdayPerformanceCalculator();

  List<WeekdayAdherence> byWeekday(List<HabitOccurrence> occurrences) {
    const calculator = AdherenceCalculator();
    return List.generate(7, (i) {
      final isoWeekday = i + 1;
      final states = occurrences
          .where((o) => o.date.weekday == isoWeekday)
          .map((o) => o.state)
          .toList();
      return WeekdayAdherence(
        isoWeekday: isoWeekday,
        adherencePercent: calculator.adherencePercent(states),
      );
    });
  }
}
