import 'dart:convert';
import 'dart:io';

import 'package:customer/core/data/cache/preference/shared_preference.dart';
import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/features/habits/domain/entity/check_in_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_bundle.dart';
import 'backup_codec.dart';

/// The subset of keys captured in a backup's `appSettings` (BRD §14.1) —
/// deliberately explicit rather than dumping the entire secure-storage
/// keyspace, since some future key might not be safe/meaningful to carry
/// across devices.
const kBackedUpSettingKeys = [
  'app_settings:theme_mode',
  'app_settings:locale',
  'app_settings:start_of_week',
  'app_settings:time_format',
  'notifications:master_enabled',
  'notifications:quiet_hours_enabled',
  'notifications:quiet_hours_start',
  'notifications:quiet_hours_end',
  'notifications:shift_to_quiet_hours_end',
];

const _lastBackupAtKey = 'backup:last_backup_at';

/// Builds and exports a full local-data backup (BRD §14.1). Creating a
/// backup never mutates current data — it only reads.
class BackupService {
  final HabitRepository _repository;

  const BackupService(this._repository);

  Future<Either<Failure, BackupBundle>> buildBundle() async {
    Failure? failure;

    final activeResult = await _repository.getActiveHabits();
    final archivedResult = await _repository.getArchivedHabits();
    final active = activeResult.fold((l) {
      failure = l;
      return <HabitEntity>[];
    }, (r) => r);
    final archived = archivedResult.fold((l) {
      failure = l;
      return <HabitEntity>[];
    }, (r) => r);
    if (failure != null) return Left(failure!);

    final habits = [...active, ...archived];
    final schedules = <HabitScheduleEntity>[];
    final reminders = <ReminderEntity>[];
    final checkIns = <CheckInEntity>[];

    for (final habit in habits) {
      final schedulesResult = await _repository.getSchedules(habit.id);
      schedulesResult.fold((l) => failure = l, schedules.addAll);

      final remindersResult = await _repository.getReminders(habit.id);
      remindersResult.fold((l) => failure = l, reminders.addAll);

      final checkInsResult = await _repository.getCheckIns(
        habitId: habit.id,
        from: const LocalDate(1970, 1, 1),
        to: LocalDate.fromDateTime(DateTime.now()).addDays(3650),
      );
      checkInsResult.fold((l) => failure = l, checkIns.addAll);
    }
    if (failure != null) return Left(failure!);

    final appSettings = <String, String>{};
    for (final key in kBackedUpSettingKeys) {
      final value = await SharedPreference.getValue(key);
      if (value != null) appSettings[key] = value;
    }

    String appVersion;
    try {
      appVersion = (await PackageInfo.fromPlatform()).version;
    } catch (_) {
      appVersion = 'unknown';
    }

    return Right(BackupBundle(
      schemaVersion: BackupCodec.currentSchemaVersion,
      appVersion: appVersion,
      createdAt: DateTime.now().toUtc(),
      habits: habits,
      schedules: schedules,
      reminders: reminders,
      checkIns: checkIns,
      appSettings: appSettings,
    ));
  }

  /// Writes a backup JSON file and returns its path. Used both for the
  /// user-facing "Create backup" action and as the automatic pre-restore
  /// safety snapshot (BRD §14.1).
  Future<Either<Failure, File>> exportToFile({String? fileNameOverride}) async {
    final bundleResult = await buildBundle();
    Failure? failure;
    final bundle = bundleResult.fold((l) {
      failure = l;
      return null;
    }, (r) => r);
    if (failure != null || bundle == null) return Left(failure!);

    try {
      final json = BackupCodec.encode(bundle);
      final dir = await getApplicationDocumentsDirectory();
      final fileName = fileNameOverride ??
          'habitly_backup_${DateTime.now().toUtc().millisecondsSinceEpoch}.json';
      final file = File(p.join(dir.path, fileName));
      await file.writeAsString(jsonEncode(json));
      await SharedPreference.setValue(_lastBackupAtKey, DateTime.now().toUtc().toIso8601String());
      return Right(file);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure('Failed to write backup file: $e'));
    }
  }

  Future<void> share(File file) async {
    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path)],
      subject: 'Habitly backup',
    ));
  }

  Future<DateTime?> getLastBackupAt() async {
    final value = await SharedPreference.getValue(_lastBackupAtKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
