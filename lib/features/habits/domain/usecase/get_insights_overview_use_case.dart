import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../entity/habit_entity.dart';
import '../entity/habit_insight.dart';
import '../repo/habit_repository.dart';
import 'get_habit_stats_use_case.dart';

/// Number of trailing days (inclusive of today) to summarize.
class GetInsightsOverviewParams {
  final int rangeDays;

  const GetInsightsOverviewParams({this.rangeDays = 30});
}

/// Streak/adherence for every active habit, ranked by current streak
/// (BRD §S16 "Habit ranking table"). Per-habit computation reuses
/// [GetHabitStatsUseCase] — no duplicated logic.
class GetInsightsOverviewUseCase
    extends UseCaseWithParams<List<HabitInsight>, GetInsightsOverviewParams> {
  final HabitRepository _repository;
  final GetHabitStatsUseCase _getStats;

  GetInsightsOverviewUseCase(this._repository) : _getStats = GetHabitStatsUseCase(_repository);

  @override
  ResultFuture<List<HabitInsight>> call(GetInsightsOverviewParams params) async {
    Failure? failure;

    final habitsResult = await _repository.getActiveHabits();
    final habits = habitsResult.fold((l) {
      failure = l;
      return <HabitEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final today = LocalDate.fromDateTime(DateTime.now());
    final from = today.addDays(-(params.rangeDays - 1));

    final insights = <HabitInsight>[];
    for (final habit in habits) {
      final statsResult =
          await _getStats(GetHabitStatsParams(habitId: habit.id, from: from, to: today));
      statsResult.fold((_) {}, (stats) => insights.add(HabitInsight(habit: habit, stats: stats)));
    }

    insights.sort((a, b) => b.stats.currentStreak.compareTo(a.stats.currentStreak));
    return Right(insights);
  }
}
