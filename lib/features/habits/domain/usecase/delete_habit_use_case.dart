import 'package:customer/core/domain/usecase/usecase.dart';

import '../repo/habit_repository.dart';

/// Permanent removal. The presentation layer must obtain explicit
/// confirmation before calling this (BRD §S26) — this usecase does not
/// re-confirm.
class DeleteHabitUseCase extends UseCaseWithParams<void, String> {
  final HabitRepository _repository;

  const DeleteHabitUseCase(this._repository);

  @override
  ResultVoid call(String habitId) => _repository.deleteHabit(habitId);
}
