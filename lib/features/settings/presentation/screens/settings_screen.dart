import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

/// S20 — Settings home: rows navigating into the S21/S22/S23/S25
/// sub-screens (docs/ARCHITECTURE.md §12), plus a Habits row for the
/// Manage Habits screen this session also added.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SettingsRow(
            icon: Icons.palette_outlined,
            title: 'Appearance',
            subtitle: 'Theme, language, time format',
            onTap: () => Get.toNamed(AppRoutes.appearanceSettings),
          ),
          _SettingsRow(
            icon: Icons.calendar_month_outlined,
            title: 'Calendar',
            subtitle: 'Start of week',
            onTap: () => Get.toNamed(AppRoutes.calendarSettings),
          ),
          const Divider(),
          _SettingsRow(
            icon: Icons.checklist_outlined,
            title: 'Manage habits',
            subtitle: 'Search, and view or restore archived habits',
            onTap: () => Get.toNamed(AppRoutes.manageHabits),
          ),
          const Divider(),
          Obx(() {
            final granted = settingsController.permissionGranted.value;
            final quietHours = settingsController.quietHours.value;
            final subtitle = [
              granted == false ? 'Off' : 'On',
              if (quietHours.enabled) 'Quiet hours ${quietHours.start}–${quietHours.end}',
            ].join(' · ');
            return _SettingsRow(
              icon: Icons.notifications_outlined,
              title: 'Reminders & notifications',
              subtitle: subtitle,
              onTap: () => Get.toNamed(AppRoutes.notificationSettings),
            );
          }),
          _SettingsRow(
            icon: Icons.backup_outlined,
            title: 'Data & backup',
            subtitle: 'Backup, restore, export, delete all data',
            onTap: () => Get.toNamed(AppRoutes.dataBackupSettings),
          ),
          const Divider(),
          _SettingsRow(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy & about',
            subtitle: 'How your data is stored, app version',
            onTap: () => Get.toNamed(AppRoutes.privacyAbout),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
