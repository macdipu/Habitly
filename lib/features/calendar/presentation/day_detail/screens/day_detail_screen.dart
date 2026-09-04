import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/features/habits/domain/entity/today_habit_item.dart';
import 'package:customer/features/today/presentation/widgets/quick_check_in_sheet.dart';
import 'package:customer/features/today/presentation/widgets/today_habit_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/day_detail_controller.dart';

class DayDetailScreen extends StatelessWidget {
  const DayDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DayDetailController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back(result: controller.changed.value);
      },
      child: Scaffold(
        appBar: AppBar(title: Text(DateFormat.yMMMEd().format(controller.date.toDateTime()))),
        body: Obx(() {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.items.isEmpty) {
            return const Center(child: Text('No habits scheduled on this day'));
          }
          return ListView(
            children: controller.items
                .map((item) => TodayHabitCard(
                      item: item,
                      onTap: () {},
                      onStatusTap: () => _handleStatusTap(context, controller, item),
                      onUndo: () => controller.undo(item),
                      onSkip: () => controller.skip(item),
                    ))
                .toList(),
          );
        }),
      ),
    );
  }

  Future<void> _handleStatusTap(
    BuildContext context,
    DayDetailController controller,
    TodayHabitItem item,
  ) async {
    if (item.habit.type == HabitType.binary || item.habit.type == HabitType.avoid) {
      await controller.checkIn(item);
      return;
    }
    final value = await QuickCheckInSheet.show(context, item.habit);
    if (value != null) {
      await controller.checkIn(item, value: value);
    }
  }
}
