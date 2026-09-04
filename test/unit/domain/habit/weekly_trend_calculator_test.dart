import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/weekly_trend_calculator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const calc = WeeklyTrendCalculator();

  ({LocalDate date, OccurrenceState state}) occ(LocalDate date, OccurrenceState state) =>
      (date: date, state: state);

  group('WeeklyTrendCalculator', () {
    test('empty input yields no weeks — never fabricates padding', () {
      expect(calc.weeklyTrend([]), isEmpty);
    });

    test('groups occurrences into Monday-start weeks, ascending', () {
      final occurrences = [
        // Week of 2026-01-05 (Mon) .. 01-11 (Sun): both completed = 100%.
        occ(const LocalDate(2026, 1, 5), OccurrenceState.completed),
        occ(const LocalDate(2026, 1, 6), OccurrenceState.completed),
        // Week of 2026-01-12 (Mon): one missed, one completed = 50%.
        occ(const LocalDate(2026, 1, 12), OccurrenceState.missed),
        occ(const LocalDate(2026, 1, 13), OccurrenceState.completed),
      ];

      final result = calc.weeklyTrend(occurrences);

      expect(result, hasLength(2));
      expect(result[0].weekStart, const LocalDate(2026, 1, 5));
      expect(result[0].adherencePercent, 100.0);
      expect(result[1].weekStart, const LocalDate(2026, 1, 12));
      expect(result[1].adherencePercent, 50.0);
    });

    test('a week with only skipped/pending occurrences reports null', () {
      final occurrences = [
        occ(const LocalDate(2026, 1, 5), OccurrenceState.skipped),
        occ(const LocalDate(2026, 1, 6), OccurrenceState.pending),
      ];
      final result = calc.weeklyTrend(occurrences);
      expect(result, hasLength(1));
      expect(result.first.adherencePercent, isNull);
    });

    test('a Sunday occurrence buckets into that week\'s Monday, not the next week', () {
      final occurrences = [
        occ(const LocalDate(2026, 1, 11), OccurrenceState.completed), // Sunday
      ];
      final result = calc.weeklyTrend(occurrences);
      expect(result, hasLength(1));
      expect(result.first.weekStart, const LocalDate(2026, 1, 5));
    });
  });
}
