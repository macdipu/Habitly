import 'dart:async';
import 'dart:developer';

import 'package:customer/app/flavours/app_config.dart';
import 'package:customer/core/data/cache/client/preference_cache.dart';
import 'package:customer/core/data/database/app_database.dart';
import 'package:customer/core/data/http/client/api_client.dart';
import 'package:customer/core/data/http/urls/api_urls.dart';
import 'package:customer/features/habits/data/repo_impl/habit_repository_impl.dart';
import 'package:customer/features/habits/domain/repo/habit_repository.dart';
import 'package:customer/services/push_notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await dotenv.load(fileName: '.env');

  // TODO: Enable Firebase for production:
  // await Firebase.initializeApp();
  // await NotificationService().init();

  _initialize();
  runApp(await builder());
}

void _initialize() {
  Get.lazyPut<AppConfig>(() => const AppConfig(), fenix: true);
  Get.lazyPut<PreferenceCache>(() => PreferenceCache(), fenix: true);
  Get.lazyPut<ApiUrl>(() => ApiUrl(), fenix: true);
  Get.lazyPut<ApiClient>(
    () => ApiClient(Get.find<AppConfig>(), Get.find<PreferenceCache>(), Get.find<ApiUrl>()),
    fenix: true,
  );
  Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);

  // Habitly local database — lazily opened on first query, never blocks
  // bootstrap (docs/ARCHITECTURE.md §2).
  Get.lazyPut<AppDatabase>(() => AppDatabase(), fenix: true);
  Get.lazyPut<HabitRepository>(() => HabitRepositoryImpl(Get.find<AppDatabase>()), fenix: true);
}
