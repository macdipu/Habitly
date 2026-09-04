import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/notification_id.dart';
import 'package:customer/core/domain/habit/reminder_scheduler.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'notification_scheduler.dart';
import 'notification_settings_repository.dart';

/// Orchestrates the pure scheduling logic (`core/domain/habit`) against the
/// repository and the OS notification plugin. Cancels before rescheduling,
/// always (docs/SRS.md FR-51) — called after habit create/edit/archive/
/// delete, and on app startup for every active habit (BRD §9's "reconcile
/// on app startup").
class ReminderReconciler {
  final HabitRepository _habitRepository;
  final NotificationScheduler _notificationService;
  final NotificationSettingsRepository _settingsRepository;
  final ReminderScheduler _scheduler;

  ReminderReconciler(
    this._habitRepository,
    this._notificationService,
    this._settingsRepository, {
    ReminderScheduler scheduler = const ReminderScheduler(),
  }) : _scheduler = scheduler;

  Future<void> reconcileHabit(String habitId) async {
    final reminders = await _remindersOf(habitId);

    // Cancel every existing scheduled notification for this habit first —
    // unconditionally, so a disabled reminder or a just-archived habit
    // never leaves a stale notification behind.
    for (final reminder in reminders) {
      await _notificationService.cancel(stableNotificationId(habitId, reminder.id));
    }

    if (!await _settingsRepository.getMasterEnabled()) return;

    final habit = await _habitOf(habitId);
    if (habit == null || habit.isArchived) return;

    final schedules = await _schedulesOf(habitId);
    if (schedules.isEmpty) return;
    final activeRule = schedules.last.rule; // most recent effectiveFrom

    final quietHours = await _settingsRepository.getQuietHours();
    final shiftToEnd = await _settingsRepository.getShiftToQuietHoursEnd();
    final today = LocalDate.fromDateTime(DateTime.now());

    for (final reminder in reminders.where((r) => r.enabled)) {
      final fireTime = _scheduler.nextFireTime(
        rule: activeRule,
        from: today,
        reminderTimeHHmm: reminder.time,
        quietHours: quietHours,
        shiftToQuietHoursEnd: shiftToEnd,
      );
      if (fireTime == null) continue;

      var scheduledDate = _toTZDateTime(fireTime.date, fireTime.time);
      if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
        // The computed time already passed today (e.g. reconciled in the
        // afternoon for a morning reminder) — push to the next due date.
        final nextDate = _scheduler.nextDueDate(activeRule, fireTime.date.addDays(1));
        if (nextDate == null) continue;
        scheduledDate = _toTZDateTime(nextDate, fireTime.time);
      }

      await _notificationService.scheduleOneShot(
        id: stableNotificationId(habitId, reminder.id),
        title: habit.name,
        body: (reminder.label?.isNotEmpty ?? false) ? reminder.label! : 'Time for your habit',
        scheduledDate: scheduledDate,
      );
    }
  }

  Future<void> cancelHabit(String habitId) async {
    final reminders = await _remindersOf(habitId);
    for (final reminder in reminders) {
      await _notificationService.cancel(stableNotificationId(habitId, reminder.id));
    }
  }

  Future<void> reconcileAll() async {
    final habitsResult = await _habitRepository.getActiveHabits();
    final habits = habitsResult.fold((_) => const <HabitEntity>[], (r) => r);
    for (final habit in habits) {
      await reconcileHabit(habit.id);
    }
  }

  tz.TZDateTime _toTZDateTime(LocalDate date, String timeHHmm) {
    _ensureTimezoneFallback();
    final parts = timeHHmm.split(':');
    return tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// [HabitNotificationService.init] normally sets the detected local
  /// timezone before any reminder is ever scheduled. This is a defensive
  /// fallback for the (unlikely but possible) race where a reconcile runs
  /// first — e.g. `CreateHabitController.submit()` right after a cold
  /// start, before the fire-and-forget startup init finishes — so
  /// `tz.local` is never left uninitialized and crashing.
  void _ensureTimezoneFallback() {
    try {
      tz.local; // throws LateInitializationError if never set.
    } catch (_) {
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  Future<List<ReminderEntity>> _remindersOf(String habitId) async {
    final result = await _habitRepository.getReminders(habitId);
    return result.fold((_) => const [], (r) => r);
  }

  Future<HabitEntity?> _habitOf(String habitId) async {
    final result = await _habitRepository.getHabitById(habitId);
    return result.fold((_) => null, (r) => r);
  }

  Future<List<HabitScheduleEntity>> _schedulesOf(String habitId) async {
    final result = await _habitRepository.getSchedules(habitId);
    return result.fold((_) => const [], (r) => r);
  }
}
