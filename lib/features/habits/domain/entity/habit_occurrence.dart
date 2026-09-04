import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';

import 'check_in_entity.dart';

/// One resolved day in a habit's timeline — the building block for Habit
/// Detail (S12), Calendar (S14), Day Detail (S15), and Insights (S16/S17).
class HabitOccurrence {
  final LocalDate date;
  final OccurrenceState state;
  final CheckInEntity? checkIn;

  const HabitOccurrence({required this.date, required this.state, this.checkIn});
}
