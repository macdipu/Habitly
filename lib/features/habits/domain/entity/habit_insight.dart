import 'habit_entity.dart';
import 'habit_stats.dart';

/// One row on the Insights overview (BRD §S16 "Habit ranking table").
class HabitInsight {
  final HabitEntity habit;
  final HabitStats stats;

  const HabitInsight({required this.habit, required this.stats});
}
