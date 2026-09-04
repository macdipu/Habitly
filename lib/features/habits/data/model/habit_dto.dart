import 'package:drift/drift.dart' show Value;

import 'package:customer/core/data/database/app_database.dart' as db;
import 'package:customer/core/domain/habit/habit_enums.dart';

import '../../domain/entity/habit_entity.dart';

/// Maps between the Drift `Habit` row/companion and the pure [HabitEntity].
/// Owns all serialization for this table per CLAUDE.md's DTO/entity split.
class HabitDto {
  const HabitDto._();

  static HabitEntity toEntity(db.Habit row) {
    return HabitEntity(
      id: row.id,
      name: row.name,
      type: HabitType.values.byName(row.type),
      icon: row.icon,
      color: row.color,
      description: row.description,
      unit: row.unit,
      target: row.target,
      goalDirection:
          row.goalDirection == null ? null : GoalDirection.values.byName(row.goalDirection!),
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      archivedAt: row.archivedAt,
    );
  }

  static db.HabitsCompanion toInsertCompanion(HabitEntity entity) {
    return db.HabitsCompanion.insert(
      id: entity.id,
      name: entity.name,
      type: entity.type.name,
      icon: entity.icon,
      color: entity.color,
      description: Value(entity.description),
      unit: Value(entity.unit),
      target: Value(entity.target),
      goalDirection: Value(entity.goalDirection?.name),
      sortOrder: Value(entity.sortOrder),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      archivedAt: Value(entity.archivedAt),
    );
  }

  static db.HabitsCompanion toUpdateCompanion(HabitEntity entity) {
    return db.HabitsCompanion(
      name: Value(entity.name),
      icon: Value(entity.icon),
      color: Value(entity.color),
      description: Value(entity.description),
      unit: Value(entity.unit),
      target: Value(entity.target),
      goalDirection: Value(entity.goalDirection?.name),
      sortOrder: Value(entity.sortOrder),
      updatedAt: Value(entity.updatedAt),
      archivedAt: Value(entity.archivedAt),
    );
  }
}
