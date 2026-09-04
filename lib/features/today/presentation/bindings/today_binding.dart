import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:get/get.dart';

import '../controller/today_controller.dart';

class TodayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodayController>(() => TodayController(Get.find<HabitRepository>()));
  }
}
