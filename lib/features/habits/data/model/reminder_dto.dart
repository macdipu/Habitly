import 'package:drift/drift.dart' show Value;

import 'package:customer/core/data/database/app_database.dart' as db;

import '../../domain/entity/reminder_entity.dart';

class ReminderDto {
  const ReminderDto._();

  static Set<int>? _parseWeekdays(String? csv) {
    if (csv == null || csv.isEmpty) return null;
    return csv.split(',').map(int.parse).toSet();
  }

  static String? _formatWeekdays(Set<int>? weekdays) {
    if (weekdays == null || weekdays.isEmpty) return null;
    return weekdays.join(',');
  }

  static ReminderEntity toEntity(db.Reminder row) {
    return ReminderEntity(
      id: row.id,
      habitId: row.habitId,
      time: row.time,
      label: row.label,
      enabled: row.enabled,
      weekdays: _parseWeekdays(row.weekdays),
    );
  }

  static db.RemindersCompanion toInsertCompanion(ReminderEntity entity) {
    return db.RemindersCompanion.insert(
      id: entity.id,
      habitId: entity.habitId,
      time: entity.time,
      label: Value(entity.label),
      enabled: Value(entity.enabled),
      weekdays: Value(_formatWeekdays(entity.weekdays)),
    );
  }

  static Map<String, dynamic> toJson(ReminderEntity entity) => {
        'id': entity.id,
        'habitId': entity.habitId,
        'time': entity.time,
        'label': entity.label,
        'enabled': entity.enabled,
        'weekdays': entity.weekdays?.toList(),
      };

  static ReminderEntity fromJson(Map<String, dynamic> json) => ReminderEntity(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        time: json['time'] as String,
        label: json['label'] as String?,
        enabled: json['enabled'] as bool? ?? true,
        weekdays: json['weekdays'] == null
            ? null
            : (json['weekdays'] as List).map((e) => e as int).toSet(),
      );
}
