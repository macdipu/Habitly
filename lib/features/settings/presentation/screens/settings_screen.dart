import 'package:customer/core/presentation/controllers/locale_controller.dart';
import 'package:customer/core/presentation/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// S20/S21/S25 condensed into one screen for this pass — Appearance is
/// fully wired (theme + locale already persist via AppSettingsRepository);
/// Reminders/Data & Backup land once notifications (Phase 2) and
/// backup/restore (Phase 4) are built (docs/ARCHITECTURE.md §9).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionLabel('Appearance'),
          Obx(() => Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('System'),
                    value: ThemeMode.system,
                    groupValue: themeController.themeMode,
                    onChanged: (v) => v == null ? null : themeController.changeThemeMode(v),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: themeController.themeMode,
                    onChanged: (v) => v == null ? null : themeController.changeThemeMode(v),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: themeController.themeMode,
                    onChanged: (v) => v == null ? null : themeController.changeThemeMode(v),
                  ),
                ],
              )),
          Obx(() => SwitchListTile(
                title: const Text('Bangla interface'),
                subtitle: const Text('Switch app language between English and Bangla'),
                value: localeController.currentLangCode.value == 'bn',
                onChanged: (_) => localeController.toggleLocale(),
              )),
          const Divider(),
          const _SectionLabel('Reminders & notifications'),
          const ListTile(
            leading: Icon(Icons.notifications_outlined),
            title: Text('Coming soon'),
            subtitle: Text('Local reminders land with Phase 2'),
            enabled: false,
          ),
          const Divider(),
          const _SectionLabel('Data & backup'),
          const ListTile(
            leading: Icon(Icons.backup_outlined),
            title: Text('Coming soon'),
            subtitle: Text('Backup, restore, and CSV/JSON export land with Phase 4'),
            enabled: false,
          ),
          const Divider(),
          const _SectionLabel('Privacy & about'),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('Your data stays on this device'),
            subtitle: Text(
              'Habitly has no account, no server, and no analytics. All habits, '
              'check-ins, and settings are stored locally in this app\'s database.',
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final info = snapshot.data;
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Version'),
                subtitle: Text(info == null ? '—' : '${info.version} (${info.buildNumber})'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
