import 'habit_enums.dart';
import 'local_date.dart';

/// One recurrence rule, mirroring a `habit_schedules` row
/// (docs/DATA_MODEL.md). Pure value object — no persistence awareness.
class HabitScheduleRule {
  final ScheduleMode mode;

  /// ISO weekday ints (1=Mon..7=Sun). Used by [ScheduleMode.weekdays].
  final Set<int> weekdays;

  /// Quota for [ScheduleMode.timesPerWeek]. Weekly-quota success is
  /// evaluated by [WeekQuotaEvaluator], not per-day here.
  final int? weeklyTarget;

  /// Every Nth day for [ScheduleMode.interval].
  final int? intervalDays;

  /// Interval anchor date; defaults to [startDate] when null.
  final LocalDate? anchorDate;

  final LocalDate startDate;

  /// Null = no end date.
  final LocalDate? endDate;

  /// Occurrences on/after this date resolve against this rule row.
  final LocalDate effectiveFrom;

  const HabitScheduleRule({
    required this.mode,
    this.weekdays = const {},
    this.weeklyTarget,
    this.intervalDays,
    this.anchorDate,
    required this.startDate,
    this.endDate,
    required this.effectiveFrom,
  });

  /// Whether [date] falls within [startDate]/[endDate] and matches this
  /// rule's recurrence pattern. For `timesPerWeek`, every in-range day is a
  /// candidate — the weekly quota decides success, not day selection.
  bool isScheduledOn(LocalDate date) {
    if (date.isBefore(startDate)) return false;
    final end = endDate;
    if (end != null && date.isAfter(end)) return false;

    switch (mode) {
      case ScheduleMode.daily:
      case ScheduleMode.timesPerWeek:
        return true;
      case ScheduleMode.weekdays:
        return weekdays.contains(date.weekday);
      case ScheduleMode.interval:
        final anchor = anchorDate ?? startDate;
        final diff = date.differenceInDays(anchor);
        if (diff < 0) return false;
        final n = intervalDays ?? 1;
        return n > 0 && diff % n == 0;
    }
  }

  /// Whether [other] describes the same recurrence *pattern* — ignoring
  /// timing fields (`startDate`/`endDate`/`effectiveFrom`/`anchorDate`).
  /// Used by Edit Habit (S13) to decide whether an edit needs a new
  /// append-only schedule row at all: an unrelated change (name, color,
  /// goal) must never append a row that resets an `interval` habit's phase
  /// (docs/SRS.md FR-13).
  bool hasSameShapeAs(HabitScheduleRule other) {
    if (mode != other.mode) return false;
    switch (mode) {
      case ScheduleMode.daily:
        return true;
      case ScheduleMode.weekdays:
        return weekdays.difference(other.weekdays).isEmpty &&
            other.weekdays.difference(weekdays).isEmpty;
      case ScheduleMode.timesPerWeek:
        return weeklyTarget == other.weeklyTarget;
      case ScheduleMode.interval:
        return intervalDays == other.intervalDays;
    }
  }
}

/// Resolves which [HabitScheduleRule] applies to a given date across a
/// habit's edit history (append-only rows keyed by `effectiveFrom`), so a
/// past occurrence keeps resolving against the rule active when it happened
/// even after the habit's schedule is edited (docs/SRS.md FR-13).
class HabitScheduleTimeline {
  final List<HabitScheduleRule> _rules;

  HabitScheduleTimeline(List<HabitScheduleRule> rules)
      : _rules = List.of(rules)..sort((a, b) => a.effectiveFrom.compareTo(b.effectiveFrom));

  HabitScheduleRule? ruleFor(LocalDate date) {
    HabitScheduleRule? active;
    for (final rule in _rules) {
      if (!rule.effectiveFrom.isAfter(date)) {
        active = rule;
      } else {
        break;
      }
    }
    return active;
  }

  bool isScheduledOn(LocalDate date) => ruleFor(date)?.isScheduledOn(date) ?? false;

  /// All scheduled dates in `[from, to]` inclusive, across every rule active
  /// in that range. Bounded by the caller's range — never materializes an
  /// unbounded future (docs/ARCHITECTURE.md §3).
  List<LocalDate> occurrencesBetween(LocalDate from, LocalDate to) {
    final result = <LocalDate>[];
    var cursor = from;
    while (!cursor.isAfter(to)) {
      if (isScheduledOn(cursor)) result.add(cursor);
      cursor = cursor.addDays(1);
    }
    return result;
  }
}
