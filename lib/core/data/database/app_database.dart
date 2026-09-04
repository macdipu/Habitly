import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import 'tables/app_setting_entries_table.dart';
import 'tables/check_ins_table.dart';
import 'tables/habit_schedules_table.dart';
import 'tables/habits_table.dart';
import 'tables/reminders_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Habits, HabitSchedules, Reminders, CheckIns, AppSettingEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For unit tests: pass an in-memory NativeDatabase connection.
  AppDatabase.withConnection(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Add a step here for every schemaVersion bump — see
          // docs/DATA_MODEL.md "Migration table". Never drop/recreate tables
          // as a shortcut: that silently destroys user history.
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'habitly.sqlite'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;
    return NativeDatabase.createInBackground(file);
  });
}
