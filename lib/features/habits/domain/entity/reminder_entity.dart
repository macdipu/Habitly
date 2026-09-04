/// Local reminder definition. `time` is 'HH:mm', the local intended time
/// (docs/DATA_MODEL.md) — the platform notification id is derived from
/// (habitId, id), never stored here (docs/SRS.md FR-50).
class ReminderEntity {
  final String id;
  final String habitId;
  final String time;
  final String? label;
  final bool enabled;

  /// ISO weekday overrides; null = inherits the habit's schedule days.
  final Set<int>? weekdays;

  const ReminderEntity({
    required this.id,
    required this.habitId,
    required this.time,
    this.label,
    this.enabled = true,
    this.weekdays,
  });
}
