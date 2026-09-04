import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';

import 'package:customer/core/data/database/app_database.dart' as db;
import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../../domain/entity/check_in_entity.dart';
import '../../domain/entity/habit_entity.dart';
import '../../domain/entity/habit_schedule_entity.dart';
import '../../domain/entity/reminder_entity.dart';
import '../../domain/repo/habit_repository.dart';
import '../model/check_in_dto.dart';
import '../model/habit_dto.dart';
import '../model/habit_schedule_dto.dart';
import '../model/reminder_dto.dart';

class HabitRepositoryImpl implements HabitRepository {
  final db.AppDatabase _db;

  const HabitRepositoryImpl(this._db);

  @override
  ResultFuture<List<HabitEntity>> getActiveHabits() async {
    try {
      final rows = await (_db.select(_db.habits)
            ..where((t) => t.archivedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();
      return Right(rows.map(HabitDto.toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<HabitEntity>> getArchivedHabits() async {
    try {
      final rows = await (_db.select(_db.habits)
            ..where((t) => t.archivedAt.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.archivedAt)]))
          .get();
      return Right(rows.map(HabitDto.toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultFuture<HabitEntity> getHabitById(String id) async {
    try {
      final row =
          await (_db.select(_db.habits)..where((t) => t.id.equals(id))).getSingleOrNull();
      if (row == null) return const Left(LocalDatabaseQueryFailure('Habit not found'));
      return Right(HabitDto.toEntity(row));
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<HabitScheduleEntity>> getSchedules(String habitId) async {
    try {
      final rows = await (_db.select(_db.habitSchedules)
            ..where((t) => t.habitId.equals(habitId))
            ..orderBy([(t) => OrderingTerm.asc(t.effectiveFrom)]))
          .get();
      return Right(rows.map(HabitScheduleDto.toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<ReminderEntity>> getReminders(String habitId) async {
    try {
      final rows =
          await (_db.select(_db.reminders)..where((t) => t.habitId.equals(habitId))).get();
      return Right(rows.map(ReminderDto.toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultVoid createHabit({
    required HabitEntity habit,
    required HabitScheduleEntity schedule,
    List<ReminderEntity> reminders = const [],
  }) async {
    try {
      await _db.transaction(() async {
        await _db.into(_db.habits).insert(HabitDto.toInsertCompanion(habit));
        await _db.into(_db.habitSchedules).insert(HabitScheduleDto.toInsertCompanion(schedule));
        for (final reminder in reminders) {
          await _db.into(_db.reminders).insert(ReminderDto.toInsertCompanion(reminder));
        }
      });
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultVoid updateHabit({
    required HabitEntity habit,
    HabitScheduleEntity? newSchedule,
    List<ReminderEntity>? reminders,
  }) async {
    try {
      await _db.transaction(() async {
        await (_db.update(_db.habits)..where((t) => t.id.equals(habit.id)))
            .write(HabitDto.toUpdateCompanion(habit));

        if (newSchedule != null) {
          await _db.into(_db.habitSchedules).insert(HabitScheduleDto.toInsertCompanion(newSchedule));
        }

        if (reminders != null) {
          await (_db.delete(_db.reminders)..where((t) => t.habitId.equals(habit.id))).go();
          for (final reminder in reminders) {
            await _db.into(_db.reminders).insert(ReminderDto.toInsertCompanion(reminder));
          }
        }
      });
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultVoid archiveHabit(String habitId) async {
    try {
      await (_db.update(_db.habits)..where((t) => t.id.equals(habitId))).write(
        db.HabitsCompanion(archivedAt: Value(DateTime.now().toUtc())),
      );
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultVoid restoreHabit(String habitId) async {
    try {
      await (_db.update(_db.habits)..where((t) => t.id.equals(habitId))).write(
        const db.HabitsCompanion(archivedAt: Value(null)),
      );
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultVoid deleteHabit(String habitId) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(_db.checkIns)..where((t) => t.habitId.equals(habitId))).go();
        await (_db.delete(_db.reminders)..where((t) => t.habitId.equals(habitId))).go();
        await (_db.delete(_db.habitSchedules)..where((t) => t.habitId.equals(habitId))).go();
        await (_db.delete(_db.habits)..where((t) => t.id.equals(habitId))).go();
      });
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<CheckInEntity>> getCheckIns({
    required String habitId,
    required LocalDate from,
    required LocalDate to,
  }) async {
    try {
      final rows = await (_db.select(_db.checkIns)
            ..where((t) =>
                t.habitId.equals(habitId) &
                t.localDate.isBiggerOrEqualValue(from.toString()) &
                t.localDate.isSmallerOrEqualValue(to.toString()))
            ..orderBy([(t) => OrderingTerm.asc(t.localDate)]))
          .get();
      return Right(rows.map(CheckInDto.toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<CheckInEntity>> getCheckInsForDate(LocalDate date) async {
    try {
      final rows =
          await (_db.select(_db.checkIns)..where((t) => t.localDate.equals(date.toString())))
              .get();
      return Right(rows.map(CheckInDto.toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultVoid upsertCheckIn(CheckInEntity checkIn) async {
    try {
      final existing = await (_db.select(_db.checkIns)
            ..where((t) =>
                t.habitId.equals(checkIn.habitId) &
                t.localDate.equals(checkIn.localDate.toString())))
          .getSingleOrNull();

      if (existing != null) {
        await (_db.update(_db.checkIns)..where((t) => t.id.equals(existing.id))).write(
          db.CheckInsCompanion(
            value: Value(checkIn.value),
            status: Value(checkIn.status.name),
            note: Value(checkIn.note),
            updatedAt: Value(checkIn.updatedAt),
          ),
        );
      } else {
        await _db.into(_db.checkIns).insert(CheckInDto.toInsertCompanion(checkIn));
      }
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }

  @override
  ResultVoid deleteCheckIn({required String habitId, required LocalDate localDate}) async {
    try {
      await (_db.delete(_db.checkIns)
            ..where((t) => t.habitId.equals(habitId) & t.localDate.equals(localDate.toString())))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(LocalDatabaseQueryFailure(e.toString()));
    }
  }
}
