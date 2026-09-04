import 'package:drift/drift.dart';

import 'habits_table.dart';

/// User record resolving one scheduled occurrence. One row per
/// (habitId, localDate); repeated taps update the same row rather than
/// inserting a new one (see docs/SRS.md FR-33).
class CheckIns extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text().references(Habits, #id)();
  /// 'YYYY-MM-DD' — the occurrence this resolves, independent of UTC rollover.
  TextColumn get localDate => text()();
  /// Logged amount for count/duration habits; null for binary.
  RealColumn get value => real().nullable()();
  // 'completed' | 'partial' | 'missed' | 'skipped'
  TextColumn get status => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {habitId, localDate},
      ];
}
