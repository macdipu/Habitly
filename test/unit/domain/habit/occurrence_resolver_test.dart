import 'package:customer/core/domain/habit/habit_enums.dart';
import 'package:customer/core/domain/habit/local_date.dart';
import 'package:customer/core/domain/habit/occurrence_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const resolver = OccurrenceResolver();
  const today = LocalDate(2026, 6, 15);

  group('OccurrenceResolver', () {
    test('unscheduled day never renders as a failure', () {
      final state = resolver.resolve(
        date: const LocalDate(2026, 6, 10),
        today: today,
        isScheduled: false,
      );
      expect(state, OccurrenceState.notScheduled);
    });

    test('scheduled past day with no check-in is missed', () {
      final state = resolver.resolve(
        date: const LocalDate(2026, 6, 10),
        today: today,
        isScheduled: true,
      );
      expect(state, OccurrenceState.missed);
    });

    test('scheduled today with no check-in yet is pending, not missed', () {
      final state = resolver.resolve(date: today, today: today, isScheduled: true);
      expect(state, OccurrenceState.pending);
    });

    test('scheduled future day with no check-in is pending', () {
      final state = resolver.resolve(
        date: const LocalDate(2026, 6, 20),
        today: today,
        isScheduled: true,
      );
      expect(state, OccurrenceState.pending);
    });

    test('a check-in status maps 1:1 to occurrence state', () {
      for (final status in CheckInStatus.values) {
        final state = resolver.resolve(
          date: const LocalDate(2026, 6, 10),
          today: today,
          isScheduled: true,
          checkIn: CheckInRecord(status: status),
        );
        expect(state.name, status.name);
      }
    });
  });
}
