import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/weekday_performance_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calc = WeekdayPerformanceCalculator();

  // 2026-01-05 is a Monday; 2026-01-06 a Tuesday; 2026-01-12 the next Monday.
  ({LocalDate date, OccurrenceState state}) occ(LocalDate date, OccurrenceState state) =>
      (date: date, state: state);

  group('WeekdayPerformanceCalculator', () {
    test('returns 7 entries, one per ISO weekday, in order', () {
      final result = calc.byWeekday([]);
      expect(result.map((w) => w.isoWeekday).toList(), [1, 2, 3, 4, 5, 6, 7]);
    });

    test('a weekday with no eligible occurrences is null ("not enough data")', () {
      final result = calc.byWeekday([]);
      expect(result.every((w) => w.adherencePercent == null), isTrue);
    });

    test('buckets occurrences by day-of-week across different weeks', () {
      final occurrences = [
        occ(const LocalDate(2026, 1, 5), OccurrenceState.completed), // Mon
        occ(const LocalDate(2026, 1, 12), OccurrenceState.missed), // Mon (next week)
        occ(const LocalDate(2026, 1, 6), OccurrenceState.completed), // Tue
      ];
      final result = calc.byWeekday(occurrences);

      final monday = result.firstWhere((w) => w.isoWeekday == 1);
      final tuesday = result.firstWhere((w) => w.isoWeekday == 2);
      final wednesday = result.firstWhere((w) => w.isoWeekday == 3);

      expect(monday.adherencePercent, 50.0);
      expect(tuesday.adherencePercent, 100.0);
      expect(wednesday.adherencePercent, isNull);
    });

    test('skipped occurrences do not affect the weekday they fall on', () {
      final occurrences = [
        occ(const LocalDate(2026, 1, 5), OccurrenceState.completed), // Mon
        occ(const LocalDate(2026, 1, 12), OccurrenceState.skipped), // Mon
      ];
      final monday = calc.byWeekday(occurrences).firstWhere((w) => w.isoWeekday == 1);
      expect(monday.adherencePercent, 100.0);
    });
  });
}
