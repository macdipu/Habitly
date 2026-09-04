import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/habit_entity.dart';
import '../entity/habit_schedule_entity.dart';
import '../entity/reminder_entity.dart';
import '../repo/habit_repository.dart';

class UpdateHabitParams {
  final HabitEntity habit;

  /// A new append-only schedule row, or null when the recurrence pattern
  /// itself hasn't changed (docs/SRS.md FR-13 — never mutate a past rule).
  final HabitScheduleEntity? newSchedule;

  /// The full current reminder set. Reminders aren't historical data, so
  /// unlike schedules they're simply replaced wholesale.
  final List<ReminderEntity>? reminders;

  const UpdateHabitParams({required this.habit, this.newSchedule, this.reminders});
}

/// Updates a habit's definition without corrupting history (BRD §S13):
/// never touches existing `CheckIn` rows, and only appends a new schedule
/// row when the recurrence pattern actually changed.
class UpdateHabitUseCase extends UseCaseWithParams<void, UpdateHabitParams> {
  final HabitRepository _repository;

  const UpdateHabitUseCase(this._repository);

  @override
  ResultVoid call(UpdateHabitParams params) {
    return _repository.updateHabit(
      habit: params.habit,
      newSchedule: params.newSchedule,
      reminders: params.reminders,
    );
  }
}
