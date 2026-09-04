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
    final firstOfMonth = LocalDate(monthDate.year, monthDate.month, 1);
    final leadingBlanks = firstOfMonth.weekday - 1; // Monday-first grid
    final daysInMonth = DateTime.utc(monthDate.year, monthDate.month + 1, 0).day;

    return GridView.builder(
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
