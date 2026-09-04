import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// Available icon keys — kept small deliberately; extend alongside
/// [habitIconFor] and the per-key switches in `TodayHabitCard`,
/// `QuickCheckInSheet`, and `ManageHabitsScreen`.
const kHabitIconOptions = [
  'check',
  'water_drop',
  'book',
  'fitness',
  'sleep',
  'smoking'
];

/// Maps an icon key to its glyph for the Basics-step picker. Kept separate
/// from the per-widget `_iconFor` switches (which style icons differently
/// per context) so the picker doesn't depend on any one of them.
IconData habitIconFor(String icon) => switch (icon) {
      'water_drop' => Icons.water_drop_outlined,
      'book' => Icons.menu_book_outlined,
      'fitness' => Icons.fitness_center_outlined,
      'sleep' => Icons.bedtime_outlined,
      'smoking' => Icons.smoke_free_outlined,
      _ => Icons.check_circle_outline,
    };

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

  /// Mirrors [nameController.text] as an observable so `canContinueBasics`
  /// can be watched by a scoped `Obx` (just the Next/Save button) without
  /// forcing whatever wraps it to rebuild on every keystroke — rebuilding
  /// an ancestor of a focused, actively-typed-in `TextField` synchronously
  /// from within its own `onChanged` corrupts the element tree (a real
  /// crash previously here: `'_dependents.isEmpty': is not true` on the
  /// next navigation, from a `currentStep.refresh()` hack in `BasicsStep`
  /// that rebuilt the whole Stepper — including the focused name field —
  /// on every keystroke). Never write to this directly; it's kept in sync
  /// by [onInit]'s listener.
  final nameText = ''.obs;

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

  bool get canContinueBasics => nameText.value.trim().isNotEmpty;

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
        final names =
            (weekdays.toList()..sort()).map(_weekdayShortName).join(', ');
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
  void onInit() {
    super.onInit();
    nameController.addListener(_syncNameText);
  }

  void _syncNameText() => nameText.value = nameController.text;

  @override
  void onClose() {
    nameController.removeListener(_syncNameText);
    nameController.dispose();
    descriptionController.dispose();
    targetController.dispose();
    unitController.dispose();
    super.onClose();
  }
}
