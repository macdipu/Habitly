import 'package:customer/features/today/presentation/bindings/today_binding.dart';
import 'package:get/get.dart';
import 'app_shell_controller.dart';

class AppShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppShellController>(() => AppShellController());
    // Today/Calendar/Insights/Settings are persistent tabs, not routed
    // pages, so their controllers are wired here rather than per-GetPage.
    TodayBinding().dependencies();
  }
}
