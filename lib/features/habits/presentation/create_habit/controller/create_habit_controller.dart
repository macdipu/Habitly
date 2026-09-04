import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/create_habit_use_case.dart';
import 'package:customer/features/habits/presentation/habit_form/habit_form_controller.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Backs the create-habit flow (S07–S11: Basics / Schedule / Goal /
/// Reminders / Review).
class CreateHabitController extends HabitFormController {
  final CreateHabitUseCase _createHabit;
  final ReminderReconciler _reminderReconciler;

  CreateHabitController(
    HabitRepository repository,
    HabitNotificationService notificationService,
    this._reminderReconciler,
  )   : _createHabit = CreateHabitUseCase(repository),
        super(notificationService);

  @override
  Future<void> submit() async {
    final now = DateTime.now().toUtc();
    final habitId = const Uuid().v4();

    final habit = HabitEntity(
      id: habitId,
      name: nameController.text.trim(),
      type: type.value,
      icon: icon.value,
      color: color.value,
      description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
      unit: type.value == HabitType.binary ? null : (unitController.text.isEmpty ? null : unitController.text),
      target: type.value == HabitType.binary ? null : (double.tryParse(targetController.text) ?? 0),
      goalDirection: type.value == HabitType.avoid ? GoalDirection.atMost : GoalDirection.atLeast,
      createdAt: now,
      updatedAt: now,
    );

    final schedule = HabitScheduleEntity(
      id: const Uuid().v4(),
      habitId: habitId,
      rule: HabitScheduleRule(
        mode: scheduleMode.value,
        weekdays: scheduleMode.value == ScheduleMode.weekdays ? weekdays.toSet() : const {},
        weeklyTarget: scheduleMode.value == ScheduleMode.timesPerWeek ? weeklyTarget.value : null,
        intervalDays: scheduleMode.value == ScheduleMode.interval ? intervalDays.value : null,
        anchorDate: scheduleMode.value == ScheduleMode.interval ? startDate.value : null,
        startDate: startDate.value,
        effectiveFrom: startDate.value,
      ),
    );

    final reminders = remindersEnabled.value
        ? reminderDrafts
            .map((d) => ReminderEntity(
                  id: const Uuid().v4(),
                  habitId: habitId,
                  time: d.time,
                  label: d.label.trim().isEmpty ? null : d.label.trim(),
                ))
            .toList()
        : const <ReminderEntity>[];

    await doAction<void>(
      action: () => _createHabit(CreateHabitParams(habit: habit, schedule: schedule, reminders: reminders)),
      onSuccess: (_) async {
        // Creation is already atomic and saved by this point — a
        // scheduling failure here must never undo the habit (BRD §S11,
        // docs/SRS.md FR-12).
        if (reminders.isNotEmpty) {
          try {
            await _reminderReconciler.reconcileHabit(habitId);
          } catch (_) {
            // Non-blocking: the habit is saved; reminders can be fixed
            // later from Habit Detail or picked up by the next reconcile.
          }
        }
        Get.back(result: true);
      },
    );
  }
}
