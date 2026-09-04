import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/habit_entity.dart';
import '../entity/habit_schedule_entity.dart';
import '../entity/reminder_entity.dart';
import '../repo/habit_repository.dart';

class CreateHabitParams {
  final HabitEntity habit;
  final HabitScheduleEntity schedule;
  final List<ReminderEntity> reminders;

  const CreateHabitParams({
    required this.habit,
    required this.schedule,
    this.reminders = const [],
  });
}

/// Persists a new habit atomically (docs/SRS.md FR-12). Notification
/// scheduling happens separately, after this succeeds, so a scheduling
/// failure never loses the habit itself.
class CreateHabitUseCase extends UseCaseWithParams<void, CreateHabitParams> {
  final HabitRepository _repository;

  const CreateHabitUseCase(this._repository);

  @override
  ResultVoid call(CreateHabitParams params) {
    return _repository.createHabit(
      habit: params.habit,
      schedule: params.schedule,
      reminders: params.reminders,
    );
  }
}
