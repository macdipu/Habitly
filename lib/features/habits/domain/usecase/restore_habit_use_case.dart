import 'package:customer/core/domain/usecase/usecase.dart';

import '../repo/habit_repository.dart';

/// Reactivates future scheduling from the restore date; no historical
/// reminders are rescheduled (BRD §S19).
class RestoreHabitUseCase extends UseCaseWithParams<void, String> {
  final HabitRepository _repository;

  const RestoreHabitUseCase(this._repository);

  @override
  ResultVoid call(String habitId) => _repository.restoreHabit(habitId);
}
