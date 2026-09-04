import 'package:customer/core/domain/usecase/usecase.dart';

import '../repo/habit_repository.dart';

/// Stops future scheduling/reminders while preserving all history
/// (BRD Core Rule "Archive", §S19).
class ArchiveHabitUseCase extends UseCaseWithParams<void, String> {
  final HabitRepository _repository;

  const ArchiveHabitUseCase(this._repository);

  @override
  ResultVoid call(String habitId) => _repository.archiveHabit(habitId);
}
