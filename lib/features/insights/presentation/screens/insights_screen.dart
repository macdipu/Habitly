import 'dart:async';

import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/habit_insight.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'Create a habit and log a few check-ins to see insights here.',
                style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
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
            const SizedBox(height: 20),
            if (mostConsistentIndex >= 0)
              _MostConsistentCard(insight: controller.insights[mostConsistentIndex])
                  .animate()
                  .fadeIn(duration: 260.ms)
                  .slideY(begin: 0.06, end: 0),
            const SizedBox(height: 22),
            Text('Habit ranking', style: context.titleSmall?.copyWith(color: context.onSurfaceVariant)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: context.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.outlineVariant),
              ),
              child: Column(
                children: [
                  for (final (index, insight) in controller.insights.indexed) ...[
                    if (index > 0) Divider(height: 1, color: context.outlineVariant),
                    _RankingRow(
                      habitColor: Color(insight.habit.color),
                      title: insight.habit.name,
                      adherenceLabel: insight.stats.adherencePercent == null
                          ? 'Not enough data'
                          : '${insight.stats.adherencePercent!.toStringAsFixed(0)}% adherence',
                      currentStreak: insight.stats.currentStreak,
                      onTap: () async {
                        final changed =
                            await Get.toNamed(AppRoutes.habitDetail, arguments: insight.habit.id);
                        if (changed == true) unawaited(controller.load());
                      },
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 260.ms, delay: 80.ms),
          ],
        );
      }),
    );
  }
}

class _MostConsistentCard extends StatelessWidget {
  final HabitInsight insight;

  const _MostConsistentCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final adherence = insight.stats.adherencePercent;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: context.primary, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MOST CONSISTENT',
            style: context.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.85), letterSpacing: 0.6),
          ),
          const SizedBox(height: 6),
          Text(insight.habit.name, style: context.headlineSmall?.copyWith(color: Colors.white)),
          const SizedBox(height: 4),
          Text(
            adherence == null
                ? 'Keep going to build a streak'
                : '${adherence.toStringAsFixed(0)}% adherence',
            style: context.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }
}

class _RankingRow extends StatelessWidget {
  final Color habitColor;
  final String title;
  final String adherenceLabel;
  final int currentStreak;
  final VoidCallback onTap;

  const _RankingRow({
    required this.habitColor,
    required this.title,
    required this.adherenceLabel,
    required this.currentStreak,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: habitColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.check_circle_outline, size: 17, color: habitColor),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.titleSmall),
                  Text(adherenceLabel, style: context.bodySmall?.copyWith(color: context.onSurfaceVariant)),
                ],
              ),
            ),
            if (currentStreak > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$currentStreak', style: context.titleSmall),
                  Text('day streak', style: context.labelSmall?.copyWith(color: context.onSurfaceVariant)),
                ],
              )
            else
              Text('—', style: context.titleSmall?.copyWith(color: context.onSurfaceVariant)),
          ],
        ),
      ),
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
