import 'package:customer/core/domain/habit/calendar_day_aggregator.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/res/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/calendar_controller.dart';

/// S14 — visual history across a month. Per-habit filtering is a later
/// pass (docs/ARCHITECTURE.md §9); this aggregates across all active
/// habits.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CalendarController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Obx(() {
        final monthDate = DateTime(controller.visibleYear.value, controller.visibleMonth.value);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: controller.previousMonth,
                  icon: const Icon(Icons.chevron_left),
                  tooltip: 'Previous month',
                ),
                Text(DateFormat.yMMMM().format(monthDate), style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: controller.nextMonth,
                  icon: const Icon(Icons.chevron_right),
                  tooltip: 'Next month',
                ),
              ],
            ),
            if (controller.isLoading.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              Text(
                controller.trackedDayCount == 0
                    ? 'No scheduled days yet this month'
                    : '${controller.successDayCount}/${controller.trackedDayCount} fully completed days',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              _MonthGrid(controller: controller, monthDate: monthDate),
              const SizedBox(height: 16),
              const _Legend(),
            ],
          ],
        );
      }),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final CalendarController controller;
  final DateTime monthDate;

  const _MonthGrid({required this.controller, required this.monthDate});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final firstOfMonth = LocalDate(monthDate.year, monthDate.month, 1);
      // Blanks before the 1st so the grid's first column matches the
      // user's start-of-week preference (BRD §S03/§16).
      var leadingBlanks = firstOfMonth.weekday - controller.startOfWeekIsoDay.value;
      if (leadingBlanks < 0) leadingBlanks += 7;
      final daysInMonth = DateTime.utc(monthDate.year, monthDate.month + 1, 0).day;

      return Column(
        children: [
          _WeekdayHeader(startOfWeekIsoDay: controller.startOfWeekIsoDay.value),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
            itemCount: leadingBlanks + daysInMonth,
            itemBuilder: (context, index) {
              if (index < leadingBlanks) return const SizedBox.shrink();
              final day = index - leadingBlanks + 1;
              final date = LocalDate(monthDate.year, monthDate.month, day);
              final status = controller.statuses[date] ?? CalendarDayStatus.none;
              return _DayCell(
                day: day,
                status: status,
                onTap: () async {
                  final changed = await Get.toNamed(AppRoutes.dayDetail, arguments: date);
                  if (changed == true) controller.load();
                },
              );
            },
          ),
        ],
      );
    });
  }
}

class _WeekdayHeader extends StatelessWidget {
  final int startOfWeekIsoDay;

  const _WeekdayHeader({required this.startOfWeekIsoDay});

  @override
  Widget build(BuildContext context) {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    final ordered = List.generate(7, (i) => labels[(startOfWeekIsoDay - 1 + i) % 7]);
    final style = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);
    return Row(
      children: ordered
          .map((label) => Expanded(child: Center(child: Text(label, style: style))))
          .toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final CalendarDayStatus status;
  final VoidCallback onTap;

  const _DayCell({required this.day, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (bg, icon) = switch (status) {
      CalendarDayStatus.success => (theme.colorScheme.primary, Icons.check),
      CalendarDayStatus.partial => (theme.colorScheme.tertiary, Icons.donut_large),
      CalendarDayStatus.missed => (theme.colorScheme.error.withValues(alpha: 0.6), Icons.close),
      CalendarDayStatus.none => (Colors.transparent, null),
    };

    return Semantics(
      label: 'Day $day: ${status.name}',
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: CircleAvatar(
            backgroundColor: bg,
            child: icon != null
                ? Icon(icon, size: 16, color: theme.colorScheme.onPrimary)
                : Text('$day', style: theme.textTheme.bodySmall),
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget item(Color color, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 6, backgroundColor: color),
            const SizedBox(width: 6),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        );

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        item(theme.colorScheme.primary, 'All done'),
        item(theme.colorScheme.tertiary, 'Partial'),
        item(theme.colorScheme.error.withValues(alpha: 0.6), 'Missed'),
      ],
    );
  }
}
