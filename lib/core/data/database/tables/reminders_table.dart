import 'package:drift/drift.dart';

import 'habits_table.dart';

/// Local reminder definitions. Notification id at the platform layer is a
/// stable hash of (habitId, id) so it can be individually cancelled and
/// rescheduled (see docs/SRS.md FR-50).
class Reminders extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text().references(Habits, #id)();
  /// 'HH:mm', local intended time.
  TextColumn get time => text()();
  TextColumn get label => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  /// CSV override of ISO weekday ints; null = inherits the habit's schedule days.
  TextColumn get weekdays => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
