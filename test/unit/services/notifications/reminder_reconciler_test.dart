import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/notification_id.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';
import 'package:customer/services/notifications/notification_settings_repository.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../features/habits/fake_habit_repository.dart';
import 'fake_notification_scheduler.dart';

void main() {
  final now = DateTime.utc(2026, 1, 1);

  late FakeHabitRepository repo;
  late FakeNotificationScheduler scheduler;
  late ReminderReconciler reconciler;

  setUp(() {
    repo = FakeHabitRepository();
    scheduler = FakeNotificationScheduler();
    // Storage is unavailable in the test environment; SharedPreference's
    // own try/catch makes every read fall through to defaults
    // (master enabled, quiet hours disabled) — exactly what these
    // orchestration-focused tests want. Policy details (quiet-hours
    // suppression/shift) are already covered by reminder_scheduler_test.dart.
    reconciler = ReminderReconciler(repo, scheduler, NotificationSettingsRepository());
  });

  HabitEntity activeHabit(String id) => HabitEntity(
        id: id,
        name: 'Drink water',
        type: HabitType.binary,
        icon: 'water_drop',
        color: 0xFF000000,
        createdAt: now,
        updatedAt: now,
      );

  HabitScheduleEntity dailySchedule(String habitId) => HabitScheduleEntity(
        id: '$habitId-schedule',
        habitId: habitId,
        rule: HabitScheduleRule(
          mode: ScheduleMode.daily,
          startDate: LocalDate.fromDateTime(now),
          effectiveFrom: LocalDate.fromDateTime(now),
        ),
      );

  group('ReminderReconciler.reconcileHabit', () {
    test('schedules an enabled reminder for an active habit', () async {
      const habitId = 'habit-1';
      repo.habits[habitId] = activeHabit(habitId);
      repo.schedules[habitId] = [dailySchedule(habitId)];
      repo.reminders[habitId] = [
        const ReminderEntity(id: 'r1', habitId: habitId, time: '08:00'),
      ];

      await reconciler.reconcileHabit(habitId);

      expect(scheduler.calls.whereType<ScheduledCall>(), hasLength(1));
      final scheduled = scheduler.calls.whereType<ScheduledCall>().single;
      expect(scheduled.id, stableNotificationId(habitId, 'r1'));
      expect(scheduled.title, 'Drink water');
    });

    test('cancels before rescheduling on a second reconcile', () async {
      const habitId = 'habit-1';
      repo.habits[habitId] = activeHabit(habitId);
      repo.schedules[habitId] = [dailySchedule(habitId)];
      repo.reminders[habitId] = [
        const ReminderEntity(id: 'r1', habitId: habitId, time: '08:00'),
      ];

      await reconciler.reconcileHabit(habitId);
      await reconciler.reconcileHabit(habitId);

      // Every reconcile unconditionally cancels this habit's reminders
      // first, then reschedules (docs/SRS.md FR-51) — so each of the two
      // calls contributes one cancel followed by one schedule.
      final id = stableNotificationId(habitId, 'r1');
      final relevant = scheduler.calls
          .where((c) => (c is ScheduledCall && c.id == id) || (c is CancelledCall && c.id == id))
          .toList();
      expect(relevant, hasLength(4));
      expect(relevant[0], isA<CancelledCall>());
      expect(relevant[1], isA<ScheduledCall>());
      expect(relevant[2], isA<CancelledCall>());
      expect(relevant[3], isA<ScheduledCall>());
    });

    test('an archived habit is cancelled but never scheduled', () async {
      const habitId = 'habit-1';
      repo.habits[habitId] = activeHabit(habitId).copyWith(archivedAt: now);
      repo.schedules[habitId] = [dailySchedule(habitId)];
      repo.reminders[habitId] = [
        const ReminderEntity(id: 'r1', habitId: habitId, time: '08:00'),
      ];

      await reconciler.reconcileHabit(habitId);

      expect(scheduler.calls.whereType<ScheduledCall>(), isEmpty);
      expect(scheduler.calls.whereType<CancelledCall>(), hasLength(1));
    });

    test('a disabled reminder is cancelled but not rescheduled, while its sibling still fires', () async {
      const habitId = 'habit-1';
      repo.habits[habitId] = activeHabit(habitId);
      repo.schedules[habitId] = [dailySchedule(habitId)];
      repo.reminders[habitId] = [
        const ReminderEntity(id: 'r1', habitId: habitId, time: '08:00', enabled: false),
        const ReminderEntity(id: 'r2', habitId: habitId, time: '20:00'),
      ];

      await reconciler.reconcileHabit(habitId);

      final scheduledIds = scheduler.calls.whereType<ScheduledCall>().map((c) => c.id).toSet();
      expect(scheduledIds, {stableNotificationId(habitId, 'r2')});
      final cancelledIds = scheduler.calls.whereType<CancelledCall>().map((c) => c.id).toSet();
      expect(cancelledIds, {stableNotificationId(habitId, 'r1'), stableNotificationId(habitId, 'r2')});
    });
  });

  group('ReminderReconciler.cancelHabit', () {
    test('cancels every reminder for a habit without needing it to still exist', () async {
      const habitId = 'habit-1';
      repo.reminders[habitId] = [
        const ReminderEntity(id: 'r1', habitId: habitId, time: '08:00'),
        const ReminderEntity(id: 'r2', habitId: habitId, time: '20:00'),
      ];

      await reconciler.cancelHabit(habitId);

      final cancelledIds = scheduler.calls.whereType<CancelledCall>().map((c) => c.id).toSet();
      expect(cancelledIds, {stableNotificationId(habitId, 'r1'), stableNotificationId(habitId, 'r2')});
      expect(scheduler.calls.whereType<ScheduledCall>(), isEmpty);
    });
  });
}
