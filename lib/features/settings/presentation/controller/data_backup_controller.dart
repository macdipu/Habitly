import 'dart:io';

import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/services/backup/backup_bundle.dart';
import 'package:customer/services/backup/backup_service.dart';
import 'package:customer/services/backup/csv_export_service.dart';
import 'package:customer/services/backup/restore_service.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

/// S23/S24/S26 — backup/export/restore/delete-all. Restore and delete-all
/// both replace the entire dataset out from under whatever's currently
/// loaded in Today/Calendar/Insights, so the screen navigates back through
/// Splash afterward to force those controllers to rebuild fresh rather than
/// show stale cached lists (see `DataBackupScreen`/Settings wiring).
class DataBackupController extends BaseController {
  final BackupService _backupService;
  final RestoreService _restoreService;
  final CsvExportService _csvExportService;
  final HabitRepository _repository;
  final HabitNotificationService _notificationService;

  DataBackupController(
    this._backupService,
    this._restoreService,
    this._csvExportService,
    this._repository,
    this._notificationService,
  );

  final Rx<DateTime?> lastBackupAt = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadLastBackupAt();
  }

  Future<void> _loadLastBackupAt() async {
    lastBackupAt.value = await _backupService.getLastBackupAt();
  }

  Future<void> createAndShareBackup() async {
    await doAction<File>(
      action: () => _backupService.exportToFile(),
      onSuccess: (file) async {
        await _backupService.share(file);
        await _loadLastBackupAt();
      },
    );
  }

  Future<void> exportAndShareCsv() async {
    await doAction<File>(
      action: () => _csvExportService.exportCheckIns(),
      onSuccess: (file) async {
        await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: 'Habitly check-ins'));
      },
    );
  }

  /// Reads and validates a picked backup file without writing anything.
  Future<RestoreValidationResult> validateFile(String path) async {
    final content = await File(path).readAsString();
    return _restoreService.validate(content);
  }

  /// Only call after the user has seen [RestoreValidationResult]'s summary
  /// and explicitly confirmed (BRD §S24 "Confirm replace/merge strategy").
  Future<bool> performRestore(BackupBundle bundle) async {
    var success = false;
    await doAction<void>(
      action: () => _restoreService.restore(bundle),
      onSuccess: (_) => success = true,
    );
    return success;
  }

  /// Only call after typed confirmation (BRD §S26 "require typed
  /// confirmation such as DELETE").
  Future<bool> deleteAllData() async {
    var success = false;
    await doAction<void>(
      action: () => _repository.deleteAllData(),
      onSuccess: (_) => success = true,
    );
    if (success) {
      try {
        await _notificationService.cancelAll();
      } catch (_) {
        // Data is already gone; a stray notification can't reference it.
      }
    }
    return success;
  }
}
