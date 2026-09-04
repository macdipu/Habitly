import 'package:customer/core/domain/models/time_format_enum.dart';
import 'package:customer/core/presentation/controllers/theme_controller.dart';
import 'package:customer/core/presentation/controllers/time_format_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/onboarding_preferences_controller.dart';

/// S03 — every field has a default; Continue is always available (BRD
/// §S03 acceptance note).
class OnboardingPreferencesScreen extends StatelessWidget {
  const OnboardingPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingPreferencesController>();
    final themeController = Get.find<ThemeController>();
    final timeFormatController = Get.find<TimeFormatController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Set up Habitly'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Start of week', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() => SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 1, label: Text('Monday')),
                  ButtonSegment(value: 7, label: Text('Sunday')),
                ],
                selected: {controller.startOfWeek.value},
                onSelectionChanged: (s) => controller.setStartOfWeek(s.first),
              )),
          const SizedBox(height: 24),
          Text('Time format', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() => SegmentedButton<AppTimeFormat>(
                segments: const [
                  ButtonSegment(value: AppTimeFormat.system, label: Text('System')),
                  ButtonSegment(value: AppTimeFormat.h12, label: Text('12h')),
                  ButtonSegment(value: AppTimeFormat.h24, label: Text('24h')),
                ],
                selected: {timeFormatController.format.value},
                onSelectionChanged: (s) => timeFormatController.setFormat(s.first),
              )),
          const SizedBox(height: 24),
          Text('Theme', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Obx(() => SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {themeController.themeMode},
                onSelectionChanged: (s) => themeController.changeThemeMode(s.first),
              )),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reminders', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'Habitly can remind you when a habit is due. You can turn this on '
                    'now, or later from Settings — it\'s never required.',
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final granted = controller.notificationPermissionGranted.value;
                    if (granted == true) {
                      return const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Notifications enabled'),
                        ],
                      );
                    }
                    return OutlinedButton.icon(
                      onPressed: controller.requestNotificationPermission,
                      icon: const Icon(Icons.notifications_active_outlined),
                      label: const Text('Enable reminders'),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Obx(() => SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controller.isSaving.value ? null : controller.continueToApp,
                  child: const Text('Continue'),
                ),
              )),
        ],
      ),
    );
  }
}
