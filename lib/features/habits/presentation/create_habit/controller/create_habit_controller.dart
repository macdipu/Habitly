import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/habit_schedule_rule.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/habit_schedule_entity.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/features/habits/domain/usecase/create_habit_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

/// Available icon keys — kept small deliberately; extend alongside
/// `TodayHabitCard._iconFor` when the real icon picker (S07) is built.
const kHabitIconOptions = ['check', 'water_drop', 'book', 'fitness', 'sleep', 'smoking'];

const kHabitColorOptions = <int>[
  0xFF2E7D32, // green
  0xFF1565C0, // blue
  0xFFEF6C00, // orange
  0xFF6A1B9A, // purple
  0xFFC62828, // red
  0xFF00838F, // teal
];

/// Backs the create-habit flow (S07–S11, condensed into Basics / Schedule /
/// Goal / Review steps — reminders are configured after Phase 2 wires real
/// notification scheduling, see docs/ARCHITECTURE.md §9).
class CreateHabitController extends BaseController {
  final CreateHabitUseCase _createHabit;

  CreateHabitController(HabitRepository repository) : _createHabit = CreateHabitUseCase(repository);

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final Rx<HabitType> type = HabitType.binary.obs;
  final RxString icon = kHabitIconOptions.first.obs;
  final RxInt color = kHabitColorOptions.first.obs;

  final Rx<ScheduleMode> scheduleMode = ScheduleMode.daily.obs;
  final RxSet<int> weekdays = <int>{}.obs;
  final RxInt weeklyTarget = 3.obs;
  final RxInt intervalDays = 2.obs;
  final Rx<LocalDate> startDate = LocalDate.fromDateTime(DateTime.now()).obs;

  final RxDouble target = 8.obs;
  final RxString unit = ''.obs;

  final RxInt currentStep = 0.obs;

  bool get canContinueBasics => nameController.text.trim().isNotEmpty;

  bool get canContinueSchedule =>
      scheduleMode.value != ScheduleMode.weekdays || weekdays.isNotEmpty;

  bool get needsGoalStep => type.value != HabitType.binary;

  String get schedulePreview {
    final dateLabel = DateFormat.MMMd().format(startDate.value.toDateTime());
    switch (scheduleMode.value) {
      case ScheduleMode.daily:
        return 'Every day, starting $dateLabel';
      case ScheduleMode.weekdays:
        if (weekdays.isEmpty) return 'Pick at least one day';
        final names = (weekdays.toList()..sort()).map(_weekdayShortName).join(', ');
        return '$names, starting $dateLabel';
      case ScheduleMode.timesPerWeek:
        return '${weeklyTarget.value}x per week, starting $dateLabel';
      case ScheduleMode.interval:
        return 'Every ${intervalDays.value} days, starting $dateLabel';
    }
  }

  String _weekdayShortName(int iso) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][iso - 1];

  void nextStep() {
    final last = needsGoalStep ? 3 : 2;
    if (currentStep.value < last) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

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
      unit: type.value == HabitType.binary ? null : (unit.value.isEmpty ? null : unit.value),
      target: type.value == HabitType.binary ? null : target.value,
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

    await doAction<void>(
      action: () => _createHabit(CreateHabitParams(habit: habit, schedule: schedule)),
      onSuccess: (_) => Get.back(result: true),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
