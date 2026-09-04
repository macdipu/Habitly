import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/presentation/theme/theme_extensions.dart';
import 'package:customer/features/habits/domain/entity/habit_occurrence.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// GitHub-style contribution grid (BRD §S12/S17 "mini calendar/heatmap").
/// Status is never encoded by color alone — each cell carries a semantic
/// label for screen readers (BRD §16).
class OccurrenceHeatmap extends StatelessWidget {
  final List<HabitOccurrence> occurrences;
  final void Function(HabitOccurrence occurrence)? onCellTap;

  const OccurrenceHeatmap({super.key, required this.occurrences, this.onCellTap});

  @override
  Widget build(BuildContext context) {
    if (occurrences.isEmpty) return const SizedBox.shrink();

    // Pad to a Monday start so weeks align into full columns.
    final first = occurrences.first.date;
    final leadingPad = first.weekday - 1;
    final cells = <HabitOccurrence?>[
      ...List.filled(leadingPad, null),
      ...occurrences,
    ];
    final weekCount = (cells.length / 7).ceil();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: List.generate(weekCount, (week) {
          return Padding(
            padding: const EdgeInsets.only(right: 3),
            child: Column(
              children: List.generate(7, (day) {
                final index = week * 7 + day;
                final occurrence = index < cells.length ? cells[index] : null;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: _HeatmapCell(occurrence: occurrence, onTap: onCellTap),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  final HabitOccurrence? occurrence;
  final void Function(HabitOccurrence occurrence)? onTap;

  const _HeatmapCell({required this.occurrence, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final occurrence = this.occurrence;
    if (occurrence == null) {
      return const SizedBox(width: 14, height: 14);
    }

    final color = _colorFor(context, occurrence.state, theme);
    final label = occurrence.state == OccurrenceState.notScheduled
        ? '${DateFormat.yMMMd().format(occurrence.date.toDateTime())}: not scheduled'
        : '${DateFormat.yMMMd().format(occurrence.date.toDateTime())}: ${occurrence.state.name}';

    return Semantics(
      label: label,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap == null ? null : () => onTap!(occurrence),
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Color _colorFor(BuildContext context, OccurrenceState state, ThemeData theme) {
    switch (state) {
      case OccurrenceState.completed:
        return theme.colorScheme.primary;
      case OccurrenceState.partial:
        return theme.colorScheme.secondary;
      case OccurrenceState.missed:
        // Neutral, not red — a missed day is just "no data", never a scold.
        return context.neutralMiss;
      case OccurrenceState.skipped:
        return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.35);
      case OccurrenceState.pending:
        return theme.colorScheme.outline.withValues(alpha: 0.35);
      case OccurrenceState.notScheduled:
        return theme.colorScheme.surfaceContainerHighest;
    }
  }
}
