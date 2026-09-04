import 'package:customer/core/data/database/app_database.dart';
import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:get/get.dart';

import '../splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(Get.find<AppDatabase>(), Get.find<AppSettingsRepository>()),
    );
  }
}
