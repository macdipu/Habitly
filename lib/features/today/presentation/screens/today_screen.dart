import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/features/habits/domain/entity/today_habit_item.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/today_controller.dart';
import '../widgets/quick_check_in_sheet.dart';
import '../widgets/today_habit_card.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodayController>();

    return Scaffold(
      appBar: AppBar(title: Text(DateFormat.yMMMMd().format(DateTime.now()))),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return _EmptyToday(onCreate: () => _createHabit(controller));
        }
        return _TodayDashboard(controller: controller);
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createHabit(controller),
        tooltip: 'Create habit',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _createHabit(TodayController controller) async {
    final created = await Get.toNamed(AppRoutes.createHabit);
    if (created == true) controller.loadToday();
  }
}

class _EmptyToday extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyToday({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.self_improvement_outlined, size: 72, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text('No habits yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Create your first habit to start tracking.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onCreate, child: const Text('Create your first habit')),
          ],
        ),
      ),
    );
  }
}

class _TodayDashboard extends StatelessWidget {
  final TodayController controller;

  const _TodayDashboard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final due = controller.dueNow;
    final done = controller.completed;
    final total = due.length + done.length;

    return RefreshIndicator(
      onRefresh: controller.loadToday,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : done.length / total,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Text('${done.length}/$total', style: theme.textTheme.titleMedium),
              ],
            ),
          ),
          if (due.isNotEmpty) ...[
            const _SectionHeader('Due now'),
            ...due.map((item) => _buildCard(context, item)),
          ],
          if (done.isNotEmpty) ...[
            const _SectionHeader('Completed'),
            ...done.map((item) => _buildCard(context, item)),
          ],
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, TodayHabitItem item) {
    return TodayHabitCard(
      item: item,
      onTap: () async {
        final changed = await Get.toNamed(AppRoutes.habitDetail, arguments: item.habit.id);
        if (changed == true) controller.loadToday();
      },
      onStatusTap: () => _handleStatusTap(context, item),
      onUndo: () => controller.undo(item),
      onSkip: () => controller.skipToday(item),
    );
  }

  Future<void> _handleStatusTap(BuildContext context, TodayHabitItem item) async {
    if (item.habit.type == HabitType.binary || item.habit.type == HabitType.avoid) {
      await controller.checkIn(item);
      return;
    }
    final value = await QuickCheckInSheet.show(context, item.habit);
    if (value != null) {
      await controller.checkIn(item, value: value);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
