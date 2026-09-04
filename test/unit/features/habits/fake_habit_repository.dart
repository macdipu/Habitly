import 'package:customer/core/domain/error/failure.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';
import 'package:customer/features/habits/domain/entity/check_in_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:dartz/dartz.dart';

/// In-memory [HabitRepository] for testing usecases without a real
/// database — keeps the domain layer's "testable without widgets" promise
/// (CLAUDE.md) honest for composition usecases, not just leaf calculators.
class FakeHabitRepository implements HabitRepository {
  final Map<String, HabitEntity> habits = {};
  final Map<String, List<HabitScheduleEntity>> schedules = {};
  final Map<String, List<ReminderEntity>> reminders = {};
  final Map<String, CheckInEntity> checkIns = {}; // key: '$habitId|$localDate'

  String _checkInKey(String habitId, LocalDate date) => '$habitId|$date';

  @override
  ResultFuture<List<HabitEntity>> getActiveHabits() async =>
      Right(habits.values.where((h) => !h.isArchived).toList());

  @override
  ResultFuture<List<HabitEntity>> getArchivedHabits() async =>
      Right(habits.values.where((h) => h.isArchived).toList());

  @override
  ResultFuture<HabitEntity> getHabitById(String id) async {
    final habit = habits[id];
    if (habit == null) return const Left(LocalDatabaseQueryFailure('Habit not found'));
    return Right(habit);
  }

  @override
  ResultFuture<List<HabitScheduleEntity>> getSchedules(String habitId) async =>
      Right(schedules[habitId] ?? const []);

  @override
  ResultFuture<List<ReminderEntity>> getReminders(String habitId) async =>
      Right(reminders[habitId] ?? const []);

  @override
  ResultVoid createHabit({
    required HabitEntity habit,
    required HabitScheduleEntity schedule,
    List<ReminderEntity> reminders = const [],
  }) async {
    habits[habit.id] = habit;
    schedules[habit.id] = [schedule];
    this.reminders[habit.id] = reminders;
    return const Right(null);
  }

  @override
  ResultVoid updateHabit({
    required HabitEntity habit,
    HabitScheduleEntity? newSchedule,
    List<ReminderEntity>? reminders,
  }) async {
    habits[habit.id] = habit;
    if (newSchedule != null) {
      schedules.putIfAbsent(habit.id, () => []).add(newSchedule);
    }
    if (reminders != null) this.reminders[habit.id] = reminders;
    return const Right(null);
  }

  @override
  ResultVoid archiveHabit(String habitId) async {
    final habit = habits[habitId];
    if (habit == null) return const Left(LocalDatabaseQueryFailure('Habit not found'));
    habits[habitId] = habit.copyWith(archivedAt: DateTime.now().toUtc());
    return const Right(null);
  }

  @override
  ResultVoid restoreHabit(String habitId) async {
    final habit = habits[habitId];
    if (habit == null) return const Left(LocalDatabaseQueryFailure('Habit not found'));
    habits[habitId] = habit.copyWith(clearArchivedAt: true);
    return const Right(null);
  }

  @override
  ResultVoid deleteHabit(String habitId) async {
    habits.remove(habitId);
    schedules.remove(habitId);
    reminders.remove(habitId);
    checkIns.removeWhere((key, _) => key.startsWith('$habitId|'));
    return const Right(null);
  }

  @override
  ResultFuture<List<CheckInEntity>> getCheckIns({
    required String habitId,
    required LocalDate from,
    required LocalDate to,
  }) async {
    final result = checkIns.values
        .where((c) =>
            c.habitId == habitId && !c.localDate.isBefore(from) && !c.localDate.isAfter(to))
        .toList()
      ..sort((a, b) => a.localDate.compareTo(b.localDate));
    return Right(result);
  }

  @override
  ResultFuture<List<CheckInEntity>> getCheckInsForDate(LocalDate date) async =>
      Right(checkIns.values.where((c) => c.localDate == date).toList());

  @override
  ResultVoid upsertCheckIn(CheckInEntity checkIn) async {
    checkIns[_checkInKey(checkIn.habitId, checkIn.localDate)] = checkIn;
    return const Right(null);
  }

  @override
  ResultVoid deleteCheckIn({required String habitId, required LocalDate localDate}) async {
    checkIns.remove(_checkInKey(habitId, localDate));
    return const Right(null);
  }

  @override
  ResultVoid deleteAllData() async {
    habits.clear();
    schedules.clear();
    reminders.clear();
    checkIns.clear();
    return const Right(null);
  }

  @override
  ResultVoid replaceAllData({
    required List<HabitEntity> habits,
    required List<HabitScheduleEntity> schedules,
    required List<ReminderEntity> reminders,
    required List<CheckInEntity> checkIns,
  }) async {
    this.habits
      ..clear()
      ..addEntries(habits.map((h) => MapEntry(h.id, h)));
    this.schedules
      ..clear()
      ..addAll(schedules.fold<Map<String, List<HabitScheduleEntity>>>({}, (map, s) {
        map.putIfAbsent(s.habitId, () => []).add(s);
        return map;
      }));
    this.reminders
      ..clear()
      ..addAll(reminders.fold<Map<String, List<ReminderEntity>>>({}, (map, r) {
        map.putIfAbsent(r.habitId, () => []).add(r);
        return map;
      }));
    this.checkIns
      ..clear()
      ..addEntries(checkIns.map((c) => MapEntry(_checkInKey(c.habitId, c.localDate), c)));
    return const Right(null);
  }
}
