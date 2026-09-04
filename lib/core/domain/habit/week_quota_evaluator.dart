import 'habit_enums.dart';
import 'local_date.dart';

/// One calendar week's resolved occupancy for a `timesPerWeek` habit.
class WeekBucket {
  final LocalDate weekStart;
  final int completedDays;
  final int skippedDays;
  final bool isFullyElapsed;

  const WeekBucket({
    required this.weekStart,
    required this.completedDays,
    required this.skippedDays,
    required this.isFullyElapsed,
  });

  bool meetsQuota(int weeklyTarget) => completedDays >= weeklyTarget;
}

/// Buckets per-day occurrence states into calendar weeks and evaluates a
/// `timesPerWeek` habit's quota per week. A week — not a day — is the streak
/// unit under this schedule mode (BRD §8.2, docs/SRS.md decision 4: one
/// completed day counts once toward quota regardless of extra taps, which is
/// already enforced upstream by [OccurrenceResolver]/the check-in usecase).
class WeekQuotaEvaluator {
  /// ISO weekday the week starts on: 1 = Monday, 7 = Sunday.
  final int startOfWeekIsoDay;

  const WeekQuotaEvaluator({this.startOfWeekIsoDay = 1});

  LocalDate weekStartFor(LocalDate date) {
    var diff = (date.weekday - startOfWeekIsoDay) % 7;
    if (diff < 0) diff += 7;
    return date.addDays(-diff);
  }

  /// [entries] must be ascending by date and cover every candidate day in
  /// range (for `timesPerWeek`, that's every day — see
  /// [HabitScheduleRule.isScheduledOn]).
  List<WeekBucket> bucketByWeek(List<MapEntry<LocalDate, OccurrenceState>> entries, LocalDate today) {
    final buckets = <LocalDate, List<OccurrenceState>>{};
    for (final entry in entries) {
      final start = weekStartFor(entry.key);
      buckets.putIfAbsent(start, () => []).add(entry.value);
    }
    final sortedStarts = buckets.keys.toList()..sort();
    return sortedStarts.map((start) {
      final states = buckets[start]!;
      final completed = states.where((s) => s == OccurrenceState.completed).length;
      final skipped = states.where((s) => s == OccurrenceState.skipped).length;
      final weekEnd = start.addDays(6);
      return WeekBucket(
        weekStart: start,
        completedDays: completed,
        skippedDays: skipped,
        isFullyElapsed: weekEnd.isBefore(today),
      );
    }).toList();
  }

  /// A still-in-progress week never breaks the streak: it counts only if the
  /// quota is already met, and is otherwise treated as pending, mirroring
  /// "pending occurrences must not break a streak" (BRD §8.3).
  int currentStreakInWeeks(List<WeekBucket> weeksChronological, int weeklyTarget) {
    var count = 0;
    for (final week in weeksChronological.reversed) {
      if (!week.isFullyElapsed) {
        if (week.meetsQuota(weeklyTarget)) count++;
        continue;
      }
      if (week.meetsQuota(weeklyTarget)) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  int bestStreakInWeeks(List<WeekBucket> weeksChronological, int weeklyTarget) {
    var best = 0;
    var running = 0;
    for (final week in weeksChronological) {
      if (!week.isFullyElapsed && !week.meetsQuota(weeklyTarget)) continue;
      if (week.meetsQuota(weeklyTarget)) {
        running++;
        if (running > best) best = running;
      } else {
        running = 0;
      }
    }
    return best;
  }
}
