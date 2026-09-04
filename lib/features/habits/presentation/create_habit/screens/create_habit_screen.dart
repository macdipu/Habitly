import 'package:customer/features/habits/presentation/habit_form/habit_form_steps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/create_habit_controller.dart';

/// S07–S11 flow: Basics → Schedule → Goal (skipped for binary habits) →
/// Reminders → Review.
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
    if (controller.currentStep.value == 0) return controller.canContinueBasics;
    if (controller.currentStep.value == 1) return controller.canContinueSchedule;
    return true;
  }

  List<Step> _stepsFor(CreateHabitController controller) {
    final step = controller.currentStep.value;
    return [
      Step(
        title: const Text('Basics'),
        isActive: step >= 0,
        state: step > 0 ? StepState.complete : StepState.indexed,
        content: BasicsStep(controller: controller),
      ),
      Step(
        title: const Text('Schedule'),
        isActive: step >= 1,
        state: step > 1 ? StepState.complete : StepState.indexed,
        content: ScheduleStep(controller: controller),
      ),
      if (controller.needsGoalStep)
        Step(
          title: const Text('Goal'),
          isActive: step >= 2,
          state: step > 2 ? StepState.complete : StepState.indexed,
          content: GoalStep(controller: controller),
        ),
      Step(
        title: const Text('Reminders'),
        isActive: step >= controller.remindersStepIndex,
        state: step > controller.remindersStepIndex ? StepState.complete : StepState.indexed,
        content: RemindersStep(controller: controller),
      ),
      Step(
        title: const Text('Review'),
        isActive: step >= controller.reviewStepIndex,
        content: _ReviewStep(controller: controller),
      ),
    ];
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
                  Text('Target: ${controller.targetController.text} ${controller.unitController.text}'),
                ],
                const SizedBox(height: 8),
                Text(
                  controller.remindersEnabled.value
                      ? 'Reminders: ${controller.reminderDrafts.map((d) => d.time).join(', ')}'
                      : 'No reminders',
                ),
              ],
            ),
          ),
        ));
  }
}
