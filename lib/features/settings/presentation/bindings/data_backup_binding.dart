import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/services/backup/backup_service.dart';
import 'package:customer/services/backup/csv_export_service.dart';
import 'package:customer/services/backup/restore_service.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:get/get.dart';

import '../controller/data_backup_controller.dart';

class DataBackupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataBackupController>(() => DataBackupController(
          Get.find<BackupService>(),
          Get.find<RestoreService>(),
          Get.find<CsvExportService>(),
          Get.find<HabitRepository>(),
          Get.find<HabitNotificationService>(),
        ));
  }
}
