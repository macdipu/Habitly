import 'package:drift/drift.dart' show Value;

import 'package:customer/core/data/database/app_database.dart' as db;
import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';

import '../../domain/entity/habit_schedule_entity.dart';

class HabitScheduleDto {
  const HabitScheduleDto._();

  static Set<int> _parseWeekdays(String? csv) {
    if (csv == null || csv.isEmpty) return const {};
    return csv.split(',').map(int.parse).toSet();
  }

  static String? _formatWeekdays(Set<int> weekdays) {
    if (weekdays.isEmpty) return null;
    return weekdays.join(',');
  }

  static HabitScheduleEntity toEntity(db.HabitSchedule row) {
    return HabitScheduleEntity(
      id: row.id,
      habitId: row.habitId,
      rule: HabitScheduleRule(
        mode: ScheduleMode.values.byName(row.mode),
        weekdays: _parseWeekdays(row.weekdays),
        weeklyTarget: row.weeklyTarget,
        intervalDays: row.intervalDays,
        anchorDate: row.anchorDate == null ? null : LocalDate.parse(row.anchorDate!),
        startDate: LocalDate.parse(row.startDate),
        endDate: row.endDate == null ? null : LocalDate.parse(row.endDate!),
        effectiveFrom: LocalDate.parse(row.effectiveFrom),
      ),
    );
  }

  static db.HabitSchedulesCompanion toInsertCompanion(HabitScheduleEntity entity) {
    final rule = entity.rule;
    return db.HabitSchedulesCompanion.insert(
      id: entity.id,
      habitId: entity.habitId,
      mode: rule.mode.name,
      weekdays: Value(_formatWeekdays(rule.weekdays)),
      weeklyTarget: Value(rule.weeklyTarget),
      intervalDays: Value(rule.intervalDays),
      anchorDate: Value(rule.anchorDate?.toString()),
      startDate: rule.startDate.toString(),
      endDate: Value(rule.endDate?.toString()),
      effectiveFrom: rule.effectiveFrom.toString(),
    );
  }

  static Map<String, dynamic> toJson(HabitScheduleEntity entity) {
    final rule = entity.rule;
    return {
      'id': entity.id,
      'habitId': entity.habitId,
      'mode': rule.mode.name,
      'weekdays': rule.weekdays.toList(),
      'weeklyTarget': rule.weeklyTarget,
      'intervalDays': rule.intervalDays,
      'anchorDate': rule.anchorDate?.toString(),
      'startDate': rule.startDate.toString(),
      'endDate': rule.endDate?.toString(),
      'effectiveFrom': rule.effectiveFrom.toString(),
    };
  }

  static HabitScheduleEntity fromJson(Map<String, dynamic> json) => HabitScheduleEntity(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        rule: HabitScheduleRule(
          mode: ScheduleMode.values.byName(json['mode'] as String),
          weekdays: (json['weekdays'] as List).map((e) => e as int).toSet(),
          weeklyTarget: json['weeklyTarget'] as int?,
          intervalDays: json['intervalDays'] as int?,
          anchorDate: json['anchorDate'] == null ? null : LocalDate.parse(json['anchorDate'] as String),
          startDate: LocalDate.parse(json['startDate'] as String),
          endDate: json['endDate'] == null ? null : LocalDate.parse(json['endDate'] as String),
          effectiveFrom: LocalDate.parse(json['effectiveFrom'] as String),
        ),
      );
}
