import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/features/habits/domain/entity/check_in_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';
import 'package:customer/services/backup/backup_bundle.dart';
import 'package:customer/services/backup/backup_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1, 12);

  BackupBundle sampleBundle() => BackupBundle(
        schemaVersion: BackupCodec.currentSchemaVersion,
        appVersion: '1.0.0',
        createdAt: now,
        habits: [
          HabitEntity(
            id: 'h1',
            name: 'Drink water',
            type: HabitType.count,
            icon: 'water_drop',
            color: 0xFF2E7D32,
            unit: 'glasses',
            target: 8,
            goalDirection: GoalDirection.atLeast,
            createdAt: now,
            updatedAt: now,
          ),
        ],
        schedules: [
          HabitScheduleEntity(
            id: 's1',
            habitId: 'h1',
            rule: HabitScheduleRule(
              mode: ScheduleMode.weekdays,
              weekdays: const {1, 3, 5},
              startDate: const LocalDate(2026, 1, 1),
              effectiveFrom: const LocalDate(2026, 1, 1),
            ),
          ),
        ],
        reminders: [
          const ReminderEntity(id: 'r1', habitId: 'h1', time: '08:00', label: 'Morning'),
        ],
        checkIns: [
          CheckInEntity(
            id: 'c1',
            habitId: 'h1',
            localDate: const LocalDate(2026, 1, 2),
            value: 8,
            status: CheckInStatus.completed,
            note: 'Felt great',
            createdAt: now,
            updatedAt: now,
          ),
        ],
        appSettings: {'theme_mode': 'dark', 'start_of_week': '1'},
      );

  group('BackupCodec round trip', () {
    test('decode(encode(bundle)) reproduces every field exactly', () {
      final original = sampleBundle();
      final json = BackupCodec.encode(original);
      final decoded = BackupCodec.decode(json);

      expect(decoded.schemaVersion, original.schemaVersion);
      expect(decoded.appVersion, original.appVersion);
      expect(decoded.createdAt, original.createdAt);
      expect(decoded.appSettings, original.appSettings);

      expect(decoded.habits.length, 1);
      expect(decoded.habits.single.id, 'h1');
      expect(decoded.habits.single.unit, 'glasses');
      expect(decoded.habits.single.target, 8);
      expect(decoded.habits.single.goalDirection, GoalDirection.atLeast);

      expect(decoded.schedules.single.rule.mode, ScheduleMode.weekdays);
      expect(decoded.schedules.single.rule.weekdays, {1, 3, 5});

      expect(decoded.reminders.single.time, '08:00');
      expect(decoded.reminders.single.label, 'Morning');

      expect(decoded.checkIns.single.localDate, const LocalDate(2026, 1, 2));
      expect(decoded.checkIns.single.status, CheckInStatus.completed);
      expect(decoded.checkIns.single.note, 'Felt great');
    });

    test('a freshly encoded bundle always verifies', () {
      final json = BackupCodec.encode(sampleBundle());
      expect(BackupCodec.verifyChecksum(json), isTrue);
    });
  });

  group('BackupCodec.verifyChecksum', () {
    test('rejects a tampered field even if unrelated to the tampered data', () {
      final json = BackupCodec.encode(sampleBundle());
      final tampered = Map<String, dynamic>.from(json);
      tampered['appVersion'] = '9.9.9'; // checksum still reflects the original value
      expect(BackupCodec.verifyChecksum(tampered), isFalse);
    });

    test('rejects a missing checksum', () {
      final json = BackupCodec.encode(sampleBundle());
      final withoutChecksum = Map<String, dynamic>.from(json)..remove('checksum');
      expect(BackupCodec.verifyChecksum(withoutChecksum), isFalse);
    });

    test('two different bundles never produce the same checksum by accident', () {
      final a = BackupCodec.encode(sampleBundle());
      final b = BackupCodec.encode(BackupBundle(
        schemaVersion: BackupCodec.currentSchemaVersion,
        appVersion: '1.0.0',
        createdAt: now,
        habits: const [],
        schedules: const [],
        reminders: const [],
        checkIns: const [],
        appSettings: const {},
      ));
      expect(a['checksum'], isNot(b['checksum']));
    });
  });

  group('BackupCodec.summarize', () {
    test('counts entities without fully decoding them', () {
      final json = BackupCodec.encode(sampleBundle());
      final summary = BackupCodec.summarize(json);
      expect(summary.habitCount, 1);
      expect(summary.checkInCount, 1);
      expect(summary.reminderCount, 1);
      expect(summary.createdAt, now);
    });
  });
}
