import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../repo/habit_repository.dart';

class UndoCheckInParams {
  final String habitId;
  final LocalDate date;

  const UndoCheckInParams({required this.habitId, required this.date});
}

/// Reverses a check-in immediately, with no confirmation dialog — undo is
/// non-destructive and expected to be as fast as the original tap
/// (docs/SRS.md FR-21).
class UndoCheckInUseCase extends UseCaseWithParams<void, UndoCheckInParams> {
  final HabitRepository _repository;

  const UndoCheckInUseCase(this._repository);

  @override
  ResultVoid call(UndoCheckInParams params) =>
      _repository.deleteCheckIn(habitId: params.habitId, localDate: params.date);
}
