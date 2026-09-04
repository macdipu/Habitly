import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/adherence_calculator.dart';
import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/streak_calculator.dart';
import 'package:customer/core/domain/habit/week_quota_evaluator.dart';
import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../entity/habit_occurrence.dart';
import '../entity/habit_schedule_entity.dart';
import '../entity/habit_stats.dart';
import '../repo/habit_repository.dart';
import 'get_habit_occurrences_use_case.dart';

class GetHabitStatsParams {
  final String habitId;
  final LocalDate from;
  final LocalDate to;

  const GetHabitStatsParams({required this.habitId, required this.from, required this.to});
}

/// Composes [GetHabitOccurrencesUseCase] with the pure streak/adherence
/// calculators (docs/ARCHITECTURE.md §3). `timesPerWeek` habits use
/// [WeekQuotaEvaluator] instead of [StreakCalculator] since a week, not a
/// day, is the streak unit under that schedule mode (docs/SRS.md decision 4).
class GetHabitStatsUseCase extends UseCaseWithParams<HabitStats, GetHabitStatsParams> {
  final HabitRepository _repository;
  final GetHabitOccurrencesUseCase _getOccurrences;

  GetHabitStatsUseCase(this._repository) : _getOccurrences = GetHabitOccurrencesUseCase(_repository);

  @override
  ResultFuture<HabitStats> call(GetHabitStatsParams params) async {
    Failure? failure;

    final occurrencesResult = await _getOccurrences(
      GetHabitOccurrencesParams(habitId: params.habitId, from: params.from, to: params.to),
    );
    final occurrences = occurrencesResult.fold((l) {
      failure = l;
      return <HabitOccurrence>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final schedulesResult = await _repository.getSchedules(params.habitId);
    final schedules = schedulesResult.fold((l) {
      failure = l;
      return <HabitScheduleEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final states = occurrences.map((o) => o.state).toList();
    final adherence = const AdherenceCalculator().adherencePercent(states);

    final latestMode = schedules.isEmpty ? ScheduleMode.daily : schedules.last.rule.mode;

    int currentStreak;
    int bestStreak;

    if (latestMode == ScheduleMode.timesPerWeek) {
      final weeklyTarget = schedules.last.rule.weeklyTarget ?? 1;
      final evaluator = const WeekQuotaEvaluator();
      final entries = occurrences
          .where((o) => o.state != OccurrenceState.notScheduled)
          .map((o) => MapEntry(o.date, o.state))
          .toList();
      final buckets = evaluator.bucketByWeek(entries, LocalDate.fromDateTime(DateTime.now()));
      currentStreak = evaluator.currentStreakInWeeks(buckets, weeklyTarget);
      bestStreak = evaluator.bestStreakInWeeks(buckets, weeklyTarget);
    } else {
      final scheduledStates =
          occurrences.where((o) => o.state != OccurrenceState.notScheduled).map((o) => o.state).toList();
      const calculator = StreakCalculator();
      currentStreak = calculator.currentStreak(scheduledStates);
      bestStreak = calculator.bestStreak(scheduledStates);
    }

    return Right(HabitStats(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      adherencePercent: adherence,
      occurrences: occurrences,
    ));
  }
}
