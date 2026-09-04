import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HabitScheduleRule', () {
    test('daily mode schedules every day from start, none before it', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.daily,
        startDate: const LocalDate(2026, 1, 5),
        effectiveFrom: const LocalDate(2026, 1, 5),
      );
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 4)), isFalse);
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 5)), isTrue);
      expect(rule.isScheduledOn(const LocalDate(2026, 6, 1)), isTrue);
    });

    test('daily mode respects an end date', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.daily,
        startDate: const LocalDate(2026, 1, 1),
        endDate: const LocalDate(2026, 1, 10),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 10)), isTrue);
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 11)), isFalse);
    });

    test('weekdays mode only matches selected ISO weekdays', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.weekdays,
        weekdays: const {1, 3, 5}, // Mon, Wed, Fri
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 5)), isTrue); // Mon
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 6)), isFalse); // Tue
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 7)), isTrue); // Wed
    });

    test('interval mode fires every N days from the anchor, across a year boundary', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.interval,
        intervalDays: 3,
        anchorDate: const LocalDate(2025, 12, 30),
        startDate: const LocalDate(2025, 12, 30),
        effectiveFrom: const LocalDate(2025, 12, 30),
      );
      expect(rule.isScheduledOn(const LocalDate(2025, 12, 30)), isTrue);
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 1)), isFalse);
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 2)), isTrue);
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 5)), isTrue);
    });

    test('interval mode never matches before its anchor', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.interval,
        intervalDays: 2,
        anchorDate: const LocalDate(2026, 1, 10),
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      expect(rule.isScheduledOn(const LocalDate(2026, 1, 8)), isFalse);
    });

    test('timesPerWeek mode treats every in-range day as a candidate', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.timesPerWeek,
        weeklyTarget: 3,
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      for (var i = 0; i < 14; i++) {
        expect(rule.isScheduledOn(const LocalDate(2026, 1, 1).addDays(i)), isTrue);
      }
    });
  });

  group('HabitScheduleTimeline', () {
    test('a schedule edit only affects occurrences on/after effectiveFrom', () {
      final original = HabitScheduleRule(
        mode: ScheduleMode.weekdays,
        weekdays: const {1, 2, 3, 4, 5}, // Mon-Fri
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      final edited = HabitScheduleRule(
        mode: ScheduleMode.weekdays,
        weekdays: const {6, 7}, // Sat-Sun only, from Feb 1
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 2, 1),
      );
      final timeline = HabitScheduleTimeline([original, edited]);

      // Jan 5 2026 is a Monday: scheduled under the original weekday rule.
      expect(timeline.isScheduledOn(const LocalDate(2026, 1, 5)), isTrue);
      // Feb 2 2026 is a Monday: NOT scheduled once the edited rule takes over.
      expect(timeline.isScheduledOn(const LocalDate(2026, 2, 2)), isFalse);
      // Feb 1 2026 is a Sunday: scheduled under the edited rule.
      expect(timeline.isScheduledOn(const LocalDate(2026, 2, 1)), isTrue);
    });

    test('occurrencesBetween is bounded to the requested range', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.daily,
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      final occurrences = HabitScheduleTimeline([rule])
          .occurrencesBetween(const LocalDate(2026, 1, 1), const LocalDate(2026, 1, 5));
      expect(occurrences, [
        const LocalDate(2026, 1, 1),
        const LocalDate(2026, 1, 2),
        const LocalDate(2026, 1, 3),
        const LocalDate(2026, 1, 4),
        const LocalDate(2026, 1, 5),
      ]);
    });
  });
}
