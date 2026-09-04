// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 60),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetMeta = const VerificationMeta('target');
  @override
  late final GeneratedColumn<double> target = GeneratedColumn<double>(
      'target', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _goalDirectionMeta =
      const VerificationMeta('goalDirection');
  @override
  late final GeneratedColumn<String> goalDirection = GeneratedColumn<String>(
      'goal_direction', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _archivedAtMeta =
      const VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        icon,
        color,
        description,
        unit,
        target,
        goalDirection,
        sortOrder,
        createdAt,
        updatedAt,
        archivedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(Insertable<Habit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('target')) {
      context.handle(_targetMeta,
          target.isAcceptableOrUnknown(data['target']!, _targetMeta));
    }
    if (data.containsKey('goal_direction')) {
      context.handle(
          _goalDirectionMeta,
          goalDirection.isAcceptableOrUnknown(
              data['goal_direction']!, _goalDirectionMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('archived_at')) {
      context.handle(
          _archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(
              data['archived_at']!, _archivedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      target: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target']),
      goalDirection: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}goal_direction']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      archivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }
}

class Habit extends DataClass implements Insertable<Habit> {
  final String id;
  final String name;
  final String type;
  final String icon;
  final int color;
  final String? description;
  final String? unit;
  final double? target;
  final String? goalDirection;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  const Habit(
      {required this.id,
      required this.name,
      required this.type,
      required this.icon,
      required this.color,
      this.description,
      this.unit,
      this.target,
      this.goalDirection,
      required this.sortOrder,
      required this.createdAt,
      required this.updatedAt,
      this.archivedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || target != null) {
      map['target'] = Variable<double>(target);
    }
    if (!nullToAbsent || goalDirection != null) {
      map['goal_direction'] = Variable<String>(goalDirection);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      icon: Value(icon),
      color: Value(color),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      target:
          target == null && nullToAbsent ? const Value.absent() : Value(target),
      goalDirection: goalDirection == null && nullToAbsent
          ? const Value.absent()
          : Value(goalDirection),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      description: serializer.fromJson<String?>(json['description']),
      unit: serializer.fromJson<String?>(json['unit']),
      target: serializer.fromJson<double?>(json['target']),
      goalDirection: serializer.fromJson<String?>(json['goalDirection']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'description': serializer.toJson<String?>(description),
      'unit': serializer.toJson<String?>(unit),
      'target': serializer.toJson<double?>(target),
      'goalDirection': serializer.toJson<String?>(goalDirection),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
    };
  }

  Habit copyWith(
          {String? id,
          String? name,
          String? type,
          String? icon,
          int? color,
          Value<String?> description = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          Value<double?> target = const Value.absent(),
          Value<String?> goalDirection = const Value.absent(),
          int? sortOrder,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> archivedAt = const Value.absent()}) =>
      Habit(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        description: description.present ? description.value : this.description,
        unit: unit.present ? unit.value : this.unit,
        target: target.present ? target.value : this.target,
        goalDirection:
            goalDirection.present ? goalDirection.value : this.goalDirection,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
      );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      description:
          data.description.present ? data.description.value : this.description,
      unit: data.unit.present ? data.unit.value : this.unit,
      target: data.target.present ? data.target.value : this.target,
      goalDirection: data.goalDirection.present
          ? data.goalDirection.value
          : this.goalDirection,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      archivedAt:
          data.archivedAt.present ? data.archivedAt.value : this.archivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('target: $target, ')
          ..write('goalDirection: $goalDirection, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, icon, color, description,
      unit, target, goalDirection, sortOrder, createdAt, updatedAt, archivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.description == this.description &&
          other.unit == this.unit &&
          other.target == this.target &&
          other.goalDirection == this.goalDirection &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.archivedAt == this.archivedAt);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> icon;
  final Value<int> color;
  final Value<String?> description;
  final Value<String?> unit;
  final Value<double?> target;
  final Value<String?> goalDirection;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> archivedAt;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.description = const Value.absent(),
    this.unit = const Value.absent(),
    this.target = const Value.absent(),
    this.goalDirection = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String name,
    required String type,
    required String icon,
    required int color,
    this.description = const Value.absent(),
    this.unit = const Value.absent(),
    this.target = const Value.absent(),
    this.goalDirection = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.archivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        type = Value(type),
        icon = Value(icon),
        color = Value(color),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Habit> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<String>? description,
    Expression<String>? unit,
    Expression<double>? target,
    Expression<String>? goalDirection,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (description != null) 'description': description,
      if (unit != null) 'unit': unit,
      if (target != null) 'target': target,
      if (goalDirection != null) 'goal_direction': goalDirection,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? icon,
      Value<int>? color,
      Value<String?>? description,
      Value<String?>? unit,
      Value<double?>? target,
      Value<String?>? goalDirection,
      Value<int>? sortOrder,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? archivedAt,
      Value<int>? rowid}) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      description: description ?? this.description,
      unit: unit ?? this.unit,
      target: target ?? this.target,
      goalDirection: goalDirection ?? this.goalDirection,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (target.present) {
      map['target'] = Variable<double>(target.value);
    }
    if (goalDirection.present) {
      map['goal_direction'] = Variable<String>(goalDirection.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('description: $description, ')
          ..write('unit: $unit, ')
          ..write('target: $target, ')
          ..write('goalDirection: $goalDirection, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitSchedulesTable extends HabitSchedules
    with TableInfo<$HabitSchedulesTable, HabitSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _habitIdMeta =
      const VerificationMeta('habitId');
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES habits (id)'));
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weekdaysMeta =
      const VerificationMeta('weekdays');
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
      'weekdays', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weeklyTargetMeta =
      const VerificationMeta('weeklyTarget');
  @override
  late final GeneratedColumn<int> weeklyTarget = GeneratedColumn<int>(
      'weekly_target', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _anchorDateMeta =
      const VerificationMeta('anchorDate');
  @override
  late final GeneratedColumn<String> anchorDate = GeneratedColumn<String>(
      'anchor_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
      'end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _effectiveFromMeta =
      const VerificationMeta('effectiveFrom');
  @override
  late final GeneratedColumn<String> effectiveFrom = GeneratedColumn<String>(
      'effective_from', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        habitId,
        mode,
        weekdays,
        weeklyTarget,
        intervalDays,
        anchorDate,
        startDate,
        endDate,
        effectiveFrom
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_schedules';
  @override
  VerificationContext validateIntegrity(Insertable<HabitSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('weekdays')) {
      context.handle(_weekdaysMeta,
          weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta));
    }
    if (data.containsKey('weekly_target')) {
      context.handle(
          _weeklyTargetMeta,
          weeklyTarget.isAcceptableOrUnknown(
              data['weekly_target']!, _weeklyTargetMeta));
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    }
    if (data.containsKey('anchor_date')) {
      context.handle(
          _anchorDateMeta,
          anchorDate.isAcceptableOrUnknown(
              data['anchor_date']!, _anchorDateMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('effective_from')) {
      context.handle(
          _effectiveFromMeta,
          effectiveFrom.isAcceptableOrUnknown(
              data['effective_from']!, _effectiveFromMeta));
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitSchedule(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      habitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_id'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      weekdays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekdays']),
      weeklyTarget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weekly_target']),
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days']),
      anchorDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}anchor_date']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_date']),
      effectiveFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}effective_from'])!,
    );
  }

  @override
  $HabitSchedulesTable createAlias(String alias) {
    return $HabitSchedulesTable(attachedDatabase, alias);
  }
}

class HabitSchedule extends DataClass implements Insertable<HabitSchedule> {
  final String id;
  final String habitId;
  final String mode;

  /// CSV of ISO weekday ints (1=Mon..7=Sun), for 'weekdays' mode.
  final String? weekdays;
  final int? weeklyTarget;
  final int? intervalDays;

  /// 'YYYY-MM-DD', interval anchor date.
  final String? anchorDate;

  /// 'YYYY-MM-DD'.
  final String startDate;

  /// 'YYYY-MM-DD', null = no end.
  final String? endDate;

  /// 'YYYY-MM-DD' — occurrences on/after this date resolve against this row.
  final String effectiveFrom;
  const HabitSchedule(
      {required this.id,
      required this.habitId,
      required this.mode,
      this.weekdays,
      this.weeklyTarget,
      this.intervalDays,
      this.anchorDate,
      required this.startDate,
      this.endDate,
      required this.effectiveFrom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<String>(weekdays);
    }
    if (!nullToAbsent || weeklyTarget != null) {
      map['weekly_target'] = Variable<int>(weeklyTarget);
    }
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    if (!nullToAbsent || anchorDate != null) {
      map['anchor_date'] = Variable<String>(anchorDate);
    }
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    map['effective_from'] = Variable<String>(effectiveFrom);
    return map;
  }

  HabitSchedulesCompanion toCompanion(bool nullToAbsent) {
    return HabitSchedulesCompanion(
      id: Value(id),
      habitId: Value(habitId),
      mode: Value(mode),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
      weeklyTarget: weeklyTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyTarget),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      anchorDate: anchorDate == null && nullToAbsent
          ? const Value.absent()
          : Value(anchorDate),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      effectiveFrom: Value(effectiveFrom),
    );
  }

  factory HabitSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitSchedule(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      mode: serializer.fromJson<String>(json['mode']),
      weekdays: serializer.fromJson<String?>(json['weekdays']),
      weeklyTarget: serializer.fromJson<int?>(json['weeklyTarget']),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      anchorDate: serializer.fromJson<String?>(json['anchorDate']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      effectiveFrom: serializer.fromJson<String>(json['effectiveFrom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'mode': serializer.toJson<String>(mode),
      'weekdays': serializer.toJson<String?>(weekdays),
      'weeklyTarget': serializer.toJson<int?>(weeklyTarget),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'anchorDate': serializer.toJson<String?>(anchorDate),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'effectiveFrom': serializer.toJson<String>(effectiveFrom),
    };
  }

  HabitSchedule copyWith(
          {String? id,
          String? habitId,
          String? mode,
          Value<String?> weekdays = const Value.absent(),
          Value<int?> weeklyTarget = const Value.absent(),
          Value<int?> intervalDays = const Value.absent(),
          Value<String?> anchorDate = const Value.absent(),
          String? startDate,
          Value<String?> endDate = const Value.absent(),
          String? effectiveFrom}) =>
      HabitSchedule(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        mode: mode ?? this.mode,
        weekdays: weekdays.present ? weekdays.value : this.weekdays,
        weeklyTarget:
            weeklyTarget.present ? weeklyTarget.value : this.weeklyTarget,
        intervalDays:
            intervalDays.present ? intervalDays.value : this.intervalDays,
        anchorDate: anchorDate.present ? anchorDate.value : this.anchorDate,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      );
  HabitSchedule copyWithCompanion(HabitSchedulesCompanion data) {
    return HabitSchedule(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      mode: data.mode.present ? data.mode.value : this.mode,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      weeklyTarget: data.weeklyTarget.present
          ? data.weeklyTarget.value
          : this.weeklyTarget,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      anchorDate:
          data.anchorDate.present ? data.anchorDate.value : this.anchorDate,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitSchedule(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('mode: $mode, ')
          ..write('weekdays: $weekdays, ')
          ..write('weeklyTarget: $weeklyTarget, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('effectiveFrom: $effectiveFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, mode, weekdays, weeklyTarget,
      intervalDays, anchorDate, startDate, endDate, effectiveFrom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitSchedule &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.mode == this.mode &&
          other.weekdays == this.weekdays &&
          other.weeklyTarget == this.weeklyTarget &&
          other.intervalDays == this.intervalDays &&
          other.anchorDate == this.anchorDate &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.effectiveFrom == this.effectiveFrom);
}

class HabitSchedulesCompanion extends UpdateCompanion<HabitSchedule> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> mode;
  final Value<String?> weekdays;
  final Value<int?> weeklyTarget;
  final Value<int?> intervalDays;
  final Value<String?> anchorDate;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<String> effectiveFrom;
  final Value<int> rowid;
  const HabitSchedulesCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.mode = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.weeklyTarget = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.anchorDate = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitSchedulesCompanion.insert({
    required String id,
    required String habitId,
    required String mode,
    this.weekdays = const Value.absent(),
    this.weeklyTarget = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.anchorDate = const Value.absent(),
    required String startDate,
    this.endDate = const Value.absent(),
    required String effectiveFrom,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        habitId = Value(habitId),
        mode = Value(mode),
        startDate = Value(startDate),
        effectiveFrom = Value(effectiveFrom);
  static Insertable<HabitSchedule> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? mode,
    Expression<String>? weekdays,
    Expression<int>? weeklyTarget,
    Expression<int>? intervalDays,
    Expression<String>? anchorDate,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? effectiveFrom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (mode != null) 'mode': mode,
      if (weekdays != null) 'weekdays': weekdays,
      if (weeklyTarget != null) 'weekly_target': weeklyTarget,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (anchorDate != null) 'anchor_date': anchorDate,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitSchedulesCompanion copyWith(
      {Value<String>? id,
      Value<String>? habitId,
      Value<String>? mode,
      Value<String?>? weekdays,
      Value<int?>? weeklyTarget,
      Value<int?>? intervalDays,
      Value<String?>? anchorDate,
      Value<String>? startDate,
      Value<String?>? endDate,
      Value<String>? effectiveFrom,
      Value<int>? rowid}) {
    return HabitSchedulesCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      mode: mode ?? this.mode,
      weekdays: weekdays ?? this.weekdays,
      weeklyTarget: weeklyTarget ?? this.weeklyTarget,
      intervalDays: intervalDays ?? this.intervalDays,
      anchorDate: anchorDate ?? this.anchorDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (weeklyTarget.present) {
      map['weekly_target'] = Variable<int>(weeklyTarget.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (anchorDate.present) {
      map['anchor_date'] = Variable<String>(anchorDate.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<String>(effectiveFrom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitSchedulesCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('mode: $mode, ')
          ..write('weekdays: $weekdays, ')
          ..write('weeklyTarget: $weeklyTarget, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('anchorDate: $anchorDate, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _habitIdMeta =
      const VerificationMeta('habitId');
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES habits (id)'));
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _weekdaysMeta =
      const VerificationMeta('weekdays');
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
      'weekdays', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, habitId, time, label, enabled, weekdays];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(Insertable<Reminder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('weekdays')) {
      context.handle(_weekdaysMeta,
          weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      habitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      weekdays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekdays']),
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final String id;
  final String habitId;

  /// 'HH:mm', local intended time.
  final String time;
  final String? label;
  final bool enabled;

  /// CSV override of ISO weekday ints; null = inherits the habit's schedule days.
  final String? weekdays;
  const Reminder(
      {required this.id,
      required this.habitId,
      required this.time,
      this.label,
      required this.enabled,
      this.weekdays});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['time'] = Variable<String>(time);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<String>(weekdays);
    }
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      habitId: Value(habitId),
      time: Value(time),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      enabled: Value(enabled),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
    );
  }

  factory Reminder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      time: serializer.fromJson<String>(json['time']),
      label: serializer.fromJson<String?>(json['label']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      weekdays: serializer.fromJson<String?>(json['weekdays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'time': serializer.toJson<String>(time),
      'label': serializer.toJson<String?>(label),
      'enabled': serializer.toJson<bool>(enabled),
      'weekdays': serializer.toJson<String?>(weekdays),
    };
  }

  Reminder copyWith(
          {String? id,
          String? habitId,
          String? time,
          Value<String?> label = const Value.absent(),
          bool? enabled,
          Value<String?> weekdays = const Value.absent()}) =>
      Reminder(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        time: time ?? this.time,
        label: label.present ? label.value : this.label,
        enabled: enabled ?? this.enabled,
        weekdays: weekdays.present ? weekdays.value : this.weekdays,
      );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      time: data.time.present ? data.time.value : this.time,
      label: data.label.present ? data.label.value : this.label,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('time: $time, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('weekdays: $weekdays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, time, label, enabled, weekdays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.time == this.time &&
          other.label == this.label &&
          other.enabled == this.enabled &&
          other.weekdays == this.weekdays);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> time;
  final Value<String?> label;
  final Value<bool> enabled;
  final Value<String?> weekdays;
  final Value<int> rowid;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.time = const Value.absent(),
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RemindersCompanion.insert({
    required String id,
    required String habitId,
    required String time,
    this.label = const Value.absent(),
    this.enabled = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        habitId = Value(habitId),
        time = Value(time);
  static Insertable<Reminder> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? time,
    Expression<String>? label,
    Expression<bool>? enabled,
    Expression<String>? weekdays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (time != null) 'time': time,
      if (label != null) 'label': label,
      if (enabled != null) 'enabled': enabled,
      if (weekdays != null) 'weekdays': weekdays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RemindersCompanion copyWith(
      {Value<String>? id,
      Value<String>? habitId,
      Value<String>? time,
      Value<String?>? label,
      Value<bool>? enabled,
      Value<String?>? weekdays,
      Value<int>? rowid}) {
    return RemindersCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      time: time ?? this.time,
      label: label ?? this.label,
      enabled: enabled ?? this.enabled,
      weekdays: weekdays ?? this.weekdays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('time: $time, ')
          ..write('label: $label, ')
          ..write('enabled: $enabled, ')
          ..write('weekdays: $weekdays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CheckInsTable extends CheckIns with TableInfo<$CheckInsTable, CheckIn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CheckInsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _habitIdMeta =
      const VerificationMeta('habitId');
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES habits (id)'));
  static const VerificationMeta _localDateMeta =
      const VerificationMeta('localDate');
  @override
  late final GeneratedColumn<String> localDate = GeneratedColumn<String>(
      'local_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, habitId, localDate, value, status, note, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'check_ins';
  @override
  VerificationContext validateIntegrity(Insertable<CheckIn> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(_habitIdMeta,
          habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta));
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('local_date')) {
      context.handle(_localDateMeta,
          localDate.isAcceptableOrUnknown(data['local_date']!, _localDateMeta));
    } else if (isInserting) {
      context.missing(_localDateMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {habitId, localDate},
      ];
  @override
  CheckIn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CheckIn(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      habitId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}habit_id'])!,
      localDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_date'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CheckInsTable createAlias(String alias) {
    return $CheckInsTable(attachedDatabase, alias);
  }
}

class CheckIn extends DataClass implements Insertable<CheckIn> {
  final String id;
  final String habitId;

  /// 'YYYY-MM-DD' — the occurrence this resolves, independent of UTC rollover.
  final String localDate;

  /// Logged amount for count/duration habits; null for binary.
  final double? value;
  final String status;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CheckIn(
      {required this.id,
      required this.habitId,
      required this.localDate,
      this.value,
      required this.status,
      this.note,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    map['local_date'] = Variable<String>(localDate);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CheckInsCompanion toCompanion(bool nullToAbsent) {
    return CheckInsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      localDate: Value(localDate),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CheckIn.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CheckIn(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      localDate: serializer.fromJson<String>(json['localDate']),
      value: serializer.fromJson<double?>(json['value']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'localDate': serializer.toJson<String>(localDate),
      'value': serializer.toJson<double?>(value),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CheckIn copyWith(
          {String? id,
          String? habitId,
          String? localDate,
          Value<double?> value = const Value.absent(),
          String? status,
          Value<String?> note = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CheckIn(
        id: id ?? this.id,
        habitId: habitId ?? this.habitId,
        localDate: localDate ?? this.localDate,
        value: value.present ? value.value : this.value,
        status: status ?? this.status,
        note: note.present ? note.value : this.note,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CheckIn copyWithCompanion(CheckInsCompanion data) {
    return CheckIn(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      localDate: data.localDate.present ? data.localDate.value : this.localDate,
      value: data.value.present ? data.value.value : this.value,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CheckIn(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('localDate: $localDate, ')
          ..write('value: $value, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, habitId, localDate, value, status, note, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CheckIn &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.localDate == this.localDate &&
          other.value == this.value &&
          other.status == this.status &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CheckInsCompanion extends UpdateCompanion<CheckIn> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<String> localDate;
  final Value<double?> value;
  final Value<String> status;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CheckInsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.localDate = const Value.absent(),
    this.value = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CheckInsCompanion.insert({
    required String id,
    required String habitId,
    required String localDate,
    this.value = const Value.absent(),
    required String status,
    this.note = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        habitId = Value(habitId),
        localDate = Value(localDate),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CheckIn> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<String>? localDate,
    Expression<double>? value,
    Expression<String>? status,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (localDate != null) 'local_date': localDate,
      if (value != null) 'value': value,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CheckInsCompanion copyWith(
      {Value<String>? id,
      Value<String>? habitId,
      Value<String>? localDate,
      Value<double?>? value,
      Value<String>? status,
      Value<String?>? note,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CheckInsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      localDate: localDate ?? this.localDate,
      value: value ?? this.value,
      status: status ?? this.status,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (localDate.present) {
      map['local_date'] = Variable<String>(localDate.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CheckInsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('localDate: $localDate, ')
          ..write('value: $value, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingEntriesTable extends AppSettingEntries
    with TableInfo<$AppSettingEntriesTable, AppSettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_setting_entries';
  @override
  VerificationContext validateIntegrity(Insertable<AppSettingEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingEntry(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppSettingEntriesTable createAlias(String alias) {
    return $AppSettingEntriesTable(attachedDatabase, alias);
  }
}

class AppSettingEntry extends DataClass implements Insertable<AppSettingEntry> {
  final String key;
  final String value;
  const AppSettingEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingEntriesCompanion toCompanion(bool nullToAbsent) {
    return AppSettingEntriesCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppSettingEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSettingEntry copyWith({String? key, String? value}) => AppSettingEntry(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppSettingEntry copyWithCompanion(AppSettingEntriesCompanion data) {
    return AppSettingEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingEntriesCompanion extends UpdateCompanion<AppSettingEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingEntriesCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppSettingEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingEntriesCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppSettingEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitSchedulesTable habitSchedules = $HabitSchedulesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $CheckInsTable checkIns = $CheckInsTable(this);
  late final $AppSettingEntriesTable appSettingEntries =
      $AppSettingEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [habits, habitSchedules, reminders, checkIns, appSettingEntries];
}

typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String name,
  required String type,
  required String icon,
  required int color,
  Value<String?> description,
  Value<String?> unit,
  Value<double?> target,
  Value<String?> goalDirection,
  Value<int> sortOrder,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> icon,
  Value<int> color,
  Value<String?> description,
  Value<String?> unit,
  Value<double?> target,
  Value<String?> goalDirection,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> archivedAt,
  Value<int> rowid,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitSchedulesTable, List<HabitSchedule>>
      _habitSchedulesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.habitSchedules,
              aliasName: 'habits__id__habit_schedules__habit_id');

  $$HabitSchedulesTableProcessedTableManager get habitSchedulesRefs {
    final manager = $$HabitSchedulesTableTableManager($_db, $_db.habitSchedules)
        .filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitSchedulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RemindersTable, List<Reminder>>
      _remindersRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.reminders,
              aliasName: 'habits__id__reminders__habit_id');

  $$RemindersTableProcessedTableManager get remindersRefs {
    final manager = $$RemindersTableTableManager($_db, $_db.reminders)
        .filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_remindersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CheckInsTable, List<CheckIn>> _checkInsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.checkIns,
          aliasName: 'habits__id__check_ins__habit_id');

  $$CheckInsTableProcessedTableManager get checkInsRefs {
    final manager = $$CheckInsTableTableManager($_db, $_db.checkIns)
        .filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_checkInsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get goalDirection => $composableBuilder(
      column: $table.goalDirection, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> habitSchedulesRefs(
      Expression<bool> Function($$HabitSchedulesTableFilterComposer f) f) {
    final $$HabitSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitSchedules,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.habitSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> remindersRefs(
      Expression<bool> Function($$RemindersTableFilterComposer f) f) {
    final $$RemindersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableFilterComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> checkInsRefs(
      Expression<bool> Function($$CheckInsTableFilterComposer f) f) {
    final $$CheckInsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.checkIns,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CheckInsTableFilterComposer(
              $db: $db,
              $table: $db.checkIns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get target => $composableBuilder(
      column: $table.target, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get goalDirection => $composableBuilder(
      column: $table.goalDirection,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => ColumnOrderings(column));
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get target =>
      $composableBuilder(column: $table.target, builder: (column) => column);

  GeneratedColumn<String> get goalDirection => $composableBuilder(
      column: $table.goalDirection, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
      column: $table.archivedAt, builder: (column) => column);

  Expression<T> habitSchedulesRefs<T extends Object>(
      Expression<T> Function($$HabitSchedulesTableAnnotationComposer a) f) {
    final $$HabitSchedulesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.habitSchedules,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitSchedulesTableAnnotationComposer(
              $db: $db,
              $table: $db.habitSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> remindersRefs<T extends Object>(
      Expression<T> Function($$RemindersTableAnnotationComposer a) f) {
    final $$RemindersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.reminders,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RemindersTableAnnotationComposer(
              $db: $db,
              $table: $db.reminders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> checkInsRefs<T extends Object>(
      Expression<T> Function($$CheckInsTableAnnotationComposer a) f) {
    final $$CheckInsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.checkIns,
        getReferencedColumn: (t) => t.habitId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CheckInsTableAnnotationComposer(
              $db: $db,
              $table: $db.checkIns,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$HabitsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (Habit, $$HabitsTableReferences),
    Habit,
    PrefetchHooks Function(
        {bool habitSchedulesRefs, bool remindersRefs, bool checkInsRefs})> {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<double?> target = const Value.absent(),
            Value<String?> goalDirection = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion(
            id: id,
            name: name,
            type: type,
            icon: icon,
            color: color,
            description: description,
            unit: unit,
            target: target,
            goalDirection: goalDirection,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String type,
            required String icon,
            required int color,
            Value<String?> description = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<double?> target = const Value.absent(),
            Value<String?> goalDirection = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> archivedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitsCompanion.insert(
            id: id,
            name: name,
            type: type,
            icon: icon,
            color: color,
            description: description,
            unit: unit,
            target: target,
            goalDirection: goalDirection,
            sortOrder: sortOrder,
            createdAt: createdAt,
            updatedAt: updatedAt,
            archivedAt: archivedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$HabitsTable, Habit>(table),
                    $$HabitsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {habitSchedulesRefs = false,
              remindersRefs = false,
              checkInsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (habitSchedulesRefs) db.habitSchedules,
                if (remindersRefs) db.reminders,
                if (checkInsRefs) db.checkIns
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitSchedulesRefs)
                    await $_getPrefetchedData<Habit, $HabitsTable,
                            HabitSchedule>(
                        currentTable: table,
                        referencedTable: $$HabitsTableReferences
                            ._habitSchedulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HabitsTableReferences(db, table, p0)
                                .habitSchedulesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.habitId == item.id),
                        typedResults: items),
                  if (remindersRefs)
                    await $_getPrefetchedData<Habit, $HabitsTable, Reminder>(
                        currentTable: table,
                        referencedTable:
                            $$HabitsTableReferences._remindersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HabitsTableReferences(db, table, p0)
                                .remindersRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.habitId == item.id),
                        typedResults: items),
                  if (checkInsRefs)
                    await $_getPrefetchedData<Habit, $HabitsTable, CheckIn>(
                        currentTable: table,
                        referencedTable:
                            $$HabitsTableReferences._checkInsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$HabitsTableReferences(db, table, p0).checkInsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.habitId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$HabitsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitsTable,
    Habit,
    $$HabitsTableFilterComposer,
    $$HabitsTableOrderingComposer,
    $$HabitsTableAnnotationComposer,
    $$HabitsTableCreateCompanionBuilder,
    $$HabitsTableUpdateCompanionBuilder,
    (Habit, $$HabitsTableReferences),
    Habit,
    PrefetchHooks Function(
        {bool habitSchedulesRefs, bool remindersRefs, bool checkInsRefs})>;
typedef $$HabitSchedulesTableCreateCompanionBuilder = HabitSchedulesCompanion
    Function({
  required String id,
  required String habitId,
  required String mode,
  Value<String?> weekdays,
  Value<int?> weeklyTarget,
  Value<int?> intervalDays,
  Value<String?> anchorDate,
  required String startDate,
  Value<String?> endDate,
  required String effectiveFrom,
  Value<int> rowid,
});
typedef $$HabitSchedulesTableUpdateCompanionBuilder = HabitSchedulesCompanion
    Function({
  Value<String> id,
  Value<String> habitId,
  Value<String> mode,
  Value<String?> weekdays,
  Value<int?> weeklyTarget,
  Value<int?> intervalDays,
  Value<String?> anchorDate,
  Value<String> startDate,
  Value<String?> endDate,
  Value<String> effectiveFrom,
  Value<int> rowid,
});

final class $$HabitSchedulesTableReferences
    extends BaseReferences<_$AppDatabase, $HabitSchedulesTable, HabitSchedule> {
  $$HabitSchedulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('habit_schedules__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager($_db, $_db.habits)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$HabitSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $HabitSchedulesTable> {
  $$HabitSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weeklyTarget => $composableBuilder(
      column: $table.weeklyTarget, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get anchorDate => $composableBuilder(
      column: $table.anchorDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => ColumnFilters(column));

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableFilterComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitSchedulesTable> {
  $$HabitSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weeklyTarget => $composableBuilder(
      column: $table.weeklyTarget,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get anchorDate => $composableBuilder(
      column: $table.anchorDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom,
      builder: (column) => ColumnOrderings(column));

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableOrderingComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitSchedulesTable> {
  $$HabitSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get weeklyTarget => $composableBuilder(
      column: $table.weeklyTarget, builder: (column) => column);

  GeneratedColumn<int> get intervalDays => $composableBuilder(
      column: $table.intervalDays, builder: (column) => column);

  GeneratedColumn<String> get anchorDate => $composableBuilder(
      column: $table.anchorDate, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableAnnotationComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$HabitSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HabitSchedulesTable,
    HabitSchedule,
    $$HabitSchedulesTableFilterComposer,
    $$HabitSchedulesTableOrderingComposer,
    $$HabitSchedulesTableAnnotationComposer,
    $$HabitSchedulesTableCreateCompanionBuilder,
    $$HabitSchedulesTableUpdateCompanionBuilder,
    (HabitSchedule, $$HabitSchedulesTableReferences),
    HabitSchedule,
    PrefetchHooks Function({bool habitId})> {
  $$HabitSchedulesTableTableManager(
      _$AppDatabase db, $HabitSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitSchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitSchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> habitId = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<int?> weeklyTarget = const Value.absent(),
            Value<int?> intervalDays = const Value.absent(),
            Value<String?> anchorDate = const Value.absent(),
            Value<String> startDate = const Value.absent(),
            Value<String?> endDate = const Value.absent(),
            Value<String> effectiveFrom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitSchedulesCompanion(
            id: id,
            habitId: habitId,
            mode: mode,
            weekdays: weekdays,
            weeklyTarget: weeklyTarget,
            intervalDays: intervalDays,
            anchorDate: anchorDate,
            startDate: startDate,
            endDate: endDate,
            effectiveFrom: effectiveFrom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String habitId,
            required String mode,
            Value<String?> weekdays = const Value.absent(),
            Value<int?> weeklyTarget = const Value.absent(),
            Value<int?> intervalDays = const Value.absent(),
            Value<String?> anchorDate = const Value.absent(),
            required String startDate,
            Value<String?> endDate = const Value.absent(),
            required String effectiveFrom,
            Value<int> rowid = const Value.absent(),
          }) =>
              HabitSchedulesCompanion.insert(
            id: id,
            habitId: habitId,
            mode: mode,
            weekdays: weekdays,
            weeklyTarget: weeklyTarget,
            intervalDays: intervalDays,
            anchorDate: anchorDate,
            startDate: startDate,
            endDate: endDate,
            effectiveFrom: effectiveFrom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$HabitSchedulesTable, HabitSchedule>(table),
                    $$HabitSchedulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (habitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.habitId,
                    referencedTable:
                        $$HabitSchedulesTableReferences._habitIdTable(db),
                    referencedColumn:
                        $$HabitSchedulesTableReferences._habitIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$HabitSchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HabitSchedulesTable,
    HabitSchedule,
    $$HabitSchedulesTableFilterComposer,
    $$HabitSchedulesTableOrderingComposer,
    $$HabitSchedulesTableAnnotationComposer,
    $$HabitSchedulesTableCreateCompanionBuilder,
    $$HabitSchedulesTableUpdateCompanionBuilder,
    (HabitSchedule, $$HabitSchedulesTableReferences),
    HabitSchedule,
    PrefetchHooks Function({bool habitId})>;
typedef $$RemindersTableCreateCompanionBuilder = RemindersCompanion Function({
  required String id,
  required String habitId,
  required String time,
  Value<String?> label,
  Value<bool> enabled,
  Value<String?> weekdays,
  Value<int> rowid,
});
typedef $$RemindersTableUpdateCompanionBuilder = RemindersCompanion Function({
  Value<String> id,
  Value<String> habitId,
  Value<String> time,
  Value<String?> label,
  Value<bool> enabled,
  Value<String?> weekdays,
  Value<int> rowid,
});

final class $$RemindersTableReferences
    extends BaseReferences<_$AppDatabase, $RemindersTable, Reminder> {
  $$RemindersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('reminders__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager($_db, $_db.habits)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnFilters(column));

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableFilterComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnOrderings(column));

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableOrderingComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableAnnotationComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RemindersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool habitId})> {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> habitId = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion(
            id: id,
            habitId: habitId,
            time: time,
            label: label,
            enabled: enabled,
            weekdays: weekdays,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String habitId,
            required String time,
            Value<String?> label = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RemindersCompanion.insert(
            id: id,
            habitId: habitId,
            time: time,
            label: label,
            enabled: enabled,
            weekdays: weekdays,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$RemindersTable, Reminder>(table),
                    $$RemindersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (habitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.habitId,
                    referencedTable:
                        $$RemindersTableReferences._habitIdTable(db),
                    referencedColumn:
                        $$RemindersTableReferences._habitIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RemindersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RemindersTable,
    Reminder,
    $$RemindersTableFilterComposer,
    $$RemindersTableOrderingComposer,
    $$RemindersTableAnnotationComposer,
    $$RemindersTableCreateCompanionBuilder,
    $$RemindersTableUpdateCompanionBuilder,
    (Reminder, $$RemindersTableReferences),
    Reminder,
    PrefetchHooks Function({bool habitId})>;
typedef $$CheckInsTableCreateCompanionBuilder = CheckInsCompanion Function({
  required String id,
  required String habitId,
  required String localDate,
  Value<double?> value,
  required String status,
  Value<String?> note,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CheckInsTableUpdateCompanionBuilder = CheckInsCompanion Function({
  Value<String> id,
  Value<String> habitId,
  Value<String> localDate,
  Value<double?> value,
  Value<String> status,
  Value<String?> note,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$CheckInsTableReferences
    extends BaseReferences<_$AppDatabase, $CheckInsTable, CheckIn> {
  $$CheckInsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('check_ins__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager($_db, $_db.habits)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CheckInsTableFilterComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableFilterComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CheckInsTableOrderingComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localDate => $composableBuilder(
      column: $table.localDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableOrderingComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CheckInsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CheckInsTable> {
  $$CheckInsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localDate =>
      $composableBuilder(column: $table.localDate, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.habitId,
        referencedTable: $db.habits,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$HabitsTableAnnotationComposer(
              $db: $db,
              $table: $db.habits,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CheckInsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CheckInsTable,
    CheckIn,
    $$CheckInsTableFilterComposer,
    $$CheckInsTableOrderingComposer,
    $$CheckInsTableAnnotationComposer,
    $$CheckInsTableCreateCompanionBuilder,
    $$CheckInsTableUpdateCompanionBuilder,
    (CheckIn, $$CheckInsTableReferences),
    CheckIn,
    PrefetchHooks Function({bool habitId})> {
  $$CheckInsTableTableManager(_$AppDatabase db, $CheckInsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CheckInsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CheckInsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CheckInsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> habitId = const Value.absent(),
            Value<String> localDate = const Value.absent(),
            Value<double?> value = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckInsCompanion(
            id: id,
            habitId: habitId,
            localDate: localDate,
            value: value,
            status: status,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String habitId,
            required String localDate,
            Value<double?> value = const Value.absent(),
            required String status,
            Value<String?> note = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CheckInsCompanion.insert(
            id: id,
            habitId: habitId,
            localDate: localDate,
            value: value,
            status: status,
            note: note,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CheckInsTable, CheckIn>(table),
                    $$CheckInsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (habitId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.habitId,
                    referencedTable:
                        $$CheckInsTableReferences._habitIdTable(db),
                    referencedColumn:
                        $$CheckInsTableReferences._habitIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CheckInsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CheckInsTable,
    CheckIn,
    $$CheckInsTableFilterComposer,
    $$CheckInsTableOrderingComposer,
    $$CheckInsTableAnnotationComposer,
    $$CheckInsTableCreateCompanionBuilder,
    $$CheckInsTableUpdateCompanionBuilder,
    (CheckIn, $$CheckInsTableReferences),
    CheckIn,
    PrefetchHooks Function({bool habitId})>;
typedef $$AppSettingEntriesTableCreateCompanionBuilder
    = AppSettingEntriesCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppSettingEntriesTableUpdateCompanionBuilder
    = AppSettingEntriesCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppSettingEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingEntriesTable> {
  $$AppSettingEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppSettingEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingEntriesTable> {
  $$AppSettingEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingEntriesTable> {
  $$AppSettingEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingEntriesTable,
    AppSettingEntry,
    $$AppSettingEntriesTableFilterComposer,
    $$AppSettingEntriesTableOrderingComposer,
    $$AppSettingEntriesTableAnnotationComposer,
    $$AppSettingEntriesTableCreateCompanionBuilder,
    $$AppSettingEntriesTableUpdateCompanionBuilder,
    (
      AppSettingEntry,
      BaseReferences<_$AppDatabase, $AppSettingEntriesTable, AppSettingEntry>
    ),
    AppSettingEntry,
    PrefetchHooks Function()> {
  $$AppSettingEntriesTableTableManager(
      _$AppDatabase db, $AppSettingEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingEntriesCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingEntriesCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AppSettingEntriesTable, AppSettingEntry>(
                        table),
                    BaseReferences<_$AppDatabase, $AppSettingEntriesTable,
                        AppSettingEntry>(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingEntriesTable,
    AppSettingEntry,
    $$AppSettingEntriesTableFilterComposer,
    $$AppSettingEntriesTableOrderingComposer,
    $$AppSettingEntriesTableAnnotationComposer,
    $$AppSettingEntriesTableCreateCompanionBuilder,
    $$AppSettingEntriesTableUpdateCompanionBuilder,
    (
      AppSettingEntry,
      BaseReferences<_$AppDatabase, $AppSettingEntriesTable, AppSettingEntry>
    ),
    AppSettingEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$HabitSchedulesTableTableManager get habitSchedules =>
      $$HabitSchedulesTableTableManager(_db, _db.habitSchedules);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$CheckInsTableTableManager get checkIns =>
      $$CheckInsTableTableManager(_db, _db.checkIns);
  $$AppSettingEntriesTableTableManager get appSettingEntries =>
      $$AppSettingEntriesTableTableManager(_db, _db.appSettingEntries);
}
