import 'habit_schedule_rule.dart';
import 'local_date.dart';
import 'quiet_hours.dart';

class ReminderFireTime {
  final LocalDate date;

  /// 'HH:mm' actually used — equal to the reminder's configured time unless
  /// [wasShiftedForQuietHours] is true.
  final String time;

  final bool wasShiftedForQuietHours;

  const ReminderFireTime({
    required this.date,
    required this.time,
    this.wasShiftedForQuietHours = false,
  });
}

/// Computes when a reminder should next fire. MVP schedules only the next
/// single occurrence rather than relying on OS-level daily/weekly repeat —
/// this keeps every schedule mode (daily/weekdays/interval/timesPerWeek)
/// behind one code path via [HabitScheduleRule.isScheduledOn], and makes
/// quiet-hours suppression uniform. The tradeoff: an occurrence more than
/// one reconciliation cycle away won't be scheduled yet — the app
/// reconciles on startup and after any habit/reminder change
/// (docs/ARCHITECTURE.md §7, BRD §9's own tolerance for reconciliation-
/// driven scheduling).
class ReminderScheduler {
  const ReminderScheduler();

  /// Next date on/after [from] (inclusive) this rule is due, or null if the
  /// rule has already ended. Bounded to 10 years to avoid an unbounded loop
  /// for a rule that will never occur again.
  LocalDate? nextDueDate(HabitScheduleRule rule, LocalDate from) {
    var cursor = from.isBefore(rule.startDate) ? rule.startDate : from;
    final end = rule.endDate;
    for (var i = 0; i < 3650; i++) {
      if (end != null && cursor.isAfter(end)) return null;
      if (rule.isScheduledOn(cursor)) return cursor;
      cursor = cursor.addDays(1);
    }
    return null;
  }

  /// Combines [nextDueDate] with quiet-hours handling. Returns null when
  /// there is no next occurrence, or the occurrence falls in quiet hours
  /// and [shiftToQuietHoursEnd] is false (docs/SRS.md decision 6: suppress
  /// by default; shifting to the window's end is the opt-in).
  ReminderFireTime? nextFireTime({
    required HabitScheduleRule rule,
    required LocalDate from,
    required String reminderTimeHHmm,
    QuietHours quietHours = QuietHours.disabled,
    bool shiftToQuietHoursEnd = false,
  }) {
    final date = nextDueDate(rule, from);
    if (date == null) return null;

    if (!quietHours.suppresses(reminderTimeHHmm)) {
      return ReminderFireTime(date: date, time: reminderTimeHHmm);
    }
    if (!shiftToQuietHoursEnd) return null;
    return ReminderFireTime(date: date, time: quietHours.end, wasShiftedForQuietHours: true);
  }
}
