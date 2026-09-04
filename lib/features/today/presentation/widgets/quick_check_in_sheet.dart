import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/habit_entity.dart';
import 'package:flutter/material.dart';

/// S06 — records a non-binary habit with minimal interruption. Returns the
/// logged value, or null if the sheet was dismissed without saving.
class QuickCheckInSheet extends StatefulWidget {
  final HabitEntity habit;
  final double initialValue;

  const QuickCheckInSheet({super.key, required this.habit, this.initialValue = 0});

  static Future<double?> show(BuildContext context, HabitEntity habit, {double initialValue = 0}) {
    return showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      builder: (_) => QuickCheckInSheet(habit: habit, initialValue: initialValue),
    );
  }

  @override
  State<QuickCheckInSheet> createState() => _QuickCheckInSheetState();
}

class _QuickCheckInSheetState extends State<QuickCheckInSheet> {
  late double _value = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final isDuration = habit.type == HabitType.duration;
    final unit = habit.unit ?? (isDuration ? 'min' : '');
    final target = habit.target;
    final habitColor = Color(habit.color);
    final fraction = (target != null && target > 0) ? (_value / target).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: context.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
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
                    Text(habit.name, style: context.titleMedium),
                    Text(
                      'Target: ${target?.toStringAsFixed(0) ?? '-'} $unit',
                      style: context.bodySmall?.copyWith(color: context.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (target != null && target > 0) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 8,
                backgroundColor: context.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(context.primary),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StepButton(
                icon: Icons.remove,
                onTap: () => setState(() => _value = (_value - 1).clamp(0, double.infinity)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '${_value.toStringAsFixed(0)} $unit',
                  style: context.displaySmall,
                ),
              ),
              _StepButton(
                icon: Icons.add,
                onTap: () => setState(() => _value = _value + 1),
              ),
            ],
          ),
          if (isDuration) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [5, 10, 30].map((minutes) {
                return _QuickAddChip(
                  label: '+$minutes',
                  onTap: () => setState(() => _value += minutes),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(_value),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String icon) => switch (icon) {
        'water_drop' => Icons.water_drop_outlined,
        'book' => Icons.menu_book_outlined,
        'fitness' => Icons.fitness_center_outlined,
        'sleep' => Icons.bedtime_outlined,
        'smoking' => Icons.smoke_free_outlined,
        _ => Icons.check_circle_outline,
      };
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.primaryContainer,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: context.colorScheme.onPrimaryContainer),
        ),
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAddChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surfaceContainerLow,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: context.outlineVariant),
          ),
          child: Text(label, style: context.labelLarge),
        ),
      ),
    );
  }
}
