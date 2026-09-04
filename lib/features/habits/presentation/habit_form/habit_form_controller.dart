import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

/// A reminder time being edited in the form, before it has an id — becomes
/// a [ReminderEntity] only on submit.
class ReminderDraft {
  String time; // 'HH:mm'
  String label;

  ReminderDraft({this.time = '09:00', this.label = ''});
}

/// Shared field state + step navigation behind Create Habit (S07–S11) and
/// Edit Habit (S13) — both flows edit the same shape (Basics / Schedule /
/// Goal / Reminders / Review); only what happens on [submit] differs.
abstract class HabitFormController extends BaseController {
  final HabitNotificationService notificationService;

  HabitFormController(this.notificationService);

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

  final targetController = TextEditingController(text: '8');
  final unitController = TextEditingController();

  final RxBool remindersEnabled = false.obs;
  final RxList<ReminderDraft> reminderDrafts = <ReminderDraft>[].obs;

  /// null = not yet checked/requested this session.
  final Rx<bool?> notificationPermissionGranted = Rx<bool?>(null);

  final RxInt currentStep = 0.obs;

  bool get canContinueBasics => nameController.text.trim().isNotEmpty;

  bool get canContinueSchedule =>
      scheduleMode.value != ScheduleMode.weekdays || weekdays.isNotEmpty;

  bool get needsGoalStep => type.value != HabitType.binary;

  int get remindersStepIndex => needsGoalStep ? 3 : 2;

  int get reviewStepIndex => remindersStepIndex + 1;

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
    if (currentStep.value < reviewStepIndex) currentStep.value++;
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void toggleReminders(bool value) {
    remindersEnabled.value = value;
    if (value && reminderDrafts.isEmpty) {
      reminderDrafts.add(ReminderDraft());
    }
  }

  void addReminder() => reminderDrafts.add(ReminderDraft());

  void removeReminder(int index) => reminderDrafts.removeAt(index);

  void setReminderTime(int index, String hhmm) {
    reminderDrafts[index].time = hhmm;
    reminderDrafts.refresh();
  }

  void setReminderLabel(int index, String label) {
    reminderDrafts[index].label = label;
  }

  /// Requests OS notification permission with the user already looking at
  /// the Reminders step for context — never called implicitly on save
  /// (BRD §S10, docs/SRS.md FR-53).
  Future<void> requestNotificationPermission() async {
    final granted = await notificationService.requestPermission();
    notificationPermissionGranted.value = granted;
  }

  Future<void> submit();

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    targetController.dispose();
    unitController.dispose();
    super.onClose();
  }
}
