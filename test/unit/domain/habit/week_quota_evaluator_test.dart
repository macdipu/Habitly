import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/week_quota_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const evaluator = WeekQuotaEvaluator(); // weeks start Monday
  const c = OccurrenceState.completed;
  const m = OccurrenceState.missed;
  const pending = OccurrenceState.pending;

  MapEntry<LocalDate, OccurrenceState> e(LocalDate d, OccurrenceState s) => MapEntry(d, s);

  group('WeekQuotaEvaluator', () {
    test('weekStartFor snaps any day in the week back to Monday', () {
      // 2026-01-05 is Monday, 2026-01-11 is Sunday of the same week.
      expect(evaluator.weekStartFor(const LocalDate(2026, 1, 11)), const LocalDate(2026, 1, 5));
      expect(evaluator.weekStartFor(const LocalDate(2026, 1, 5)), const LocalDate(2026, 1, 5));
    });

    test('a fully elapsed week meeting quota extends the current streak', () {
      final entries = [
        // Week 1 (Jan 5-11): 3 completions, target 3 -> meets quota.
        e(const LocalDate(2026, 1, 5), c),
        e(const LocalDate(2026, 1, 6), c),
        e(const LocalDate(2026, 1, 7), c),
        e(const LocalDate(2026, 1, 8), m),
        e(const LocalDate(2026, 1, 9), m),
        e(const LocalDate(2026, 1, 10), m),
        e(const LocalDate(2026, 1, 11), m),
        // Week 2 (Jan 12-18): only 2 so far, still in progress "today".
        e(const LocalDate(2026, 1, 12), c),
        e(const LocalDate(2026, 1, 13), c),
      ];
      const today = LocalDate(2026, 1, 13);
      final buckets = evaluator.bucketByWeek(entries, today);
      expect(buckets.length, 2);
      expect(buckets[0].meetsQuota(3), isTrue);
      expect(buckets[0].isFullyElapsed, isTrue);
      expect(buckets[1].isFullyElapsed, isFalse);

      // In-progress week hasn't met quota yet -> not counted, but doesn't break the streak.
      expect(evaluator.currentStreakInWeeks(buckets, 3), 1);
    });

    test('a fully elapsed week missing quota breaks the streak', () {
      final entries = [
        e(const LocalDate(2026, 1, 5), c),
        e(const LocalDate(2026, 1, 6), m),
        e(const LocalDate(2026, 1, 7), m),
        e(const LocalDate(2026, 1, 8), m),
        e(const LocalDate(2026, 1, 9), m),
        e(const LocalDate(2026, 1, 10), m),
        e(const LocalDate(2026, 1, 11), m),
      ];
      const today = LocalDate(2026, 1, 20);
      final buckets = evaluator.bucketByWeek(entries, today);
      expect(evaluator.currentStreakInWeeks(buckets, 3), 0);
    });

    test('bestStreakInWeeks finds the longest historical run of met-quota weeks', () {
      final entries = <MapEntry<LocalDate, OccurrenceState>>[];
      // Weeks of Jan 5, Jan 12: meet quota (3 completions each).
      for (final weekStart in [const LocalDate(2026, 1, 5), const LocalDate(2026, 1, 12)]) {
        entries.add(e(weekStart, c));
        entries.add(e(weekStart.addDays(1), c));
        entries.add(e(weekStart.addDays(2), c));
        entries.add(e(weekStart.addDays(3), m));
      }
      // Week of Jan 19: misses quota.
      entries.add(e(const LocalDate(2026, 1, 19), m));
      const today = LocalDate(2026, 1, 26);
      final buckets = evaluator.bucketByWeek(entries, today);
      expect(evaluator.bestStreakInWeeks(buckets, 3), 2);
    });

    test('pending days within an in-progress week are tolerated, not treated as failures', () {
      final entries = [
        e(const LocalDate(2026, 1, 5), c),
        e(const LocalDate(2026, 1, 6), c),
        e(const LocalDate(2026, 1, 7), c),
        e(const LocalDate(2026, 1, 8), pending),
      ];
      const today = LocalDate(2026, 1, 8);
      final buckets = evaluator.bucketByWeek(entries, today);
      expect(evaluator.currentStreakInWeeks(buckets, 3), 1);
    });
  });
}
