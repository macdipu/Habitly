import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';

import '../edit_habit/controller/edit_habit_controller.dart';

class EditHabitBinding extends Bindings {
  @override
  void dependencies() {
    final habitId = Get.arguments as String;
    Get.lazyPut<EditHabitController>(() => EditHabitController(
          Get.find<HabitRepository>(),
          Get.find<HabitNotificationService>(),
          Get.find<ReminderReconciler>(),
          habitId,
        ));
  }
}
