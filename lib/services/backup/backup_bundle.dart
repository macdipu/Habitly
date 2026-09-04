import 'package:customer/features/habits/domain/entity/check_in_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';

/// The full local dataset, versioned (BRD §14.1). Lives in `services/`
/// rather than `core/domain` because it necessarily spans multiple
/// features' domain entities — `core/domain` may never import
/// `features/*` (CLAUDE.md), but `services/` has no such restriction, the
/// same reasoning already used for `ReminderReconciler`
/// (docs/ARCHITECTURE.md §7).
class BackupBundle {
  final int schemaVersion;
  final String appVersion;
  final DateTime createdAt;
  final List<HabitEntity> habits;
  final List<HabitScheduleEntity> schedules;
  final List<ReminderEntity> reminders;
  final List<CheckInEntity> checkIns;

  /// Flat key/value snapshot of the SharedPreference-backed settings
  /// (theme, locale, start-of-week, time format, notification settings) —
  /// these live outside the Drift `app_settings` table today (see
  /// docs/DATA_MODEL.md), so backup captures them separately.
  final Map<String, String> appSettings;

  const BackupBundle({
    required this.schemaVersion,
    required this.appVersion,
    required this.createdAt,
    required this.habits,
    required this.schedules,
    required this.reminders,
    required this.checkIns,
    required this.appSettings,
  });
}

/// Non-destructive counts shown to the user before a restore actually
/// writes anything (BRD §S24 "Validation summary").
class BackupSummary {
  final int habitCount;
  final int checkInCount;
  final int reminderCount;
  final DateTime createdAt;

  const BackupSummary({
    required this.habitCount,
    required this.checkInCount,
    required this.reminderCount,
    required this.createdAt,
  });
}
