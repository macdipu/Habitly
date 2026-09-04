import 'package:drift/drift.dart' show Value;

import 'package:customer/core/data/database/app_database.dart' as db;
import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';

import '../../domain/entity/check_in_entity.dart';

class CheckInDto {
  const CheckInDto._();

  static CheckInEntity toEntity(db.CheckIn row) {
    return CheckInEntity(
      id: row.id,
      habitId: row.habitId,
      localDate: LocalDate.parse(row.localDate),
      value: row.value,
      status: CheckInStatus.values.byName(row.status),
      note: row.note,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static db.CheckInsCompanion toInsertCompanion(CheckInEntity entity) {
    return db.CheckInsCompanion.insert(
      id: entity.id,
      habitId: entity.habitId,
      localDate: entity.localDate.toString(),
      value: Value(entity.value),
      status: entity.status.name,
      note: Value(entity.note),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static Map<String, dynamic> toJson(CheckInEntity entity) => {
        'id': entity.id,
        'habitId': entity.habitId,
        'localDate': entity.localDate.toString(),
        'value': entity.value,
        'status': entity.status.name,
        'note': entity.note,
        'createdAt': entity.createdAt.toIso8601String(),
        'updatedAt': entity.updatedAt.toIso8601String(),
      };

  static CheckInEntity fromJson(Map<String, dynamic> json) => CheckInEntity(
        id: json['id'] as String,
        habitId: json['habitId'] as String,
        localDate: LocalDate.parse(json['localDate'] as String),
        value: (json['value'] as num?)?.toDouble(),
        status: CheckInStatus.values.byName(json['status'] as String),
        note: json['note'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}
