import 'dart:convert';

import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/services/backup/backup_bundle.dart';
import 'package:customer/services/backup/backup_codec.dart';
import 'package:customer/services/backup/backup_service.dart';
import 'package:customer/services/backup/restore_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../features/habits/fake_habit_repository.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);
  late RestoreService restoreService;

  setUp(() {
    final repo = FakeHabitRepository();
    restoreService = RestoreService(repo, BackupService(repo));
  });

  BackupBundle sampleBundle({int schemaVersion = BackupCodec.currentSchemaVersion}) => BackupBundle(
        schemaVersion: schemaVersion,
        appVersion: '1.0.0',
        createdAt: now,
        habits: [
          HabitEntity(
            id: 'h1',
            name: 'Read',
            type: HabitType.binary,
            icon: 'book',
            color: 0xFF000000,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        schedules: const [],
        reminders: const [],
        checkIns: const [],
        appSettings: const {},
      );

  group('RestoreService.validate', () {
    test('accepts a well-formed, current-schema backup', () {
      final json = BackupCodec.encode(sampleBundle());
      final result = restoreService.validate(jsonEncode(json));
      expect(result.isValid, isTrue);
      expect(result.summary!.habitCount, 1);
      expect(result.bundle!.habits.single.name, 'Read');
    });

    test('rejects a backup from a newer, unsupported schema version', () {
      final json = BackupCodec.encode(sampleBundle(schemaVersion: BackupCodec.currentSchemaVersion + 1));
      final result = restoreService.validate(jsonEncode(json));
      expect(result.isValid, isFalse);
      expect(result.error, contains('newer version'));
    });

    test('rejects a tampered (checksum-mismatched) file', () {
      final json = BackupCodec.encode(sampleBundle());
      json['appVersion'] = 'tampered';
      final result = restoreService.validate(jsonEncode(json));
      expect(result.isValid, isFalse);
      expect(result.error, contains('corrupted'));
    });

    test('rejects a file that is not JSON at all', () {
      final result = restoreService.validate('not json {{{');
      expect(result.isValid, isFalse);
    });

    test('rejects JSON that is not a Habitly backup shape (e.g. a bare list)', () {
      final result = restoreService.validate(jsonEncode([1, 2, 3]));
      expect(result.isValid, isFalse);
    });
  });
}
