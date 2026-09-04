import 'dart:async';

import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/manage_habits_controller.dart';

/// S18 (search/filter) + S19 (archived habits, restore). Reachable from
/// Settings — see docs/ARCHITECTURE.md §11 for why this was added.
class ManageHabitsScreen extends StatelessWidget {
  const ManageHabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ManageHabitsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage habits')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => controller.query.value = v,
              decoration: InputDecoration(
                hintText: 'Search habits',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: context.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: context.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: context.outlineVariant),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Active')),
                    ButtonSegment(value: true, label: Text('Archived')),
                  ],
                  selected: {controller.showArchived.value},
                  onSelectionChanged: (s) => controller.showArchived.value = s.first,
                )),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.activeHabits.isEmpty &&
                  controller.archivedHabits.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              final habits = controller.visibleHabits;
              if (habits.isEmpty) {
                return _EmptyState(archived: controller.showArchived.value, hasQuery: controller.query.value.isNotEmpty);
              }
              return RefreshIndicator(
                onRefresh: controller.load,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: habits.length,
                  itemBuilder: (context, index) => _HabitRow(
                    habit: habits[index],
                    archived: controller.showArchived.value,
                    onRestore: () => controller.restore(habits[index].id),
                    onTap: () async {
                      final changed =
                          await Get.toNamed(AppRoutes.habitDetail, arguments: habits[index].id);
                      if (changed == true) unawaited(controller.load());
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  final HabitEntity habit;
  final bool archived;
  final VoidCallback onTap;
  final VoidCallback onRestore;

  const _HabitRow({
    required this.habit,
    required this.archived,
    required this.onTap,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final habitColor = Color(habit.color);

    return Opacity(
      opacity: archived ? 0.75 : 1.0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: context.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.outlineVariant),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: habitColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(_iconFor(habit.icon), color: habitColor, size: 19),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(habit.name, style: context.titleSmall),
                        Text(
                          archived && habit.archivedAt != null
                              ? 'Archived ${DateFormat.yMMMd().format(habit.archivedAt!)}'
                              : _typeLabel(habit.type),
                          style: context.bodySmall?.copyWith(color: context.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  if (archived)
                    TextButton(onPressed: onRestore, child: const Text('Restore'))
                  else
                    Icon(Icons.chevron_right, color: context.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _typeLabel(HabitType type) => switch (type) {
        HabitType.binary => 'Yes/No',
        HabitType.count => 'Count',
        HabitType.duration => 'Duration',
        HabitType.avoid => 'Avoid/Quit',
      };

  IconData _iconFor(String icon) => switch (icon) {
        'water_drop' => Icons.water_drop_outlined,
        'book' => Icons.menu_book_outlined,
        'fitness' => Icons.fitness_center_outlined,
        'sleep' => Icons.bedtime_outlined,
        'smoking' => Icons.smoke_free_outlined,
        _ => Icons.check_circle_outline,
      };
}

class _EmptyState extends StatelessWidget {
  final bool archived;
  final bool hasQuery;

  const _EmptyState({required this.archived, required this.hasQuery});

  @override
  Widget build(BuildContext context) {
    final message = hasQuery
        ? 'No habits match your search.'
        : archived
            ? 'No archived habits. Habits you archive from Habit Detail show up here, and you can restore them anytime.'
            : 'No active habits yet.';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
        ),
      ),
    );
  }
}
