import 'dart:async';
import 'dart:developer';

import 'package:customer/app/flavours/app_config.dart';
import 'package:customer/core/data/cache/client/preference_cache.dart';
import 'package:customer/core/data/database/app_database.dart';
import 'package:customer/core/data/http/client/api_client.dart';
import 'package:customer/core/data/http/urls/api_urls.dart';
import 'package:customer/core/data/repositories/app_settings_repository_impl.dart';
import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import 'package:customer/core/presentation/controllers/locale_controller.dart';
import 'package:customer/core/presentation/controllers/theme_controller.dart';
import 'package:customer/core/presentation/controllers/time_format_controller.dart';
import 'package:customer/features/habits/data/repo_impl/habit_repository_impl.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/services/backup/backup_service.dart';
import 'package:customer/services/backup/csv_export_service.dart';
import 'package:customer/services/backup/restore_service.dart';
import 'package:customer/services/notifications/habit_notification_service.dart';
import 'package:customer/services/notifications/notification_settings_repository.dart';
import 'package:customer/services/notifications/reminder_reconciler.dart';
import 'package:customer/services/push_notification/notification_service.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await dotenv.load();

  // TODO: Enable Firebase for production:
  // await Firebase.initializeApp();
  // await NotificationService().init();

  _initialize();
  runApp(await builder());

  // Best-effort, fire-and-forget: reconcile reminder schedules on cold
  // start (BRD §9). Never awaited before runApp — a slow/failing plugin
  // init must not delay first paint (BRD §11.3).
  unawaited(_reconcileRemindersOnStartup());
}

// These are true app-lifetime singletons (a database connection chief
// among them), registered once at bootstrap and never torn down. `Get.put`
// with `permanent: true` is the correct GetX idiom here — NOT
// `Get.lazyPut(..., fenix: true)`, which GetX's default smart management
// disposes as soon as no *route* is currently referencing it (e.g. when
// onboarding finishes and its routes are cleared via `Get.offAllNamed`),
// then silently recreates on next use. For most of these that's merely
// wasteful; for AppDatabase it's a real bug: a second `AppDatabase()`
// opens a second live connection to the same SQLite file, and Drift
// itself warns at runtime that this risks race conditions/corruption —
// exactly what happened here before this fix (caught by manually running
// the app through onboarding into the shell, not by static analysis or
// unit tests).
void _initialize() {
  Get.put<AppConfig>(const AppConfig(), permanent: true);
  Get.put<PreferenceCache>(PreferenceCache(), permanent: true);
  Get.put<ApiUrl>(ApiUrl(), permanent: true);
  Get.put<ApiClient>(
    ApiClient(Get.find<AppConfig>(), Get.find<PreferenceCache>(), Get.find<ApiUrl>()),
    permanent: true,
  );
  Get.put<NotificationService>(NotificationService(), permanent: true);
  Get.put<AppSettingsRepository>(AppSettingsRepositoryImpl(), permanent: true);

  // Habitly local database — lazily opened on first query (LazyDatabase),
  // but the AppDatabase *instance itself* must be a single permanent
  // singleton for the app's whole lifetime.
  Get.put<AppDatabase>(AppDatabase(), permanent: true);
  Get.put<HabitRepository>(HabitRepositoryImpl(Get.find<AppDatabase>()), permanent: true);

  Get.put<HabitNotificationService>(HabitNotificationService(), permanent: true);
  Get.put<NotificationSettingsRepository>(NotificationSettingsRepository(), permanent: true);
  Get.put<ReminderReconciler>(
    ReminderReconciler(
      Get.find<HabitRepository>(),
      Get.find<HabitNotificationService>(),
      Get.find<NotificationSettingsRepository>(),
    ),
    permanent: true,
  );

  Get.put<BackupService>(BackupService(Get.find<HabitRepository>()), permanent: true);
  Get.put<RestoreService>(
    RestoreService(Get.find<HabitRepository>(), Get.find<BackupService>()),
    permanent: true,
  );
  Get.put<CsvExportService>(CsvExportService(Get.find<HabitRepository>()), permanent: true);

  // App-lifetime UI controllers MyApp's root widget reads directly
  // (theme/locale/time format). Registered here, not via `Get.put` inside
  // `_MyAppState`, so a widget rebuild can never re-register them (CLAUDE.md
  // DI rule: never `Get.put(Controller())` inside a widget State class).
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<LocaleController>(LocaleController(), permanent: true);
  Get.put<TimeFormatController>(TimeFormatController(), permanent: true);
}

Future<void> _reconcileRemindersOnStartup() async {
  try {
    final notificationService = Get.find<HabitNotificationService>();
    await notificationService.init();
    // Deep-link into the habit when a reminder is tapped while the app is
    // running or resumed from background (BRD §9). Cold-start (terminated)
    // taps are handled separately by SplashController via
    // `getLaunchHabitId()`, since routing isn't up yet at this point.
    notificationService.onNotificationTapped =
        (habitId) => Get.toNamed(AppRoutes.habitDetail, arguments: habitId);
    await Get.find<ReminderReconciler>().reconcileAll();
  } catch (e) {
    log('Reminder reconciliation on startup failed: $e');
  }
}
