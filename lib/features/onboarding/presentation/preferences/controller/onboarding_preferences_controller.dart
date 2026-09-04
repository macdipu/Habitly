import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:get/get.dart';

/// S03 — global defaults, none blocking. Theme and time-format changes
/// already persist live via [ThemeController]/[TimeFormatController]; this
/// controller only owns start-of-week (new) and the "Continue" action that
/// marks onboarding complete (BRD §S01 first-launch check).
class OnboardingPreferencesController extends GetxController {
  final AppSettingsRepository _settingsRepository;
  final HabitNotificationService _notificationService;

  OnboardingPreferencesController(this._settingsRepository, this._notificationService);

  /// ISO weekday: 1 = Monday, 7 = Sunday.
  final RxInt startOfWeek = 1.obs;

  /// null = not yet requested this session.
  final Rx<bool?> notificationPermissionGranted = Rx<bool?>(null);

  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    startOfWeek.value = await _settingsRepository.getStartOfWeek();
  }

  void setStartOfWeek(int isoWeekday) => startOfWeek.value = isoWeekday;

  Future<void> requestNotificationPermission() async {
    final granted = await _notificationService.requestPermission();
    notificationPermissionGranted.value = granted;
  }

  Future<void> continueToApp() async {
    isSaving.value = true;
    await _settingsRepository.setStartOfWeek(startOfWeek.value);
    await _settingsRepository.setOnboardingComplete(true);
    isSaving.value = false;
    Get.offAllNamed(AppRoutes.appShell);
  }
}
