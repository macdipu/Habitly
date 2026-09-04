import 'package:customer/core/presentation/controllers/time_format_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/settings_controller.dart';

/// S22 — global reminder controls, split out of the consolidated Settings
/// tab (docs/ARCHITECTURE.md §12).
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Reminders & notifications')),
      body: ListView(
        children: [
          Obx(() {
            final granted = settingsController.permissionGranted.value;
            return ListTile(
              leading: Icon(
                  granted == false ? Icons.notifications_off_outlined : Icons.notifications_outlined),
              title: Text(granted == false ? 'Notifications are off' : 'Notifications are on'),
              subtitle:
                  granted == false ? const Text('Enable them to receive habit reminders') : null,
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
