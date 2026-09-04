import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/presentation/widgets/occurrence_heatmap.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      ),
      // A visible action row, not just an overflow menu — Edit/Archive/
      // Delete are the whole point of this screen, matching the design
      // mockup's bottom action row rather than burying them a tap deeper.
      bottomNavigationBar: Obx(() {
        if (controller.habit.value == null) return const SizedBox.shrink();
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.edit_outlined,
                    label: 'Edit',
                    onTap: () => _handleAction(context, controller, 'edit'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.inventory_2_outlined,
                    label: 'Archive',
                    onTap: () => _handleAction(context, controller, 'archive'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.delete_outline,
                    label: 'Delete',
                    destructive: true,
                    onTap: () => _handleAction(context, controller, 'delete'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
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
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Color(habit.color),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.name, style: context.headlineSmall),
                      if (habit.description != null)
                        Text(habit.description!, style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant)),
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
                  Expanded(
                    child: _StatCard(
                      icon: Icons.local_fire_department_outlined,
                      label: 'Current streak',
                      value: stats.currentStreak,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.emoji_events_outlined,
                      label: 'Best streak',
                      value: stats.bestStreak,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.donut_large_outlined,
                      label: 'Adherence',
                      value: stats.adherencePercent?.round(),
                      suffix: '%',
                      fallback: 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Last 90 days', style: context.titleMedium),
              const SizedBox(height: 12),
              OccurrenceHeatmap(occurrences: stats.occurrences),
            ],
          ],
        ).animate().fadeIn(duration: 250.ms);
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool destructive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive ? context.error : context.onSurface;
    final borderColor = destructive ? context.error.withValues(alpha: 0.4) : context.outlineVariant;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(height: 4),
              Text(label, style: context.labelMedium?.copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? value;
  final String suffix;
  final String fallback;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.suffix = '',
    this.fallback = '0',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        child: Column(
          children: [
            Icon(icon, size: 17, color: context.onSurfaceVariant),
            const SizedBox(height: 6),
            if (value == null)
              Text(fallback, style: context.headlineSmall)
            else
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: value),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, animatedValue, _) =>
                    Text('$animatedValue$suffix', style: context.headlineSmall),
              ),
            const SizedBox(height: 4),
            Text(label, style: context.labelMedium?.copyWith(color: context.onSurfaceVariant), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
