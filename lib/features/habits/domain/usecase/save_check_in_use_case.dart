import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_success_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/check_in_entity.dart';
import '../entity/habit_entity.dart';
import '../repo/habit_repository.dart';

class SaveCheckInParams {
  final HabitEntity habit;
  final LocalDate date;

  /// Raw logged amount for count/duration habits, or the slip amount for
  /// avoid habits. Ignored (treated as 1) for binary habits when [skip] is
  /// false.
  final double? value;

  final bool skip;
  final String? note;

  const SaveCheckInParams({
    required this.habit,
    required this.date,
    this.value,
    this.skip = false,
    this.note,
  });
}

/// Resolves a logged value into a [CheckInStatus] via [HabitSuccessRule] and
/// persists it. One check-in per (habit, date) — a repeated tap updates the
/// same row rather than creating a new one (docs/SRS.md FR-33).
class SaveCheckInUseCase extends UseCaseWithParams<void, SaveCheckInParams> {
  final HabitRepository _repository;

  const SaveCheckInUseCase(this._repository);

  @override
  ResultVoid call(SaveCheckInParams params) {
    final now = DateTime.now().toUtc();
    final status = params.skip
        ? CheckInStatus.skipped
        : HabitSuccessRule(type: params.habit.type, target: params.habit.target)
            .evaluate(params.value ?? (params.habit.type == HabitType.binary ? 1 : null));

    return _repository.upsertCheckIn(
      CheckInEntity(
        id: '${params.habit.id}_${params.date}',
        habitId: params.habit.id,
        localDate: params.date,
        value: params.skip ? null : params.value,
        status: status,
        note: params.note,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
