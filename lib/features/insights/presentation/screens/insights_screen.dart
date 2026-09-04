import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/insights_controller.dart';

/// S16 — high-level progress dashboard across all active habits.
/// Per-habit deep-dive analytics (S17) reuses Habit Detail's stats for now
/// rather than a separate screen (docs/ARCHITECTURE.md §9).
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InsightsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: Obx(() {
        if (controller.isLoading.value && controller.insights.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.insights.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'Create a habit and log a few check-ins to see insights here.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final mostConsistentIndex = controller.mostConsistentIndex;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _RangeSelector(controller: controller),
            const SizedBox(height: 16),
            if (mostConsistentIndex >= 0)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.emoji_events_outlined),
                  title: const Text('Most consistent habit'),
                  subtitle: Text(controller.insights[mostConsistentIndex].habit.name),
                ),
              ),
            const SizedBox(height: 8),
            Text('Habit ranking', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...controller.insights.map((insight) {
              return Card(
                child: ListTile(
                  onTap: () => Get.toNamed(AppRoutes.habitDetail, arguments: insight.habit.id),
                  title: Text(insight.habit.name),
                  subtitle: Text(
                    insight.stats.adherencePercent == null
                        ? 'Not enough data yet'
                        : '${insight.stats.adherencePercent!.toStringAsFixed(0)}% adherence',
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department,
                              size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 2),
                          Text('${insight.stats.currentStreak}'),
                        ],
                      ),
                      Text('best ${insight.stats.bestStreak}', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  final InsightsController controller;

  const _RangeSelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => SegmentedButton<int>(
          segments: const [
            ButtonSegment(value: 7, label: Text('7d')),
            ButtonSegment(value: 30, label: Text('30d')),
            ButtonSegment(value: 90, label: Text('90d')),
          ],
          selected: {controller.rangeDays.value},
          onSelectionChanged: (selection) => controller.setRange(selection.first),
        ));
  }
}
