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

    final eligible = scheduled.where((s) => s != OccurrenceState.skipped).toList();
    if (eligible.isEmpty) return CalendarDayStatus.none;

    final completed = eligible.where((s) => s == OccurrenceState.completed).length;
    final pending = eligible.where((s) => s == OccurrenceState.pending).length;

    // A day with anything still pending isn't resolved yet — it must never
    // read as success (BRD §S14) just because everything ELSE due so far
    // happens to be completed. Previously `pending` was discarded before
    // this check, which let a day with one uncompleted habit still show
    // as a fully-completed "success" day.
    if (pending > 0) {
      return completed == 0 ? CalendarDayStatus.none : CalendarDayStatus.partial;
    }

    if (completed == eligible.length) return CalendarDayStatus.success;
    if (completed == 0) return CalendarDayStatus.missed;
    return CalendarDayStatus.partial;
  }
}
