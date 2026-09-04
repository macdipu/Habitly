import 'dart:math' as math;

import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/today_habit_item.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.items.isEmpty) {
            return _EmptyToday(onCreate: () => _createHabit(controller));
          }
          return _TodayDashboard(controller: controller);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createHabit(controller),
        tooltip: 'Create habit',
        child: const Icon(Icons.add, size: 26),
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      children: [
        _TodayHeader(dueCount: 0, doneCount: 0),
        const SizedBox(height: 36),
        Column(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: context.primaryContainer, shape: BoxShape.circle),
              child: Icon(Icons.eco_outlined, size: 44, color: context.primary),
            ),
            const SizedBox(height: 24),
            Text('No habits yet', style: context.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Create your first habit to start tracking. Small steps, tracked quietly, add up.',
              style: context.bodyMedium?.copyWith(color: context.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onCreate, child: const Text('Create your first habit')),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _TodayDashboard extends StatelessWidget {
  final TodayController controller;

  const _TodayDashboard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final due = controller.dueNow;
    final done = controller.completed;

    return RefreshIndicator(
      onRefresh: controller.loadToday,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            child: _TodayHeader(dueCount: due.length, doneCount: done.length),
          ),
          if (due.isNotEmpty) ...[
            const _SectionHeader('DUE NOW'),
            for (final (index, item) in due.indexed) _buildCard(context, item, index),
          ],
          if (done.isNotEmpty) ...[
            const _SectionHeader('COMPLETED'),
            for (final (index, item) in done.indexed) _buildCard(context, item, due.length + index),
          ],
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, TodayHabitItem item, int index) {
    return TodayHabitCard(
      key: ValueKey(item.habit.id),
      item: item,
      onTap: () async {
        final changed = await Get.toNamed(AppRoutes.habitDetail, arguments: item.habit.id);
        if (changed == true) controller.loadToday();
      },
      onStatusTap: () => _handleStatusTap(context, item),
      onUndo: () => controller.undo(item),
      onSkip: () => controller.skipToday(item),
    )
        .animate(delay: (30 * index).ms)
        .fadeIn(duration: 260.ms, curve: Curves.easeOut)
        .slideY(begin: 0.06, end: 0, duration: 260.ms, curve: Curves.easeOut);
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

/// "Today" header with the day, serif title, and an animated ring showing
/// due/total progress — the calm focal point of the screen.
class _TodayHeader extends StatelessWidget {
  final int dueCount;
  final int doneCount;

  const _TodayHeader({required this.dueCount, required this.doneCount});

  @override
  Widget build(BuildContext context) {
    final total = dueCount + doneCount;
    final fraction = total == 0 ? 0.0 : doneCount / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(DateTime.now()).toUpperCase(),
                  style: context.labelMedium?.copyWith(color: context.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text('Today', style: context.displaySmall),
              ],
            ),
          ),
          if (total > 0) _ProgressRing(fraction: fraction, label: '$doneCount/$total'),
        ],
      ),
    );
  }
}

class _ProgressRing extends StatelessWidget {
  final double fraction;
  final String label;

  const _ProgressRing({required this.fraction, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: fraction),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, _) => Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(56, 56),
              painter: _RingPainter(
                fraction: value,
                trackColor: context.surfaceContainerHighest,
                progressColor: context.primary,
              ),
            ),
            Text(label, style: context.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double fraction;
  final Color trackColor;
  final Color progressColor;

  _RingPainter({required this.fraction, required this.trackColor, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 5.5;
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * fraction,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor;
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
      child: Text(
        title,
        style: context.labelMedium?.copyWith(color: context.onSurfaceVariant, letterSpacing: 0.6),
      ),
    );
  }
}
