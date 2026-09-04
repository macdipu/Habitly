import 'habit_enums.dart';
import 'local_date.dart';

/// A minimal check-in fact needed to resolve an occurrence — decoupled from
/// the Drift row/DTO so this stays pure Dart.
class CheckInRecord {
  final CheckInStatus status;
  final double? value;

  const CheckInRecord({required this.status, this.value});
}

/// Combines "is this date scheduled", "is there a check-in", and "has this
/// date already passed" into the single [OccurrenceState] the UI and the
/// streak/adherence calculators reason about (BRD §8.4).
class OccurrenceResolver {
  const OccurrenceResolver();

  OccurrenceState resolve({
    required LocalDate date,
    required LocalDate today,
    required bool isScheduled,
    CheckInRecord? checkIn,
  }) {
    if (!isScheduled) return OccurrenceState.notScheduled;

    if (checkIn == null) {
      return date.isBefore(today) ? OccurrenceState.missed : OccurrenceState.pending;
    }

    switch (checkIn.status) {
      case CheckInStatus.completed:
        return OccurrenceState.completed;
      case CheckInStatus.partial:
        return OccurrenceState.partial;
      case CheckInStatus.missed:
        return OccurrenceState.missed;
      case CheckInStatus.skipped:
        return OccurrenceState.skipped;
    }
  }
}
