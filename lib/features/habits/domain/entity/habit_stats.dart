import 'habit_occurrence.dart';

/// Streak/adherence summary for one habit over a date range, plus the raw
/// occurrences so callers can render a calendar/heatmap from the same query
/// (BRD §S12/S16/S17).
class HabitStats {
  final int currentStreak;
  final int bestStreak;

  /// Null = "Not enough data" (BRD §17) — no eligible occurrences in range.
  final double? adherencePercent;

  final List<HabitOccurrence> occurrences;

  const HabitStats({
    required this.currentStreak,
    required this.bestStreak,
    required this.adherencePercent,
    required this.occurrences,
  });
}
