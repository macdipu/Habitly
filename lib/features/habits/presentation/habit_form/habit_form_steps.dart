import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/presentation/controllers/time_format_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'habit_form_controller.dart';

/// Step widgets shared by Create Habit (S07–S11) and Edit Habit (S13) —
/// both depend only on [HabitFormController], never the concrete
/// create/edit controller.
class BasicsStep extends StatelessWidget {
  final HabitFormController controller;

  const BasicsStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller.nameController,
          maxLength: 60,
          decoration: const InputDecoration(labelText: 'Habit name'),
        ),
        TextField(
          controller: controller.descriptionController,
          decoration:
              const InputDecoration(labelText: 'Description (optional)'),
        ),
        const SizedBox(height: 8),
        const Text('Type'),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              children: HabitType.values.map((t) {
                return ChoiceChip(
                  label: Text(_typeLabel(t)),
                  selected: controller.type.value == t,
                  onSelected: (_) => controller.type.value = t,
                );
              }).toList(),
            )),
        const SizedBox(height: 16),
        const Text('Color'),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              children: kHabitColorOptions.map((c) {
                final selected = controller.color.value == c;
                return GestureDetector(
                  onTap: () => controller.color.value = c,
                  child: CircleAvatar(
                    backgroundColor: Color(c),
                    radius: selected ? 18 : 14,
                    child: selected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                );
              }).toList(),
            )),
      ],
    );
  }

  String _typeLabel(HabitType type) => switch (type) {
        HabitType.binary => 'Yes/No',
        HabitType.count => 'Count',
        HabitType.duration => 'Duration',
        HabitType.avoid => 'Avoid/Quit',
      };
}

class ScheduleStep extends StatelessWidget {
  final HabitFormController controller;

  const ScheduleStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Wrap(
              spacing: 8,
              children: ScheduleMode.values.map((mode) {
                return ChoiceChip(
                  label: Text(_modeLabel(mode)),
                  selected: controller.scheduleMode.value == mode,
                  onSelected: (_) => controller.scheduleMode.value = mode,
                );
              }).toList(),
            )),
        const SizedBox(height: 16),
        Obx(() {
          switch (controller.scheduleMode.value) {
            case ScheduleMode.weekdays:
              return Wrap(
                spacing: 8,
                children: List.generate(7, (i) {
                  final iso = i + 1;
                  final selected = controller.weekdays.contains(iso);
                  return FilterChip(
                    label: Text(const [
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                      'Sun'
                    ][i]),
                    selected: selected,
                    onSelected: (value) {
                      if (value) {
                        controller.weekdays.add(iso);
                      } else {
                        controller.weekdays.remove(iso);
                      }
                    },
                  );
                }),
              );
            case ScheduleMode.timesPerWeek:
              return Row(
                children: [
                  const Text('Times per week:'),
                  Slider(
                    value: controller.weeklyTarget.value.toDouble(),
                    min: 1,
                    max: 7,
                    divisions: 6,
                    label: '${controller.weeklyTarget.value}',
                    onChanged: (v) => controller.weeklyTarget.value = v.round(),
                  ),
                ],
              );
            case ScheduleMode.interval:
              return Row(
                children: [
                  const Text('Every'),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 60,
                    child: TextFormField(
                      initialValue: '${controller.intervalDays.value}',
                      keyboardType: TextInputType.number,
                      onChanged: (v) =>
                          controller.intervalDays.value = int.tryParse(v) ?? 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('days'),
                ],
              );
            case ScheduleMode.daily:
              return const SizedBox.shrink();
          }
        }),
        const SizedBox(height: 16),
        Obx(() => Text(controller.schedulePreview,
            style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }

  String _modeLabel(ScheduleMode mode) => switch (mode) {
        ScheduleMode.daily => 'Every day',
        ScheduleMode.weekdays => 'Specific days',
        ScheduleMode.timesPerWeek => 'X times/week',
        ScheduleMode.interval => 'Interval',
      };
}

class GoalStep extends StatelessWidget {
  final HabitFormController controller;

  const GoalStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDuration = controller.type.value == HabitType.duration;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.targetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: controller.type.value == HabitType.avoid
                  ? 'Maximum allowed (0 = none)'
                  : 'Target amount',
            ),
          ),
          if (!isDuration) ...[
            const SizedBox(height: 8),
            TextField(
              controller: controller.unitController,
              decoration:
                  const InputDecoration(labelText: 'Unit (e.g. glasses)'),
            ),
          ],
        ],
      );
    });
  }
}

class RemindersStep extends StatelessWidget {
  final HabitFormController controller;

  const RemindersStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Remind me'),
              value: controller.remindersEnabled.value,
              onChanged: controller.toggleReminders,
            ),
            if (controller.remindersEnabled.value) ...[
              if (controller.notificationPermissionGranted.value == false)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Notifications are off for this app. You can still save this habit — '
                    'enable notifications later from Settings to receive reminders.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                )
              else if (controller.notificationPermissionGranted.value == null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton.icon(
                    onPressed: controller.requestNotificationPermission,
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: const Text('Allow notifications'),
                  ),
                ),
              ...controller.reminderDrafts.asMap().entries.map((entry) {
                final index = entry.key;
                final draft = entry.value;
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.alarm),
                    title: Text(Get.find<TimeFormatController>().formatTime(
                      draft.time,
                      use24hFallback:
                          MediaQuery.of(context).alwaysUse24HourFormat,
                    )),
                    subtitle: TextFormField(
                      key: ValueKey('reminder-label-$index'),
                      initialValue: draft.label,
                      decoration:
                          const InputDecoration(hintText: 'Label (optional)'),
                      onChanged: (v) => controller.setReminderLabel(index, v),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          tooltip: 'Change time',
                          onPressed: () async {
                            final parts = draft.time.split(':');
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                hour: int.parse(parts[0]),
                                minute: int.parse(parts[1]),
                              ),
                            );
                            if (picked != null) {
                              final hh = picked.hour.toString().padLeft(2, '0');
                              final mm =
                                  picked.minute.toString().padLeft(2, '0');
                              controller.setReminderTime(index, '$hh:$mm');
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          tooltip: 'Remove reminder',
                          onPressed: controller.reminderDrafts.length > 1
                              ? () => controller.removeReminder(index)
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                onPressed: controller.addReminder,
                icon: const Icon(Icons.add),
                label: const Text('Add another reminder'),
              ),
            ],
          ],
        ));
  }
}
