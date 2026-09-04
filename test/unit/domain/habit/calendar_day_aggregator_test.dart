import 'package:customer/core/domain/habit/calendar_day_aggregator.dart';
import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const aggregator = CalendarDayAggregator();

  group('CalendarDayAggregator', () {
    test('no habits scheduled -> none, never rendered as a failure', () {
      expect(aggregator.aggregate([]), CalendarDayStatus.none);
      expect(
        aggregator.aggregate([OccurrenceState.notScheduled, OccurrenceState.notScheduled]),
        CalendarDayStatus.none,
      );
    });

    test('all scheduled habits completed -> success', () {
      expect(
        aggregator.aggregate([OccurrenceState.completed, OccurrenceState.completed]),
        CalendarDayStatus.success,
      );
    });

    test('some completed, some not -> partial', () {
      expect(
        aggregator.aggregate([OccurrenceState.completed, OccurrenceState.missed]),
        CalendarDayStatus.partial,
      );
    });

    test('none completed -> missed', () {
      expect(
        aggregator.aggregate([OccurrenceState.missed, OccurrenceState.missed]),
        CalendarDayStatus.missed,
      );
    });

    test('a future day where everything is still pending is none, not missed', () {
      expect(
        aggregator.aggregate([OccurrenceState.pending, OccurrenceState.pending]),
        CalendarDayStatus.none,
      );
    });

    test('everything skipped is none, not a failure', () {
      expect(
        aggregator.aggregate([OccurrenceState.skipped, OccurrenceState.skipped]),
        CalendarDayStatus.none,
      );
    });

    test('a skipped habit is excluded while others still resolve normally', () {
      expect(
        aggregator.aggregate([OccurrenceState.completed, OccurrenceState.skipped]),
        CalendarDayStatus.success,
      );
    });
  });
}
