import 'package:dartz/dartz.dart';

import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/occurrence_resolver.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/habit_schedule_entity.dart';
import '../entity/today_habit_item.dart';
import '../repo/habit_repository.dart';

/// Composes the repository with the pure recurrence/occurrence engine to
/// answer "what is due today and what's its state" (BRD §S05) — the one
/// piece of business logic the Today screen needs.
class GetTodayHabitsUseCase extends UseCaseWithParams<List<TodayHabitItem>, LocalDate> {
  final HabitRepository _repository;
  final OccurrenceResolver _resolver;

  const GetTodayHabitsUseCase(
    this._repository, {
    OccurrenceResolver resolver = const OccurrenceResolver(),
  }) : _resolver = resolver;

  @override
  ResultFuture<List<TodayHabitItem>> call(LocalDate today) async {
    final habits = await _unwrap(await _repository.getActiveHabits());
    if (habits.isLeft) return Left(habits.failure!);

    final checkIns = await _unwrap(await _repository.getCheckInsForDate(today));
    if (checkIns.isLeft) return Left(checkIns.failure!);

    final checkInByHabit = {for (final c in checkIns.value!) c.habitId: c};
    final items = <TodayHabitItem>[];

    for (final habit in habits.value!) {
      final schedulesResult = await _repository.getSchedules(habit.id);
      final schedules = await _unwrap(schedulesResult);
      if (schedules.isLeft) continue; // skip a habit whose schedule failed to load

      if (!_isScheduledToday(schedules.value!, today)) continue;

      final checkIn = checkInByHabit[habit.id];
      final state = _resolver.resolve(
        date: today,
        today: today,
        isScheduled: true,
        checkIn:
            checkIn == null ? null : CheckInRecord(status: checkIn.status, value: checkIn.value),
      );
      items.add(TodayHabitItem(habit: habit, state: state, checkIn: checkIn));
    }

    return Right(items);
  }

  bool _isScheduledToday(List<HabitScheduleEntity> schedules, LocalDate today) {
    final rules = schedules.map((s) => s.rule).toList();
    return HabitScheduleTimeline(rules).isScheduledOn(today);
  }

  Future<_Unwrapped<T>> _unwrap<T>(Either<Failure, T> either) async {
    Failure? failure;
    T? value;
    either.fold((l) => failure = l, (r) => value = r);
    return _Unwrapped(failure: failure, value: value);
  }
}

class _Unwrapped<T> {
  final Failure? failure;
  final T? value;
  const _Unwrapped({this.failure, this.value});
  bool get isLeft => failure != null;
}
