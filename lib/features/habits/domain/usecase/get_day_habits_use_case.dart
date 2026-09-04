import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../entity/habit_entity.dart';
import '../entity/today_habit_item.dart';
import '../repo/habit_repository.dart';
import 'get_habit_occurrences_use_case.dart';

/// Generalization of [GetTodayHabitsUseCase] for an arbitrary calendar date
/// — powers Day Detail (S15) and, per-habit, the Calendar month aggregate
/// (S14). Reuses [GetHabitOccurrencesUseCase] so "today" for
/// pending/missed resolution is always the real current date, never the
/// date being viewed (docs/SRS.md FR-41).
class GetDayHabitsUseCase extends UseCaseWithParams<List<TodayHabitItem>, LocalDate> {
  final HabitRepository _repository;
  final GetHabitOccurrencesUseCase _getOccurrences;

  GetDayHabitsUseCase(this._repository) : _getOccurrences = GetHabitOccurrencesUseCase(_repository);

  @override
  ResultFuture<List<TodayHabitItem>> call(LocalDate date) async {
    Failure? failure;

    final habitsResult = await _repository.getActiveHabits();
    final habits = habitsResult.fold((l) {
      failure = l;
      return <HabitEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final items = <TodayHabitItem>[];
    for (final habit in habits) {
      final occurrencesResult = await _getOccurrences(
        GetHabitOccurrencesParams(habitId: habit.id, from: date, to: date),
      );
      final occurrence = occurrencesResult.fold((_) => null, (r) => r.isEmpty ? null : r.first);
      if (occurrence == null || occurrence.state == OccurrenceState.notScheduled) continue;

      items.add(TodayHabitItem(habit: habit, state: occurrence.state, checkIn: occurrence.checkIn));
    }

    return Right(items);
  }
}
