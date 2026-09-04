import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/entity/reminder_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/get_habit_by_id_use_case.dart';
import 'package:customer/features/habits/domain/usecase/update_habit_use_case.dart';
import 'package:customer/features/habits/presentation/habit_form/habit_form_controller.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

/// Backs the edit-habit flow (S13). Loads the current definition, lets the
/// user change any field, then saves without corrupting history
/// (docs/SRS.md FR-13): a new schedule row is appended only when the
/// recurrence pattern itself changed; unrelated edits (name, color, goal)
/// leave the active schedule row untouched so an `interval` habit's phase
/// never resets just because someone fixed a typo in the name.
class EditHabitController extends HabitFormController {
  final String habitId;

  final GetHabitByIdUseCase _getHabit;
  final UpdateHabitUseCase _updateHabit;
  final HabitRepository _repository;
  final ReminderReconciler _reminderReconciler;

  EditHabitController(
    this._repository,
    HabitNotificationService notificationService,
    this._reminderReconciler,
    this.habitId,
  )   : _getHabit = GetHabitByIdUseCase(_repository),
        _updateHabit = UpdateHabitUseCase(_repository),
        super(notificationService);

  HabitEntity? _originalHabit;
  HabitScheduleRule? _originalRule;
  final RxBool loaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    await doAction<HabitEntity>(
      action: () => _getHabit(habitId),
      onSuccess: (habit) async {
        _originalHabit = habit;
        nameController.text = habit.name;
        descriptionController.text = habit.description ?? '';
        type.value = habit.type;
        icon.value = habit.icon;
        color.value = habit.color;
        targetController.text = (habit.target ?? 8).toStringAsFixed(0);
        unitController.text = habit.unit ?? '';

        final schedulesResult = await _repository.getSchedules(habitId);
        schedulesResult.fold((_) {}, (schedules) {
          if (schedules.isEmpty) return;
          final rule = schedules.last.rule;
          _originalRule = rule;
          scheduleMode.value = rule.mode;
          weekdays.assignAll(rule.weekdays);
          weeklyTarget.value = rule.weeklyTarget ?? 3;
          intervalDays.value = rule.intervalDays ?? 2;
          startDate.value = rule.startDate;
        });

        final remindersResult = await _repository.getReminders(habitId);
        remindersResult.fold((_) {}, (reminders) {
          if (reminders.isEmpty) return;
          remindersEnabled.value = true;
          reminderDrafts.assignAll(
            reminders.map((r) => ReminderDraft(time: r.time, label: r.label ?? '')),
          );
        });

        loaded.value = true;
      },
    );
  }

  /// Builds the recurrence rule implied by the form's current field values,
  /// anchored at [effectiveFrom] (used both to shape-compare against the
  /// original and, when it actually changed, as the new schedule row).
  HabitScheduleRule _candidateRule(LocalDate effectiveFrom) {
    return HabitScheduleRule(
      mode: scheduleMode.value,
      weekdays: scheduleMode.value == ScheduleMode.weekdays ? weekdays.toSet() : const {},
      weeklyTarget: scheduleMode.value == ScheduleMode.timesPerWeek ? weeklyTarget.value : null,
      intervalDays: scheduleMode.value == ScheduleMode.interval ? intervalDays.value : null,
      anchorDate: scheduleMode.value == ScheduleMode.interval ? effectiveFrom : null,
      startDate: effectiveFrom,
      effectiveFrom: effectiveFrom,
    );
  }

  @override
  Future<void> submit() async {
    final original = _originalHabit;
    if (original == null) return;

    final now = DateTime.now().toUtc();
    final trimmedDescription = descriptionController.text.trim();
    final isBinary = type.value == HabitType.binary;
    final updatedHabit = original.copyWith(
      name: nameController.text.trim(),
      type: type.value,
      icon: icon.value,
      color: color.value,
      description: trimmedDescription.isEmpty ? null : trimmedDescription,
      clearDescription: trimmedDescription.isEmpty,
      unit: isBinary ? null : (unitController.text.isEmpty ? null : unitController.text),
      clearUnit: isBinary || unitController.text.isEmpty,
      target: isBinary ? null : (double.tryParse(targetController.text) ?? 0),
      clearTarget: isBinary,
      goalDirection: type.value == HabitType.avoid ? GoalDirection.atMost : GoalDirection.atLeast,
      updatedAt: now,
    );

    final today = LocalDate.fromDateTime(DateTime.now());
    final candidate = _candidateRule(today);
    final shapeChanged = _originalRule == null || !_originalRule!.hasSameShapeAs(candidate);

    HabitScheduleEntity? newSchedule;
    if (shapeChanged) {
      newSchedule = HabitScheduleEntity(id: const Uuid().v4(), habitId: habitId, rule: candidate);
    }

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
      action: () => _updateHabit(UpdateHabitParams(
        habit: updatedHabit,
        newSchedule: newSchedule,
        reminders: reminders,
      )),
      onSuccess: (_) async {
        try {
          await _reminderReconciler.reconcileHabit(habitId);
        } catch (_) {
          // Non-blocking: the edit is saved regardless of scheduling outcome.
        }
        Get.back(result: true);
      },
    );
  }
}
