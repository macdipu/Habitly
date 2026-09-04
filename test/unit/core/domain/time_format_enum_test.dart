import 'package:customer/core/domain/models/time_format_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTimeFormat', () {
    test('fromString round-trips every value', () {
      for (final format in AppTimeFormat.values) {
        expect(AppTimeFormat.fromString(format.toStringValue()), format);
      }
    });

    test('fromString defaults to system for an unrecognized value', () {
      expect(AppTimeFormat.fromString('nonsense'), AppTimeFormat.system);
    });

    test('fromString is case-insensitive', () {
      expect(AppTimeFormat.fromString('H24'), AppTimeFormat.h24);
    });
  });
}
