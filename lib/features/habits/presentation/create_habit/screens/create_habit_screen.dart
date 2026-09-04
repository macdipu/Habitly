import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/create_habit_controller.dart';

/// Condensed S07–S11 flow: Basics → Schedule → Goal (skipped for binary
/// habits) → Review. Reminders (S10) land in Phase 2 alongside real
/// notification scheduling (docs/ARCHITECTURE.md §9).
class CreateHabitScreen extends StatelessWidget {
  const CreateHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateHabitController>();

    return Scaffold(
      appBar: AppBar(title: const Text('New habit')),
      body: Obx(() {
        final steps = _stepsFor(controller);
        return Stepper(
          currentStep: controller.currentStep.value,
          onStepContinue: () {
            final isLast = controller.currentStep.value == steps.length - 1;
            if (isLast) {
              controller.submit();
            } else {
              controller.nextStep();
            }
          },
          onStepCancel: controller.previousStep,
          controlsBuilder: (context, details) {
            final isLast = controller.currentStep.value == steps.length - 1;
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  FilledButton(
                    onPressed: _canContinue(controller) ? details.onStepContinue : null,
                    child: Text(isLast ? 'Create habit' : 'Next'),
                  ),
                  if (controller.currentStep.value > 0) ...[
                    const SizedBox(width: 12),
                    TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
                  ],
                ],
              ),
            );
          },
          steps: steps,
        );
      }),
    );
  }

  bool _canContinue(CreateHabitController controller) {
    switch (controller.currentStep.value) {
      case 0:
        return controller.canContinueBasics;
      case 1:
        return controller.canContinueSchedule;
      default:
        return true;
    }
  }

  List<Step> _stepsFor(CreateHabitController controller) {
    return [
      Step(
        title: const Text('Basics'),
        isActive: controller.currentStep.value >= 0,
        state: controller.currentStep.value > 0 ? StepState.complete : StepState.indexed,
        content: _BasicsStep(controller: controller),
      ),
      Step(
        title: const Text('Schedule'),
        isActive: controller.currentStep.value >= 1,
        state: controller.currentStep.value > 1 ? StepState.complete : StepState.indexed,
        content: _ScheduleStep(controller: controller),
      ),
      if (controller.needsGoalStep)
        Step(
          title: const Text('Goal'),
          isActive: controller.currentStep.value >= 2,
          state: controller.currentStep.value > 2 ? StepState.complete : StepState.indexed,
          content: _GoalStep(controller: controller),
        ),
      Step(
        title: const Text('Review'),
        isActive: controller.currentStep.value >= (controller.needsGoalStep ? 3 : 2),
        content: _ReviewStep(controller: controller),
      ),
    ];
  }
}

class _BasicsStep extends StatelessWidget {
  final CreateHabitController controller;

  const _BasicsStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller.nameController,
          maxLength: 60,
          decoration: const InputDecoration(labelText: 'Habit name'),
          onChanged: (_) => controller.currentStep.refresh(),
        ),
        TextField(
          controller: controller.descriptionController,
          decoration: const InputDecoration(labelText: 'Description (optional)'),
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
                    child: selected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
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

class _ScheduleStep extends StatelessWidget {
  final CreateHabitController controller;

  const _ScheduleStep({required this.controller});

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
                    label: Text(const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i]),
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
                      onChanged: (v) => controller.intervalDays.value = int.tryParse(v) ?? 1,
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
        Obx(() => Text(controller.schedulePreview, style: Theme.of(context).textTheme.bodyMedium)),
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

class _GoalStep extends StatelessWidget {
  final CreateHabitController controller;

  const _GoalStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDuration = controller.type.value == HabitType.duration;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => TextFormField(
              initialValue: '${controller.target.value.toStringAsFixed(0)}',
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: controller.type.value == HabitType.avoid
                    ? 'Maximum allowed (0 = none)'
                    : 'Target amount',
              ),
              onChanged: (v) {
                final parsed = double.tryParse(v);
                if (parsed != null && parsed >= 0) controller.target.value = parsed;
              },
            )),
        if (!isDuration) ...[
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(labelText: 'Unit (e.g. glasses)'),
            onChanged: (v) => controller.unit.value = v,
          ),
        ],
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  final CreateHabitController controller;

  const _ReviewStep({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(backgroundColor: Color(controller.color.value)),
                    const SizedBox(width: 12),
                    Text(
                      controller.nameController.text,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(controller.schedulePreview),
                if (controller.needsGoalStep) ...[
                  const SizedBox(height: 8),
                  Text('Target: ${controller.target.value.toStringAsFixed(0)} ${controller.unit.value}'),
                ],
              ],
            ),
          ),
        ));
  }
}
