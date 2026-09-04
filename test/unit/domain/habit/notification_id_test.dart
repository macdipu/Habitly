import 'package:customer/core/domain/habit/notification_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('stableNotificationId', () {
    test('is deterministic for the same inputs', () {
      final a = stableNotificationId('habit-1', 'reminder-1');
      final b = stableNotificationId('habit-1', 'reminder-1');
      expect(a, b);
    });

    test('differs for different reminders on the same habit', () {
      final a = stableNotificationId('habit-1', 'reminder-1');
      final b = stableNotificationId('habit-1', 'reminder-2');
      expect(a, isNot(b));
    });

    test('differs for the same reminder id on different habits', () {
      final a = stableNotificationId('habit-1', 'reminder-1');
      final b = stableNotificationId('habit-2', 'reminder-1');
      expect(a, isNot(b));
    });

    test('is always a non-negative 31-bit int (safe for platform notification ids)', () {
      for (final input in ['a', 'habit-xyz', '', 'reminder with spaces', '🔥']) {
        final id = stableNotificationId(input, input);
        expect(id, greaterThanOrEqualTo(0));
        expect(id, lessThanOrEqualTo(0x7FFFFFFF));
      }
    });
  });
}
