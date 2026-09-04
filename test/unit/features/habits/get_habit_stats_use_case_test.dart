import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/features/habits/domain/entity/check_in_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/usecase/get_habit_stats_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_habit_repository.dart';

void main() {
  final now = DateTime.utc(2026, 1, 20);

  HabitEntity buildHabit(String id, HabitType type, {double? target}) => HabitEntity(
        id: id,
        name: 'Test habit',
        type: type,
        icon: 'check',
        color: 0xFF000000,
        target: target,
        createdAt: now,
        updatedAt: now,
      );

  CheckInEntity buildCheckIn(String habitId, LocalDate date, CheckInStatus status) => CheckInEntity(
        id: '$habitId-$date',
        habitId: habitId,
        localDate: date,
        status: status,
        createdAt: now,
        updatedAt: now,
      );

  group('GetHabitStatsUseCase — daily habit', () {
    test('computes current/best streak and adherence from real check-in rows', () async {
      final repo = FakeHabitRepository();
      const habitId = 'daily-1';
      repo.habits[habitId] = buildHabit(habitId, HabitType.binary);
      repo.schedules[habitId] = [
        HabitScheduleEntity(
          id: 's1',
          habitId: habitId,
          rule: HabitScheduleRule(
            mode: ScheduleMode.daily,
            startDate: const LocalDate(2026, 1, 10),
            effectiveFrom: const LocalDate(2026, 1, 10),
          ),
        ),
      ];

      // Jan 10-14: completed. Jan 15: missed (no check-in). Jan 16-18: completed.
      for (final d in [10, 11, 12, 13, 14]) {
        final date = LocalDate(2026, 1, d);
        repo.checkIns['$habitId|$date'] = buildCheckIn(habitId, date, CheckInStatus.completed);
      }
      for (final d in [16, 17, 18]) {
        final date = LocalDate(2026, 1, d);
        repo.checkIns['$habitId|$date'] = buildCheckIn(habitId, date, CheckInStatus.completed);
      }

      final useCase = GetHabitStatsUseCase(repo);
      final result = await useCase(GetHabitStatsParams(
        habitId: habitId,
        from: const LocalDate(2026, 1, 10),
        to: const LocalDate(2026, 1, 18),
      ));

      final stats = result.fold((l) => throw StateError('unexpected failure: $l'), (r) => r);
      expect(stats.currentStreak, 3); // Jan 16-18, stopped by the Jan 15 miss
      expect(stats.bestStreak, 5); // Jan 10-14
      expect(stats.adherencePercent, closeTo(8 / 9 * 100, 0.01));
    });
  });

  group('GetHabitStatsUseCase — timesPerWeek habit', () {
    test('uses week buckets, not per-day streaks', () async {
      final repo = FakeHabitRepository();
      const habitId = 'weekly-1';
      repo.habits[habitId] = buildHabit(habitId, HabitType.binary);
      repo.schedules[habitId] = [
        HabitScheduleEntity(
          id: 's1',
          habitId: habitId,
          rule: const HabitScheduleRule(
            mode: ScheduleMode.timesPerWeek,
            weeklyTarget: 3,
            startDate: LocalDate(2026, 1, 5),
            effectiveFrom: LocalDate(2026, 1, 5),
          ),
        ),
      ];

      // Week of Jan 5 (Mon-Sun): 3 completions -> meets quota.
      for (final d in [5, 6, 7]) {
        final date = LocalDate(2026, 1, d);
        repo.checkIns['$habitId|$date'] = buildCheckIn(habitId, date, CheckInStatus.completed);
      }
      // Week of Jan 12: only 2 completions -> misses quota.
      for (final d in [12, 13]) {
        final date = LocalDate(2026, 1, d);
        repo.checkIns['$habitId|$date'] = buildCheckIn(habitId, date, CheckInStatus.completed);
      }

      final useCase = GetHabitStatsUseCase(repo);
      final result = await useCase(GetHabitStatsParams(
        habitId: habitId,
        from: const LocalDate(2026, 1, 5),
        to: const LocalDate(2026, 1, 18),
      ));

      final stats = result.fold((l) => throw StateError('unexpected failure: $l'), (r) => r);
      expect(stats.bestStreak, 1); // only the Jan 5 week met quota
      expect(stats.currentStreak, 0); // Jan 12 week is fully elapsed and missed quota
    });
  });
}
