import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/usecase/usecase.dart';

import '../entity/check_in_entity.dart';
import '../entity/habit_entity.dart';
import '../entity/habit_schedule_entity.dart';
import '../entity/reminder_entity.dart';

abstract class HabitRepository {
  ResultFuture<List<HabitEntity>> getActiveHabits();

  ResultFuture<List<HabitEntity>> getArchivedHabits();

  ResultFuture<HabitEntity> getHabitById(String id);

  /// All schedule rows for a habit, ascending by `effectiveFrom`.
  ResultFuture<List<HabitScheduleEntity>> getSchedules(String habitId);

  ResultFuture<List<ReminderEntity>> getReminders(String habitId);

  /// Persists a new habit + its first schedule row + reminders in one
  /// transaction. Atomic per docs/SRS.md FR-12 — the caller schedules
  /// notifications separately after this succeeds.
  ResultVoid createHabit({
    required HabitEntity habit,
    required HabitScheduleEntity schedule,
    List<ReminderEntity> reminders,
  });

  /// Updates habit fields in place (name/icon/color/goal/etc — never
  /// touches historical check-ins) and appends a new schedule row when
  /// [newSchedule] is provided.
  ResultVoid updateHabit({
    required HabitEntity habit,
    HabitScheduleEntity? newSchedule,
    List<ReminderEntity>? reminders,
  });

  ResultVoid archiveHabit(String habitId);

  ResultVoid restoreHabit(String habitId);

  /// Permanently deletes a habit and all its schedules/reminders/check-ins.
  ResultVoid deleteHabit(String habitId);

  /// Check-ins for one habit within an inclusive local-date range.
  ResultFuture<List<CheckInEntity>> getCheckIns({
    required String habitId,
    required LocalDate from,
    required LocalDate to,
  });

  /// Check-ins across all active habits for a single local date — powers
  /// the Today dashboard.
  ResultFuture<List<CheckInEntity>> getCheckInsForDate(LocalDate date);

  /// Inserts or updates the (habitId, localDate) row.
  ResultVoid upsertCheckIn(CheckInEntity checkIn);

  ResultVoid deleteCheckIn({required String habitId, required LocalDate localDate});
}
