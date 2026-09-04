import 'package:customer/features/habits/presentation/widgets/occurrence_heatmap.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/habit_detail_controller.dart';

/// S12 — full overview of one habit. Edit/Archive/Delete all wired end to
/// end.
class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HabitDetailController>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Get.back(result: controller.changed.value);
      },
      child: Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.habit.value?.name ?? '')),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleAction(context, controller, value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'archive', child: Text('Archive')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        final habit = controller.habit.value;
        final stats = controller.stats.value;
        if (controller.isLoading.value && habit == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (habit == null) {
          return const Center(child: Text('Habit not found'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(habit.color).withValues(alpha: 0.15),
                  child: Icon(Icons.check_circle_outline, color: Color(habit.color), size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.name, style: Theme.of(context).textTheme.headlineSmall),
                      if (habit.description != null) Text(habit.description!),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (stats == null)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Current streak', value: '${stats.currentStreak}')),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Best streak', value: '${stats.bestStreak}')),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Adherence',
                      value: stats.adherencePercent == null
                          ? 'N/A'
                          : '${stats.adherencePercent!.toStringAsFixed(0)}%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Last 90 days', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              OccurrenceHeatmap(occurrences: stats.occurrences),
            ],
          ],
        );
      }),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    HabitDetailController controller,
    String action,
  ) async {
    switch (action) {
      case 'edit':
        final changed = await Get.toNamed(AppRoutes.editHabit, arguments: controller.habitId);
        if (changed == true) {
          controller.changed.value = true;
          controller.load();
        }
        break;
      case 'archive':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Archive habit?'),
            content: const Text(
              'This stops future reminders and removes it from Today. All history is kept, '
              'and you can restore it later.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Archive')),
            ],
          ),
        );
        if (confirmed == true) {
          final success = await controller.archive();
          if (success && context.mounted) Get.back(result: true);
        }
        break;
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete habit permanently?'),
            content: const Text(
              'This permanently deletes this habit and all of its history. This cannot be undone.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete permanently'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          final success = await controller.delete();
          if (success && context.mounted) Get.back(result: true);
        }
        break;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(label, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
