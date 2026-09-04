import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/occurrence_resolver.dart';
import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../entity/check_in_entity.dart';
import '../entity/habit_occurrence.dart';
import '../entity/habit_schedule_entity.dart';
import '../repo/habit_repository.dart';

class GetHabitOccurrencesParams {
  final String habitId;
  final LocalDate from;
  final LocalDate to;

  const GetHabitOccurrencesParams({required this.habitId, required this.from, required this.to});
}

/// Resolves every calendar day in `[from, to]` for one habit into a
/// [HabitOccurrence] — the shared building block behind Habit Detail,
/// Calendar, Day Detail, and Insights (docs/ARCHITECTURE.md §3). Includes
/// `notScheduled` days too; callers filter them out where the BRD requires
/// it (e.g. streak/adherence calculators already ignore them).
class GetHabitOccurrencesUseCase
    extends UseCaseWithParams<List<HabitOccurrence>, GetHabitOccurrencesParams> {
  final HabitRepository _repository;
  final OccurrenceResolver _resolver;

  const GetHabitOccurrencesUseCase(
    this._repository, {
    OccurrenceResolver resolver = const OccurrenceResolver(),
  }) : _resolver = resolver;

  @override
  ResultFuture<List<HabitOccurrence>> call(GetHabitOccurrencesParams params) async {
    Failure? failure;

    final schedulesResult = await _repository.getSchedules(params.habitId);
    final schedules = schedulesResult.fold((l) {
      failure = l;
      return <HabitScheduleEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final checkInsResult =
        await _repository.getCheckIns(habitId: params.habitId, from: params.from, to: params.to);
    final checkIns = checkInsResult.fold((l) {
      failure = l;
      return <CheckInEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final checkInByDate = {for (final c in checkIns) c.localDate: c};
    final timeline = HabitScheduleTimeline(schedules.map((s) => s.rule).toList());
    final today = LocalDate.fromDateTime(DateTime.now());

    final occurrences = <HabitOccurrence>[];
    var cursor = params.from;
    while (!cursor.isAfter(params.to)) {
      final isScheduled = timeline.isScheduledOn(cursor);
      final checkIn = checkInByDate[cursor];
      final state = _resolver.resolve(
        date: cursor,
        today: today,
        isScheduled: isScheduled,
        checkIn:
            checkIn == null ? null : CheckInRecord(status: checkIn.status, value: checkIn.value),
      );
      occurrences.add(HabitOccurrence(date: cursor, state: state, checkIn: checkIn));
      cursor = cursor.addDays(1);
    }

    return Right(occurrences);
  }
}
