import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:get/get.dart';

import '../controller/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarController>(
      () => CalendarController(Get.find<HabitRepository>(), Get.find<AppSettingsRepository>()),
    );
  }
}
