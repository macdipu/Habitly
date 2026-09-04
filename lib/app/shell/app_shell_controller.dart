import 'package:customer/features/calendar/presentation/controller/calendar_controller.dart';
import 'package:customer/features/insights/presentation/controller/insights_controller.dart';
import 'package:customer/features/today/presentation/controller/today_controller.dart';
import 'package:get/get.dart';

class AppShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    _refreshTab(index);
  }

  /// Tabs live in an `IndexedStack` and stay mounted for instant switching,
  /// so each controller's `onInit` only ever runs once at app launch — a
  /// habit created/checked-in/archived from one tab would otherwise never
  /// show up on another (e.g. a habit added on Today wouldn't appear in
  /// Calendar's day status or Insights' ranking until the app restarted).
  /// Reload the destination tab's data on every visit instead.
  void _refreshTab(int index) {
    switch (index) {
      case 0:
        Get.find<TodayController>().loadToday();
      case 1:
        Get.find<CalendarController>().load();
      case 2:
        Get.find<InsightsController>().load();
    }
  }
}
