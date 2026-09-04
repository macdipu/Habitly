import 'adherence_calculator.dart';
import 'habit_enums.dart';
import 'local_date.dart';

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
///
/// Takes `(date, state)` records rather than the feature layer's
/// `HabitOccurrence` — this file lives in `core/domain/`, which CLAUDE.md
/// forbids from importing `features/` entities. Callers map their
/// occurrence list to records before calling in.
class WeekdayPerformanceCalculator {
  const WeekdayPerformanceCalculator();

  List<WeekdayAdherence> byWeekday(
      List<({LocalDate date, OccurrenceState state})> occurrences) {
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
