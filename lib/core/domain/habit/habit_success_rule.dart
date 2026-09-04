import 'habit_enums.dart';

/// Maps a logged value to a [CheckInStatus] per habit type (BRD §8.1).
/// Pure, deterministic — used by the save-check-in usecase before a row is
/// persisted, and by tests that assert success-rule behavior in isolation.
class HabitSuccessRule {
  final HabitType type;

  /// Target amount for count/duration; max threshold for avoid habits.
  /// Null/zero target on count/duration means "any logged value succeeds".
  final double? target;

  const HabitSuccessRule({required this.type, this.target});

  CheckInStatus evaluate(double? value) {
    switch (type) {
      case HabitType.binary:
        return value != null && value > 0 ? CheckInStatus.completed : CheckInStatus.missed;

      case HabitType.count:
      case HabitType.duration:
        if (value == null || value <= 0) return CheckInStatus.missed;
        final t = target ?? 0;
        if (t <= 0 || value >= t) return CheckInStatus.completed;
        return CheckInStatus.partial;

      case HabitType.avoid:
        final logged = value ?? 0;
        final threshold = target ?? 0;
        return logged <= threshold ? CheckInStatus.completed : CheckInStatus.missed;
    }
  }
}
