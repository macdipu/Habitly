import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:get/get.dart';

import '../habit_detail/controller/habit_detail_controller.dart';

class HabitDetailBinding extends Bindings {
  @override
  void dependencies() {
    final habitId = Get.arguments as String;
    Get.lazyPut<HabitDetailController>(
      () => HabitDetailController(Get.find<HabitRepository>(), habitId),
    );
  }
}
