import 'habit_enums.dart';

/// Consecutive-success counting for schedule modes where each scheduled day
/// is its own streak unit (daily/weekdays/interval). `timesPerWeek` habits
/// use [WeekQuotaEvaluator] instead, since a single day has no independent
/// success rule under that mode (BRD §8.2).
///
/// Rule (BRD §8.3): walk backward from the most recent *resolved* occurrence.
/// Pending/not-yet-resolved occurrences never break a streak. Skipped
/// occurrences neither increment nor break it. Partial and missed both break
/// it — a partial count/duration log did not meet the success threshold.
class StreakCalculator {
  const StreakCalculator();

  /// [statesChronological] must be ascending by date, containing only
  /// scheduled occurrences (already excluding [OccurrenceState.notScheduled]).
  int currentStreak(List<OccurrenceState> statesChronological) {
    var count = 0;
    for (final state in statesChronological.reversed) {
      switch (state) {
        case OccurrenceState.pending:
        case OccurrenceState.skipped:
        case OccurrenceState.notScheduled:
          continue;
        case OccurrenceState.completed:
          count++;
          continue;
        case OccurrenceState.partial:
        case OccurrenceState.missed:
          return count;
      }
    }
    return count;
  }

  int bestStreak(List<OccurrenceState> statesChronological) {
    var best = 0;
    var running = 0;
    for (final state in statesChronological) {
      switch (state) {
        case OccurrenceState.completed:
          running++;
          if (running > best) best = running;
          continue;
        case OccurrenceState.partial:
        case OccurrenceState.missed:
          running = 0;
          continue;
        case OccurrenceState.skipped:
        case OccurrenceState.pending:
        case OccurrenceState.notScheduled:
          continue;
      }
    }
    return best;
  }
}
