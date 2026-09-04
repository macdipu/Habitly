import 'package:customer/core/domain/models/time_format_enum.dart';
import 'package:customer/core/presentation/controllers/locale_controller.dart';
import 'package:customer/core/presentation/controllers/theme_controller.dart';
import 'package:customer/core/presentation/controllers/time_format_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../controller/settings_controller.dart';

/// S20/S21/S22/S25 condensed into one screen for this pass — Appearance and
/// Reminders & Notifications are fully wired; Data & Backup lands once
/// backup/restore (Phase 4) is built (docs/ARCHITECTURE.md §9).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final localeController = Get.find<LocaleController>();
    final timeFormatController = Get.find<TimeFormatController>();
    final settingsController = Get.find<SettingsController>();

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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                const Text('Time format'),
                const Spacer(),
                Obx(() => SegmentedButton<AppTimeFormat>(
                      segments: const [
                        ButtonSegment(value: AppTimeFormat.system, label: Text('System')),
                        ButtonSegment(value: AppTimeFormat.h12, label: Text('12h')),
                        ButtonSegment(value: AppTimeFormat.h24, label: Text('24h')),
                      ],
                      selected: {timeFormatController.format.value},
                      onSelectionChanged: (s) => timeFormatController.setFormat(s.first),
                    )),
              ],
            ),
          ),
          const Divider(),
          const _SectionLabel('Calendar'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                const Text('Start of week'),
                const Spacer(),
                Obx(() => SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 1, label: Text('Mon')),
                        ButtonSegment(value: 7, label: Text('Sun')),
                      ],
                      selected: {settingsController.startOfWeek.value},
                      onSelectionChanged: (s) => settingsController.setStartOfWeek(s.first),
                    )),
              ],
            ),
          ),
          const Divider(),
          const _SectionLabel('Reminders & notifications'),
          Obx(() {
            final granted = settingsController.permissionGranted.value;
            return ListTile(
              leading: Icon(granted == false ? Icons.notifications_off_outlined : Icons.notifications_outlined),
              title: Text(granted == false ? 'Notifications are off' : 'Notifications are on'),
              subtitle: granted == false
                  ? const Text('Enable them to receive habit reminders')
                  : null,
              trailing: granted == false
                  ? Wrap(
                      spacing: 4,
                      children: [
                        TextButton(
                          onPressed: settingsController.requestPermission,
                          child: const Text('Enable'),
                        ),
                        TextButton(
                          onPressed: settingsController.openSystemSettings,
                          child: const Text('Settings'),
                        ),
                      ],
                    )
                  : null,
            );
          }),
          Obx(() => SwitchListTile(
                title: const Text('Reminders enabled'),
                subtitle: const Text('Master switch for all habit reminders'),
                value: settingsController.masterEnabled.value,
                onChanged: settingsController.setMasterEnabled,
              )),
          Obx(() => SwitchListTile(
                title: const Text('Quiet hours'),
                subtitle: Text(
                  settingsController.quietHours.value.enabled
                      ? '${settingsController.quietHours.value.start} – ${settingsController.quietHours.value.end}: reminders are suppressed'
                      : 'No suppressed window',
                ),
                value: settingsController.quietHours.value.enabled,
                onChanged: settingsController.setQuietHoursEnabled,
              )),
          Obx(() {
            if (!settingsController.quietHours.value.enabled) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _TimeField(
                      label: 'Starts',
                      value: settingsController.quietHours.value.start,
                      onChanged: settingsController.setQuietHoursStart,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TimeField(
                      label: 'Ends',
                      value: settingsController.quietHours.value.end,
                      onChanged: settingsController.setQuietHoursEnd,
                    ),
                  ),
                ],
              ),
            );
          }),
          Obx(() {
            if (!settingsController.quietHours.value.enabled) return const SizedBox.shrink();
            return SwitchListTile(
              title: const Text('Show reminder when quiet hours end'),
              subtitle: const Text('Otherwise, a reminder due in quiet hours is skipped entirely'),
              value: settingsController.shiftToQuietHoursEnd.value,
              onChanged: settingsController.setShiftToQuietHoursEnd,
            );
          }),
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

class _TimeField extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _TimeField({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        final parts = value.split(':');
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
        );
        if (picked != null) {
          final hh = picked.hour.toString().padLeft(2, '0');
          final mm = picked.minute.toString().padLeft(2, '0');
          onChanged('$hh:$mm');
        }
      },
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Obx(() => Text(Get.find<TimeFormatController>().formatTime(
                value,
                use24hFallback: MediaQuery.of(context).alwaysUse24HourFormat,
              ))),
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
