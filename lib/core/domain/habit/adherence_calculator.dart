import 'habit_enums.dart';

/// Adherence % = successful eligible occurrences ÷ eligible scheduled
/// occurrences × 100 (BRD §10). Skipped and not-yet-resolved
/// (pending/notScheduled) occurrences are excluded from both sides of the
/// ratio (docs/SRS.md FR-34).
class AdherenceCalculator {
  const AdherenceCalculator();

  /// Returns null ("Not enough data") when there are no eligible occurrences
  /// in range, so callers never render a misleading 0%/100% (BRD §17,
  /// docs/SRS.md FR-42).
  double? adherencePercent(List<OccurrenceState> states) {
    final eligible = states
        .where((s) =>
            s == OccurrenceState.completed ||
            s == OccurrenceState.partial ||
            s == OccurrenceState.missed)
        .toList();
    if (eligible.isEmpty) return null;
    final successes = eligible.where((s) => s == OccurrenceState.completed).length;
    return successes / eligible.length * 100;
  }
}
