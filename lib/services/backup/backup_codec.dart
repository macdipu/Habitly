import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:customer/features/habits/data/model/check_in_dto.dart';
import 'package:customer/features/habits/data/model/habit_dto.dart';
import 'package:customer/features/habits/data/model/habit_schedule_dto.dart';
import 'package:customer/features/habits/data/model/reminder_dto.dart';

import 'backup_bundle.dart';

/// Pure JSON encode/decode + checksum for [BackupBundle] — no file or
/// database I/O, so it's unit-testable on its own (BRD §19.1 "backup/
/// restore round-trip equality").
class BackupCodec {
  const BackupCodec._();

  static const currentSchemaVersion = 1;

  /// Builds the full JSON map, including a checksum computed over
  /// everything else in the map (BRD §14.1 "integrity checksum").
  static Map<String, dynamic> encode(BackupBundle bundle) {
    final data = _dataFields(bundle);
    return {...data, 'checksum': computeChecksum(data)};
  }

  static Map<String, dynamic> _dataFields(BackupBundle bundle) => {
        'schemaVersion': bundle.schemaVersion,
        'appVersion': bundle.appVersion,
        'createdAt': bundle.createdAt.toIso8601String(),
        'habits': bundle.habits.map(HabitDto.toJson).toList(),
        'habitSchedules': bundle.schedules.map(HabitScheduleDto.toJson).toList(),
        'reminders': bundle.reminders.map(ReminderDto.toJson).toList(),
        'checkIns': bundle.checkIns.map(CheckInDto.toJson).toList(),
        'appSettings': bundle.appSettings,
      };

  /// SHA-256 over the canonical JSON encoding of [dataFields] (which must
  /// NOT include a `checksum` key). Deterministic because every caller —
  /// [encode] and the checksum-verification path in [decode]/
  /// [verifyChecksum] — builds the map with the same fixed key order.
  static String computeChecksum(Map<String, dynamic> dataFields) {
    final canonical = jsonEncode(dataFields);
    return sha256.convert(utf8.encode(canonical)).toString();
  }

  /// True if [json]'s stored `checksum` matches one recomputed from its
  /// other fields — i.e. the file wasn't corrupted/hand-edited (BRD §17
  /// "Corrupt backup" must be rejected wholesale, never partially restored).
  static bool verifyChecksum(Map<String, dynamic> json) {
    final checksum = json['checksum'];
    if (checksum is! String) return false;
    final withoutChecksum = Map<String, dynamic>.from(json)..remove('checksum');
    return computeChecksum(withoutChecksum) == checksum;
  }

  static BackupSummary summarize(Map<String, dynamic> json) {
    return BackupSummary(
      habitCount: (json['habits'] as List? ?? const []).length,
      checkInCount: (json['checkIns'] as List? ?? const []).length,
      reminderCount: (json['reminders'] as List? ?? const []).length,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static BackupBundle decode(Map<String, dynamic> json) {
    return BackupBundle(
      schemaVersion: json['schemaVersion'] as int,
      appVersion: json['appVersion'] as String? ?? 'unknown',
      createdAt: DateTime.parse(json['createdAt'] as String),
      habits: (json['habits'] as List)
          .map((e) => HabitDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      schedules: (json['habitSchedules'] as List)
          .map((e) => HabitScheduleDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      reminders: (json['reminders'] as List)
          .map((e) => ReminderDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      checkIns: (json['checkIns'] as List)
          .map((e) => CheckInDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      appSettings: Map<String, String>.from(json['appSettings'] as Map? ?? const {}),
    );
  }
}
