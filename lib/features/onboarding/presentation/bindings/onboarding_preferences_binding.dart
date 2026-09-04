import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:get/get.dart';

import '../preferences/controller/onboarding_preferences_controller.dart';

class OnboardingPreferencesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingPreferencesController>(() => OnboardingPreferencesController(
          Get.find<AppSettingsRepository>(),
          Get.find<HabitNotificationService>(),
        ));
  }
}
