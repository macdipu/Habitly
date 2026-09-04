import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:customer/services/notifications/notification_settings_repository.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(() => SettingsController(
          Get.find<NotificationSettingsRepository>(),
          Get.find<HabitNotificationService>(),
          Get.find<ReminderReconciler>(),
          Get.find<AppSettingsRepository>(),
        ));
  }
}
