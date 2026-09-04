import 'habit_enums.dart';

/// One calendar day's aggregate marker across every habit scheduled that
/// day (BRD §S14 "Day markers: success/partial/missed/none"). Unscheduled
/// days — or days where every scheduled habit was skipped, or none are yet
/// resolved — must never render as a failure (BRD §S14 acceptance note).
enum CalendarDayStatus { success, partial, missed, none }

/// Pure aggregation from the resolved states of every habit due on a given
/// day to a single [CalendarDayStatus] for the month grid. Kept in
/// `core/domain` so it's testable without a database or widgets
/// (docs/ARCHITECTURE.md §3).
class CalendarDayAggregator {
  const CalendarDayAggregator();

  CalendarDayStatus aggregate(List<OccurrenceState> statesForDay) {
    final scheduled = statesForDay.where((s) => s != OccurrenceState.notScheduled).toList();
    if (scheduled.isEmpty) return CalendarDayStatus.none;

    final resolved = scheduled.where((s) => s != OccurrenceState.pending).toList();
    if (resolved.isEmpty) return CalendarDayStatus.none;

    final eligible = resolved.where((s) => s != OccurrenceState.skipped).toList();
    if (eligible.isEmpty) return CalendarDayStatus.none;

    final completed = eligible.where((s) => s == OccurrenceState.completed).length;
    if (completed == eligible.length) return CalendarDayStatus.success;
    if (completed == 0) return CalendarDayStatus.missed;
    return CalendarDayStatus.partial;
  }
}
