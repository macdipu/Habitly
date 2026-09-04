import 'package:customer/core/domain/habit/local_date.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalDate', () {
    test('parses and formats YYYY-MM-DD round trip', () {
      final date = LocalDate.parse('2026-03-05');
      expect(date, const LocalDate(2026, 3, 5));
      expect(date.toString(), '2026-03-05');
    });

    test('addDays crosses month/year boundaries', () {
      expect(const LocalDate(2025, 12, 30).addDays(3), const LocalDate(2026, 1, 2));
    });

    test('addDays crosses a leap-year Feb 29', () {
      expect(const LocalDate(2024, 2, 28).addDays(1), const LocalDate(2024, 2, 29));
      expect(const LocalDate(2024, 2, 29).addDays(1), const LocalDate(2024, 3, 1));
    });

    test('is unaffected by DST transitions (pure UTC-based arithmetic)', () {
      // US DST spring-forward 2026-03-08: local-time arithmetic on some
      // platforms can miscount this as a 23-hour day. LocalDate must not.
      expect(const LocalDate(2026, 3, 8).addDays(1), const LocalDate(2026, 3, 9));
      expect(const LocalDate(2026, 3, 8).differenceInDays(const LocalDate(2026, 3, 7)), 1);
    });

    test('differenceInDays and ordering', () {
      const a = LocalDate(2026, 1, 1);
      const b = LocalDate(2026, 1, 10);
      expect(b.differenceInDays(a), 9);
      expect(a.isBefore(b), isTrue);
      expect(b.isAfter(a), isTrue);
      expect(a.compareTo(b), lessThan(0));
    });

    test('weekday matches ISO numbering (Mon=1..Sun=7)', () {
      // 2026-01-05 is a Monday.
      expect(const LocalDate(2026, 1, 5).weekday, 1);
      expect(const LocalDate(2026, 1, 11).weekday, 7);
    });
  });
}
