import 'package:customer/core/domain/habit/habit_schedule_rule.dart';

/// Persistence-identity wrapper around the pure [HabitScheduleRule] value
/// object from `core/domain`. Append-only: an edit inserts a new row with a
/// later `effectiveFrom` rather than mutating this one (docs/SRS.md FR-13).
class HabitScheduleEntity {
  final String id;
  final String habitId;
  final HabitScheduleRule rule;

  const HabitScheduleEntity({
    required this.id,
    required this.habitId,
    required this.rule,
  });
}
