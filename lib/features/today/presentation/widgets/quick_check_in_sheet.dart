import 'package:customer/core/domain/habit/habit_enums.dart';
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
    final theme = Theme.of(context);
    final isDuration = habit.type == HabitType.duration;
    final unit = habit.unit ?? (isDuration ? 'min' : '');

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(habit.name, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            'Target: ${habit.target?.toStringAsFixed(0) ?? '-'} $unit',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: () => setState(() => _value = (_value - 1).clamp(0, double.infinity)),
                icon: const Icon(Icons.remove),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('${_value.toStringAsFixed(0)} $unit', style: theme.textTheme.headlineMedium),
              ),
              IconButton.filledTonal(
                onPressed: () => setState(() => _value = _value + 1),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (isDuration) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: [5, 10, 30].map((minutes) {
                return ActionChip(
                  label: Text('+$minutes'),
                  onPressed: () => setState(() => _value += minutes),
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
}
