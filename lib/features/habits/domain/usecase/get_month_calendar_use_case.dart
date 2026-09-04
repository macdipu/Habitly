import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/calendar_day_aggregator.dart';
import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../entity/habit_entity.dart';
import '../repo/habit_repository.dart';
import 'get_habit_occurrences_use_case.dart';

/// Any date within the target month — only year/month are used.
class GetMonthCalendarParams {
  final int year;
  final int month;

  const GetMonthCalendarParams({required this.year, required this.month});

  LocalDate get firstDay => LocalDate(year, month, 1);

  LocalDate get lastDay {
    final daysInMonth = DateTime.utc(year, month + 1, 0).day;
    return LocalDate(year, month, daysInMonth);
  }
}

/// One [CalendarDayStatus] per day in the month, aggregated across every
/// active habit (BRD §S14). Per-habit filtering is a later pass — see
/// docs/ARCHITECTURE.md §9.
class GetMonthCalendarUseCase
    extends UseCaseWithParams<Map<LocalDate, CalendarDayStatus>, GetMonthCalendarParams> {
  final HabitRepository _repository;
  final GetHabitOccurrencesUseCase _getOccurrences;
  final CalendarDayAggregator _aggregator;

  GetMonthCalendarUseCase(
    this._repository, {
    CalendarDayAggregator aggregator = const CalendarDayAggregator(),
  })  : _getOccurrences = GetHabitOccurrencesUseCase(_repository),
        _aggregator = aggregator;

  @override
  ResultFuture<Map<LocalDate, CalendarDayStatus>> call(GetMonthCalendarParams params) async {
    Failure? failure;

    final habitsResult = await _repository.getActiveHabits();
    final habits = habitsResult.fold((l) {
      failure = l;
      return <HabitEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final statesByDay = <LocalDate, List<OccurrenceState>>{};
    var cursor = params.firstDay;
    while (!cursor.isAfter(params.lastDay)) {
      statesByDay[cursor] = [];
      cursor = cursor.addDays(1);
    }

    for (final habit in habits) {
      final occurrencesResult = await _getOccurrences(
        GetHabitOccurrencesParams(habitId: habit.id, from: params.firstDay, to: params.lastDay),
      );
      occurrencesResult.fold((_) {}, (occurrences) {
        for (final occurrence in occurrences) {
          statesByDay[occurrence.date]?.add(occurrence.state);
        }
      });
    }

    return Right(statesByDay.map((day, states) => MapEntry(day, _aggregator.aggregate(states))));
  }
}
