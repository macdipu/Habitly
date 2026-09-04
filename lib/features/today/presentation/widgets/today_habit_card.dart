import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:customer/features/habits/domain/entity/today_habit_item.dart';
import 'package:flutter/material.dart';

/// One habit row on the Today dashboard (BRD §S05): icon/color, title,
/// target, status control. Color is always paired with an icon/shape so
/// status is never encoded by color alone (BRD §16). Missed/skipped states
/// read neutral, never red — habit tracking should never feel like a scold.
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
    final habit = item.habit;
    final isDone = item.isDone;
    final habitColor = Color(habit.color);

    return AnimatedOpacity(
      opacity: isDone ? 0.62 : 1.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
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
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: habitColor.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_iconFor(habit.icon), color: habitColor, size: 20),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.name,
                          style: context.titleMedium?.copyWith(
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            decorationColor: context.outlineVariant,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(_subtitleFor(habit, item), style: context.bodySmall?.copyWith(color: context.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  _StatusControl(
                    item: item,
                    color: habitColor,
                    onTap: isDone ? onUndo : onStatusTap,
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    iconSize: 18,
                    icon: Icon(Icons.more_vert, color: context.onSurfaceVariant),
                    tooltip: 'More actions',
                    onPressed: () => _showActions(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => SafeArea(
        child: ListTile(
          leading: const Icon(Icons.skip_next_outlined),
          title: const Text('Skip today'),
          onTap: () {
            Navigator.of(sheetContext).pop();
            onSkip();
          },
        ),
      ),
    );
  }

  String _subtitleFor(HabitEntity habit, TodayHabitItem item) {
    switch (habit.type) {
      case HabitType.binary:
        return item.isDone ? 'Done' : 'Mark as done';
      case HabitType.count:
        final logged = item.checkIn?.value?.toStringAsFixed(0) ?? '0';
        return '$logged of ${habit.target?.toStringAsFixed(0) ?? '-'} ${habit.unit ?? ''}';
      case HabitType.duration:
        final logged = item.checkIn?.value?.toStringAsFixed(0) ?? '0';
        return '$logged of ${habit.target?.toStringAsFixed(0) ?? '-'} min';
      case HabitType.avoid:
        return item.isDone ? 'Avoided' : 'Avoid today';
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
  final TodayHabitItem item;
  final Color color;
  final VoidCallback onTap;

  const _StatusControl({required this.item, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final state = item.state;
    final label = _labelFor(state);

    return Semantics(
      label: label,
      button: true,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: KeyedSubtree(
                key: ValueKey(state),
                child: ExcludeSemantics(child: _iconFor(context, state)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _labelFor(OccurrenceState state) => switch (state) {
        OccurrenceState.completed => 'Done. Tap to undo',
        OccurrenceState.partial => 'Partially logged. Tap to undo',
        OccurrenceState.skipped => 'Skipped. Tap to undo',
        OccurrenceState.pending => 'Mark done',
        OccurrenceState.missed => 'Missed',
        OccurrenceState.notScheduled => 'Not scheduled',
      };

  Widget _iconFor(BuildContext context, OccurrenceState state) {
    switch (state) {
      case OccurrenceState.completed:
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(color: context.primary, shape: BoxShape.circle),
          child: Icon(Icons.check, size: 17, color: context.colorScheme.onPrimary),
        );
      case OccurrenceState.partial:
        final logged = item.checkIn?.value;
        final target = item.habit.target;
        final fraction = (logged != null && target != null && target > 0)
            ? (logged / target).clamp(0.0, 1.0)
            : 0.4;
        return SizedBox(
          width: 26,
          height: 26,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: fraction,
                strokeWidth: 3,
                backgroundColor: context.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(context.primary),
              ),
            ],
          ),
        );
      case OccurrenceState.skipped:
        return Icon(Icons.remove_circle_outline, size: 26, color: context.onSurfaceVariant);
      case OccurrenceState.missed:
        // Neutral, not red — a missed day should read as "no data", never a scold.
        return Icon(Icons.circle_outlined, size: 26, color: context.neutralMiss);
      case OccurrenceState.pending:
        return Icon(Icons.circle_outlined, size: 26, color: context.outlineVariant);
      case OccurrenceState.notScheduled:
        return Icon(Icons.remove, size: 22, color: context.outlineVariant);
    }
  }
}
