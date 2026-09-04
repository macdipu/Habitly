import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:get/get.dart';

import '../day_detail/controller/day_detail_controller.dart';

class DayDetailBinding extends Bindings {
  @override
  void dependencies() {
    final date = Get.arguments as LocalDate;
    Get.lazyPut<DayDetailController>(() => DayDetailController(Get.find<HabitRepository>(), date));
  }
}
