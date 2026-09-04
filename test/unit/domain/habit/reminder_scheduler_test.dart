import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/quiet_hours.dart';
import 'package:customer/core/domain/habit/reminder_scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const scheduler = ReminderScheduler();

  group('ReminderScheduler.nextDueDate', () {
    test('returns the from-date itself when it is already due', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.daily,
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      expect(scheduler.nextDueDate(rule, const LocalDate(2026, 3, 1)), const LocalDate(2026, 3, 1));
    });

    test('skips forward to the next matching weekday', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.weekdays,
        weekdays: const {1, 5}, // Mon, Fri
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      // 2026-01-06 is a Tuesday -> next Mon/Fri is Fri 2026-01-09.
      expect(scheduler.nextDueDate(rule, const LocalDate(2026, 1, 6)), const LocalDate(2026, 1, 9));
    });

    test('returns null once an end date has passed', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.daily,
        startDate: const LocalDate(2026, 1, 1),
        endDate: const LocalDate(2026, 1, 10),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      expect(scheduler.nextDueDate(rule, const LocalDate(2026, 2, 1)), isNull);
    });

    test('respects interval mode', () {
      final rule = HabitScheduleRule(
        mode: ScheduleMode.interval,
        intervalDays: 3,
        anchorDate: const LocalDate(2026, 1, 1),
        startDate: const LocalDate(2026, 1, 1),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      expect(scheduler.nextDueDate(rule, const LocalDate(2026, 1, 3)), const LocalDate(2026, 1, 4));
    });
  });

  group('ReminderScheduler.nextFireTime', () {
    final dailyRule = HabitScheduleRule(
      mode: ScheduleMode.daily,
      startDate: const LocalDate(2026, 1, 1),
      effectiveFrom: const LocalDate(2026, 1, 1),
    );

    test('uses the reminder time as-is when quiet hours are disabled', () {
      final result = scheduler.nextFireTime(
        rule: dailyRule,
        from: const LocalDate(2026, 3, 1),
        reminderTimeHHmm: '08:00',
      );
      expect(result!.date, const LocalDate(2026, 3, 1));
      expect(result.time, '08:00');
      expect(result.wasShiftedForQuietHours, isFalse);
    });

    test('suppresses (returns null) when the time is inside quiet hours and no shift is requested', () {
      final result = scheduler.nextFireTime(
        rule: dailyRule,
        from: const LocalDate(2026, 3, 1),
        reminderTimeHHmm: '23:00',
        quietHours: const QuietHours(enabled: true, start: '22:00', end: '07:00'),
      );
      expect(result, isNull);
    });

    test('shifts to quiet-hours end, same date, when opted in', () {
      final result = scheduler.nextFireTime(
        rule: dailyRule,
        from: const LocalDate(2026, 3, 1),
        reminderTimeHHmm: '23:00',
        quietHours: const QuietHours(enabled: true, start: '22:00', end: '07:00'),
        shiftToQuietHoursEnd: true,
      );
      expect(result!.date, const LocalDate(2026, 3, 1));
      expect(result.time, '07:00');
      expect(result.wasShiftedForQuietHours, isTrue);
    });

    test('no next occurrence at all -> null regardless of quiet hours', () {
      final endedRule = HabitScheduleRule(
        mode: ScheduleMode.daily,
        startDate: const LocalDate(2026, 1, 1),
        endDate: const LocalDate(2026, 1, 5),
        effectiveFrom: const LocalDate(2026, 1, 1),
      );
      final result = scheduler.nextFireTime(
        rule: endedRule,
        from: const LocalDate(2026, 2, 1),
        reminderTimeHHmm: '08:00',
      );
      expect(result, isNull);
    });
  });
}
