import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:get/get.dart';

import '../manage_habits/controller/manage_habits_controller.dart';

class ManageHabitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageHabitsController>(
      () => ManageHabitsController(Get.find<HabitRepository>(), Get.find<ReminderReconciler>()),
    );
  }
}
