import 'package:drift/drift.dart';

/// Current habit definition. Soft-archived via [archivedAt]; history in
/// [CheckIns]/[HabitSchedules] must remain stable when a habit is edited later.
class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 60)();
  // 'binary' | 'count' | 'duration' | 'avoid'
  TextColumn get type => text()();
  TextColumn get icon => text()();
  IntColumn get color => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get unit => text().nullable()();
  RealColumn get target => real().nullable()();
  // 'atLeast' | 'atMost', nullable for binary habits
  TextColumn get goalDirection => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get archivedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
