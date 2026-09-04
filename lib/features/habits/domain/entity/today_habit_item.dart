import 'package:customer/core/domain/habit/habit_enums.dart';

import 'check_in_entity.dart';
import 'habit_entity.dart';

/// One row on the Today dashboard: a due habit combined with its resolved
/// state for the day (BRD §S05).
class TodayHabitItem {
  final HabitEntity habit;
  final OccurrenceState state;
  final CheckInEntity? checkIn;

  const TodayHabitItem({required this.habit, required this.state, this.checkIn});

  bool get isDone =>
      state == OccurrenceState.completed ||
      state == OccurrenceState.partial ||
      state == OccurrenceState.skipped;
}
