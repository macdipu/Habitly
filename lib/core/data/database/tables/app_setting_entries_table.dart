import 'package:drift/drift.dart';

/// Habitly-specific key/value settings (start-of-week, time format, quiet
/// hours, default snooze) that must live inside the same transactional
/// backup as habit data. Theme/locale keep using the existing
/// AppSettingsRepository/SharedPreference path — this table is not a
/// replacement for that.
class AppSettingEntries extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
