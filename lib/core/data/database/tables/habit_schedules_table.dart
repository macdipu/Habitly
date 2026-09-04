import 'package:drift/drift.dart';

import 'habits_table.dart';

/// Append-only recurrence rule rows. Editing a habit's schedule inserts a new
/// row with a later [effectiveFrom] instead of mutating the previous one, so
/// past occurrences keep resolving against the rule that was active when they
/// happened (see docs/SRS.md FR-13).
class HabitSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text().references(Habits, #id)();
  // 'daily' | 'weekdays' | 'timesPerWeek' | 'interval'
  TextColumn get mode => text()();
  /// CSV of ISO weekday ints (1=Mon..7=Sun), for 'weekdays' mode.
  TextColumn get weekdays => text().nullable()();
  IntColumn get weeklyTarget => integer().nullable()();
  IntColumn get intervalDays => integer().nullable()();
  /// 'YYYY-MM-DD', interval anchor date.
  TextColumn get anchorDate => text().nullable()();
  /// 'YYYY-MM-DD'.
  TextColumn get startDate => text()();
  /// 'YYYY-MM-DD', null = no end.
  TextColumn get endDate => text().nullable()();
  /// 'YYYY-MM-DD' — occurrences on/after this date resolve against this row.
  TextColumn get effectiveFrom => text()();

  @override
  Set<Column> get primaryKey => {id};
}
