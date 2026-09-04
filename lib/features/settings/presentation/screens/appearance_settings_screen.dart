import 'package:customer/core/domain/models/time_format_enum.dart';
import 'package:customer/core/presentation/controllers/locale_controller.dart';
import 'package:customer/core/presentation/controllers/theme_controller.dart';
import 'package:customer/core/presentation/controllers/time_format_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// S21 — visual presentation controls, split out of the consolidated
/// Settings tab (docs/ARCHITECTURE.md §12).
class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();
    final timeFormatController = Get.find<TimeFormatController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: ListView(
        children: [
          Obx(() => RadioGroup<ThemeMode>(
                groupValue: themeController.themeMode,
                onChanged: (v) => v == null ? null : themeController.changeThemeMode(v),
                child: const Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      title: Text('System'),
                      value: ThemeMode.system,
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Light'),
                      value: ThemeMode.light,
                    ),
                    RadioListTile<ThemeMode>(
                      title: Text('Dark'),
                      value: ThemeMode.dark,
                    ),
                  ],
                ),
              )),
          const Divider(),
          Obx(() => SwitchListTile(
                title: const Text('Bangla interface'),
                subtitle: const Text('Switch app language between English and Bangla'),
                value: localeController.currentLangCode.value == 'bn',
                onChanged: (_) => localeController.toggleLocale(),
              )),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Time format'),
                const SizedBox(height: 8),
                Obx(() => SegmentedButton<AppTimeFormat>(
                      segments: const [
                        ButtonSegment(value: AppTimeFormat.system, label: Text('Auto')),
                        ButtonSegment(value: AppTimeFormat.h12, label: Text('12h')),
                        ButtonSegment(value: AppTimeFormat.h24, label: Text('24h')),
                      ],
                      selected: {timeFormatController.format.value},
                      onSelectionChanged: (s) => timeFormatController.setFormat(s.first),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
