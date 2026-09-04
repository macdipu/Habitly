import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/today_habit_item.dart';
import 'package:flutter/material.dart';

/// One habit row on the Today dashboard (BRD §S05): icon/color, title,
/// target, status control. Color is always paired with an icon/shape so
/// status is never encoded by color alone (BRD §16).
class TodayHabitCard extends StatelessWidget {
  final TodayHabitItem item;
  final VoidCallback onTap;
  final VoidCallback onStatusTap;
  final VoidCallback onUndo;
  final VoidCallback onSkip;

  const TodayHabitCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onStatusTap,
    required this.onUndo,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final habit = item.habit;
    final isDone = item.isDone;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Opacity(
          opacity: isDone ? 0.6 : 1.0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color(habit.color).withValues(alpha: 0.15),
                  child: Icon(_iconFor(habit.icon), color: Color(habit.color)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.name, style: theme.textTheme.titleMedium),
                      Text(_subtitleFor(habit), style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                _StatusControl(state: item.state, onTap: isDone ? onUndo : onStatusTap),
                PopupMenuButton<String>(
                  tooltip: 'More actions',
                  onSelected: (value) {
                    if (value == 'skip') onSkip();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'skip', child: Text('Skip today')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _subtitleFor(HabitEntity habit) {
    switch (habit.type) {
      case HabitType.binary:
        return 'Mark as done';
      case HabitType.count:
        return 'Target ${habit.target?.toStringAsFixed(0) ?? '-'} ${habit.unit ?? ''}';
      case HabitType.duration:
        return 'Target ${habit.target?.toStringAsFixed(0) ?? '-'} min';
      case HabitType.avoid:
        return 'Avoid today';
    }
  }

  IconData _iconFor(String icon) {
    // Icon identifier -> IconData mapping lives here so entities stay
    // Flutter-free. Extend as the icon picker (S07) grows.
    switch (icon) {
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'book':
        return Icons.menu_book_outlined;
      case 'fitness':
        return Icons.fitness_center_outlined;
      case 'sleep':
        return Icons.bedtime_outlined;
      case 'smoking':
        return Icons.smoke_free_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }
}

class _StatusControl extends StatelessWidget {
  final OccurrenceState state;
  final VoidCallback onTap;

  const _StatusControl({required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, label, color) = switch (state) {
      OccurrenceState.completed => (Icons.check_circle, 'Done', theme.colorScheme.primary),
      OccurrenceState.partial => (Icons.donut_large, 'Partial', theme.colorScheme.tertiary),
      OccurrenceState.skipped => (Icons.remove_circle_outline, 'Skipped', theme.colorScheme.onSurfaceVariant),
      OccurrenceState.pending => (Icons.radio_button_unchecked, 'Mark done', theme.colorScheme.outline),
      OccurrenceState.missed => (Icons.error_outline, 'Missed', theme.colorScheme.error),
      OccurrenceState.notScheduled => (Icons.remove, 'Not scheduled', theme.colorScheme.outline),
    };

    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: color),
      tooltip: label,
    );
  }
}
