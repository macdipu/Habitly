import 'dart:async';

import 'package:customer/core/data/database/app_database.dart';
import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:get/get.dart';

/// S01 — bootstraps local storage, detects first launch, and routes to
/// Onboarding or Today. Never silently resets the database on failure
/// (BRD §S01, docs/SRS.md FR-02): a DB init error surfaces as a recoverable
/// screen with Retry.
class SplashController extends GetxController {
  final AppDatabase _database;
  final AppSettingsRepository _settingsRepository;

  SplashController(this._database, this._settingsRepository);

  /// Only true after ~300ms of still bootstrapping (BRD §S01: "optional
  /// subtle loading indicator only if bootstrap exceeds ~300 ms").
  final RxBool showLoadingIndicator = false.obs;

  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    hasError.value = false;
    showLoadingIndicator.value = false;

    final loadingTimer = Timer(const Duration(milliseconds: 300), () {
      showLoadingIndicator.value = true;
    });

    try {
      await _database.ensureReady();
      final onboardingComplete = await _settingsRepository.isOnboardingComplete();
      loadingTimer.cancel();

      if (onboardingComplete) {
        unawaited(Get.offAllNamed(AppRoutes.appShell));
        // A reminder tap can cold-start the app from fully terminated —
        // route into that habit only after the shell route is settled, so
        // this deep link is never stomped by the shell's own navigation
        // (BRD §9).
        final launchHabitId =
            await Get.find<HabitNotificationService>().getLaunchHabitId();
        if (launchHabitId != null) {
          unawaited(Get.toNamed(AppRoutes.habitDetail, arguments: launchHabitId));
        }
      } else {
        unawaited(Get.offAllNamed(AppRoutes.onboardingWelcome));
      }
    } catch (e) {
      loadingTimer.cancel();
      hasError.value = true;
      errorMessage.value = e.toString();
    }
  }

  void retry() => _bootstrap();
}
