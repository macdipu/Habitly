import 'package:customer/core/domain/habit/habit_enums.dart';

/// Current habit definition. Pure Dart per CLAUDE.md — no fromJson/toJson
/// here; that belongs to `data/model/habit_dto.dart`.
class HabitEntity {
  final String id;
  final String name;
  final HabitType type;
  final String icon;
  final int color;
  final String? description;
  final String? unit;
  final double? target;
  final GoalDirection? goalDirection;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;

  const HabitEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.description,
    this.unit,
    this.target,
    this.goalDirection,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
    this.archivedAt,
  });

  bool get isArchived => archivedAt != null;

  HabitEntity copyWith({
    String? name,
    String? icon,
    int? color,
    String? description,
    String? unit,
    double? target,
    GoalDirection? goalDirection,
    int? sortOrder,
    DateTime? updatedAt,
    DateTime? archivedAt,
    bool clearArchivedAt = false,
  }) {
    return HabitEntity(
      id: id,
      name: name ?? this.name,
      type: type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      target: target ?? this.target,
      goalDirection: goalDirection ?? this.goalDirection,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: clearArchivedAt ? null : (archivedAt ?? this.archivedAt),
    );
  }
}
