import 'package:customer/core/domain/habit/quiet_hours.dart';
import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/core/presentation/controllers/base_controller.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:customer/services/notifications/notification_settings_repository.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' show openAppSettings;

/// S20/S22 — global reminder + calendar controls. Any notification change
/// here reconciles every active habit's schedule immediately (BRD §22
/// "Reconcile scheduled notifications when global setting changes").
class SettingsController extends BaseController {
  final NotificationSettingsRepository _notificationSettings;
  final HabitNotificationService _notificationService;
  final ReminderReconciler _reminderReconciler;
  final AppSettingsRepository _appSettings;

  SettingsController(
    this._notificationSettings,
    this._notificationService,
    this._reminderReconciler,
    this._appSettings,
  );

  final RxBool masterEnabled = true.obs;
  final Rx<QuietHours> quietHours = QuietHours.disabled.obs;
  final RxBool shiftToQuietHoursEnd = false.obs;

  /// ISO weekday: 1 = Monday, 7 = Sunday. Calendar picks this up on its
  /// next load (e.g. next app launch, or navigating months) rather than
  /// live — it isn't re-fetched while already mounted in the shell's
  /// `IndexedStack`.
  final RxInt startOfWeek = 1.obs;

  /// null = not yet checked this session.
  final Rx<bool?> permissionGranted = Rx<bool?>(null);

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    masterEnabled.value = await _notificationSettings.getMasterEnabled();
    quietHours.value = await _notificationSettings.getQuietHours();
    shiftToQuietHoursEnd.value = await _notificationSettings.getShiftToQuietHoursEnd();
    permissionGranted.value = await _notificationService.hasPermission();
    startOfWeek.value = await _appSettings.getStartOfWeek();
  }

  Future<void> setStartOfWeek(int isoWeekday) async {
    startOfWeek.value = isoWeekday;
    await _appSettings.setStartOfWeek(isoWeekday);
  }

  Future<void> setMasterEnabled(bool value) async {
    masterEnabled.value = value;
    await _notificationSettings.setMasterEnabled(value);
    await _reminderReconciler.reconcileAll();
  }

  Future<void> setQuietHoursEnabled(bool value) => _updateQuietHours(enabled: value);

  Future<void> setQuietHoursStart(String hhmm) => _updateQuietHours(start: hhmm);

  Future<void> setQuietHoursEnd(String hhmm) => _updateQuietHours(end: hhmm);

  Future<void> _updateQuietHours({bool? enabled, String? start, String? end}) async {
    final current = quietHours.value;
    quietHours.value = QuietHours(
      enabled: enabled ?? current.enabled,
      start: start ?? current.start,
      end: end ?? current.end,
    );
    await _notificationSettings.setQuietHours(quietHours.value);
    await _reminderReconciler.reconcileAll();
  }

  Future<void> setShiftToQuietHoursEnd(bool value) async {
    shiftToQuietHoursEnd.value = value;
    await _notificationSettings.setShiftToQuietHoursEnd(value);
    await _reminderReconciler.reconcileAll();
  }

  Future<void> requestPermission() async {
    final granted = await _notificationService.requestPermission();
    permissionGranted.value = granted;
  }

  Future<void> openSystemSettings() => openAppSettings();
}
