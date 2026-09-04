import 'package:customer/res/strings/string_enum.dart';
import 'package:customer/services/navigation/navigation_history_observer.dart';
import 'package:customer/services/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../core/presentation/controllers/locale_controller.dart';
import '../../core/presentation/controllers/theme_controller.dart';
import '../../core/presentation/theme/app_theme.dart';
import '../../res/routes/app_pages.dart';
import '../../res/strings/app_translations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Registered as permanent singletons in app_flavour.dart's bootstrap, not
  // put here — a widget State must never Get.put its own controllers
  // (CLAUDE.md DI rule).
  final ThemeController _themeController = Get.find();
  final LocaleController _localeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale(_localeController.currentLangCode.value),
      fallbackLocale: const Locale('en'),
      supportedLocales: AppTranslations.supportedLocales,
      translations: AppTranslations(),
      title: TextEnum.appName.tr,

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeController.themeMode,

      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      navigatorKey: NavigationService.navigatorKey,
      navigatorObservers: [NavigationHistoryObserver()],

      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
