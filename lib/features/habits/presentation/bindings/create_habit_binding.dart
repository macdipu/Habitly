import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:get/get.dart';

import '../create_habit/controller/create_habit_controller.dart';

class CreateHabitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateHabitController>(() => CreateHabitController(Get.find<HabitRepository>()));
  }
}
