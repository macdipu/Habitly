import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/usecase/save_check_in_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_habit_repository.dart';

/// Covers the app's single most-executed write path — the daily check-in
/// tap. Exercises the [SaveCheckInUseCase] -> [HabitSuccessRule] status
/// mapping per habit type, the skip flag, and the "repeated tap updates the
/// same row" invariant (docs/SRS.md FR-33).
void main() {
  final now = DateTime.utc(2026, 1, 20);
  const date = LocalDate(2026, 1, 20);

  HabitEntity buildHabit(HabitType type, {double? target}) => HabitEntity(
        id: 'h1',
        name: 'Test habit',
        type: type,
        icon: 'check',
        color: 0xFF000000,
        target: target,
        createdAt: now,
        updatedAt: now,
      );

  group('SaveCheckInUseCase', () {
    test('binary habit: checking in marks it completed', () async {
      final repo = FakeHabitRepository();
      final habit = buildHabit(HabitType.binary);
      final useCase = SaveCheckInUseCase(repo);

      final result = await useCase(SaveCheckInParams(habit: habit, date: date));

      expect(result.isRight(), isTrue);
      final saved = repo.checkIns['h1|$date']!;
      expect(saved.status, CheckInStatus.completed);
      expect(saved.habitId, 'h1');
      expect(saved.localDate, date);
    });

    test('count habit: logging below target is partial, at/above target is completed', () async {
      final repo = FakeHabitRepository();
      final habit = buildHabit(HabitType.count, target: 8);
      final useCase = SaveCheckInUseCase(repo);

      await useCase(SaveCheckInParams(habit: habit, date: date, value: 3));
      expect(repo.checkIns['h1|$date']!.status, CheckInStatus.partial);

      await useCase(SaveCheckInParams(habit: habit, date: date, value: 8));
      expect(repo.checkIns['h1|$date']!.status, CheckInStatus.completed);
    });

    test('count habit: logging zero or nothing is missed', () async {
      final repo = FakeHabitRepository();
      final habit = buildHabit(HabitType.count, target: 8);
      final useCase = SaveCheckInUseCase(repo);

      await useCase(SaveCheckInParams(habit: habit, date: date, value: 0));

      expect(repo.checkIns['h1|$date']!.status, CheckInStatus.missed);
    });

    test('avoid habit: staying at or under the threshold is completed, over it is missed', () async {
      final repo = FakeHabitRepository();
      final habit = buildHabit(HabitType.avoid, target: 0);
      final useCase = SaveCheckInUseCase(repo);

      await useCase(SaveCheckInParams(habit: habit, date: date, value: 0));
      expect(repo.checkIns['h1|$date']!.status, CheckInStatus.completed);

      await useCase(SaveCheckInParams(habit: habit, date: date, value: 1));
      expect(repo.checkIns['h1|$date']!.status, CheckInStatus.missed);
    });

    test('skip: persists as skipped and drops any logged value', () async {
      final repo = FakeHabitRepository();
      final habit = buildHabit(HabitType.count, target: 8);
      final useCase = SaveCheckInUseCase(repo);

      await useCase(SaveCheckInParams(habit: habit, date: date, value: 5, skip: true));

      final saved = repo.checkIns['h1|$date']!;
      expect(saved.status, CheckInStatus.skipped);
      expect(saved.value, isNull);
    });

    test('repeated check-in on the same day updates the same row, not a duplicate', () async {
      final repo = FakeHabitRepository();
      final habit = buildHabit(HabitType.count, target: 8);
      final useCase = SaveCheckInUseCase(repo);

      await useCase(SaveCheckInParams(habit: habit, date: date, value: 3));
      await useCase(SaveCheckInParams(habit: habit, date: date, value: 8));

      expect(repo.checkIns.length, 1);
      expect(repo.checkIns['h1|$date']!.status, CheckInStatus.completed);
    });
  });
}
