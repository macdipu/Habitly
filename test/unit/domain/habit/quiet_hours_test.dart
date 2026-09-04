import 'package:customer/core/domain/habit/quiet_hours.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuietHours', () {
    test('disabled never suppresses', () {
      expect(QuietHours.disabled.suppresses('23:00'), isFalse);
    });

    test('same-day window (e.g. 13:00-14:00) suppresses only inside it', () {
      const qh = QuietHours(enabled: true, start: '13:00', end: '14:00');
      expect(qh.suppresses('12:59'), isFalse);
      expect(qh.suppresses('13:00'), isTrue);
      expect(qh.suppresses('13:30'), isTrue);
      expect(qh.suppresses('14:00'), isFalse); // end is exclusive
    });

    test('overnight window (22:00-07:00) wraps past midnight', () {
      const qh = QuietHours(enabled: true, start: '22:00', end: '07:00');
      expect(qh.suppresses('23:30'), isTrue);
      expect(qh.suppresses('00:00'), isTrue);
      expect(qh.suppresses('06:59'), isTrue);
      expect(qh.suppresses('07:00'), isFalse);
      expect(qh.suppresses('12:00'), isFalse);
    });

    test('zero-width window (start == end) never suppresses', () {
      const qh = QuietHours(enabled: true, start: '09:00', end: '09:00');
      expect(qh.suppresses('09:00'), isFalse);
      expect(qh.suppresses('00:00'), isFalse);
    });
  });
}
