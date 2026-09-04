import 'dart:convert';

import 'package:customer/core/data/cache/preference/shared_preference.dart';
import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:dartz/dartz.dart';

import 'backup_bundle.dart';
import 'backup_codec.dart';
import 'backup_service.dart';

class RestoreValidationResult {
  final bool isValid;
  final String? error;
  final BackupBundle? bundle;
  final BackupSummary? summary;

  const RestoreValidationResult({required this.isValid, this.error, this.bundle, this.summary});

  const RestoreValidationResult.invalid(String error)
      : this(isValid: false, error: error);

  const RestoreValidationResult.valid(BackupBundle bundle, BackupSummary summary)
      : this(isValid: true, bundle: bundle, summary: summary);
}

/// Validates and applies a backup file (BRD §S24, docs/SRS.md FR-61).
/// Never partially restores: [validate] must pass, and [restore] applies
/// everything inside one repository transaction with rollback on failure.
class RestoreService {
  final HabitRepository _repository;
  final BackupService _backupService;

  const RestoreService(this._repository, this._backupService);

  /// Parses and checks [jsonString] without writing anything — safe to call
  /// just to show the user a validation summary before they confirm.
  RestoreValidationResult validate(String jsonString) {
    Map<String, dynamic> decoded;
    try {
      final parsed = jsonDecode(jsonString);
      if (parsed is! Map<String, dynamic>) {
        return const RestoreValidationResult.invalid('This is not a valid Habitly backup file.');
      }
      decoded = parsed;
    } catch (_) {
      return const RestoreValidationResult.invalid('This file could not be read as a backup.');
    }

    if (!BackupCodec.verifyChecksum(decoded)) {
      return const RestoreValidationResult.invalid(
        'This backup file is corrupted or was modified after it was created.',
      );
    }

    final schemaVersion = decoded['schemaVersion'];
    if (schemaVersion is! int || schemaVersion > BackupCodec.currentSchemaVersion) {
      return const RestoreValidationResult.invalid(
        'This backup was made with a newer version of Habitly. Update the app and try again.',
      );
    }

    try {
      final bundle = BackupCodec.decode(decoded);
      final summary = BackupCodec.summarize(decoded);
      return RestoreValidationResult.valid(bundle, summary);
    } catch (e) {
      return RestoreValidationResult.invalid('This backup file is malformed: $e');
    }
  }

  /// Replaces the entire local dataset with [bundle]. Takes a best-effort
  /// pre-restore safety snapshot first (BRD §14.1 "where storage permits") —
  /// a snapshot failure does not block the restore, since the user already
  /// explicitly chose to replace their data.
  Future<Either<Failure, void>> restore(BackupBundle bundle) async {
    try {
      await _backupService.exportToFile(
        fileNameOverride:
            'habitly_pre_restore_safety_${DateTime.now().toUtc().millisecondsSinceEpoch}.json',
      );
    } catch (_) {
      // Best-effort only — see method doc.
    }

    final result = await _repository.replaceAllData(
      habits: bundle.habits,
      schedules: bundle.schedules,
      reminders: bundle.reminders,
      checkIns: bundle.checkIns,
    );

    Failure? failure;
    result.fold((l) => failure = l, (_) {});
    if (failure != null) return Left(failure!);

    for (final entry in bundle.appSettings.entries) {
      await SharedPreference.setValue(entry.key, entry.value);
    }

    return const Right(null);
  }
}
