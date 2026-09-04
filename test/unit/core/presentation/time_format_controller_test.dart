import 'package:customer/core/domain/models/time_format_enum.dart';
import 'package:customer/core/presentation/controllers/time_format_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimeFormatController.formatTime', () {
    test('h24 preference always shows 24h regardless of device default', () {
      final controller = TimeFormatController();
      controller.format.value = AppTimeFormat.h24;
      expect(controller.formatTime('08:05', use24hFallback: false), '08:05');
      expect(controller.formatTime('20:05', use24hFallback: false), '20:05');
    });

    test('h12 preference always shows 12h with AM/PM regardless of device default', () {
      final controller = TimeFormatController();
      controller.format.value = AppTimeFormat.h12;
      expect(controller.formatTime('00:00'), '12:00 AM');
      expect(controller.formatTime('08:05'), '8:05 AM');
      expect(controller.formatTime('12:00'), '12:00 PM');
      expect(controller.formatTime('20:05'), '8:05 PM');
    });

    test('system preference defers to the device default', () {
      final controller = TimeFormatController();
      controller.format.value = AppTimeFormat.system;
      expect(controller.formatTime('20:05'), '20:05');
      expect(controller.formatTime('20:05', use24hFallback: false), '8:05 PM');
    });
  });
}
