import 'package:customer/services/backup/csv_export_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CsvExportService.csvCell', () {
    test('leaves a plain value untouched', () {
      expect(CsvExportService.csvCell('Drink water'), 'Drink water');
    });

    test('quotes and escapes a value containing a comma', () {
      expect(CsvExportService.csvCell('Read, then reflect'), '"Read, then reflect"');
    });

    test('quotes and doubles embedded quotes', () {
      expect(CsvExportService.csvCell('Said "great job"'), '"Said ""great job"""');
    });

    test('quotes a value containing a newline', () {
      expect(CsvExportService.csvCell('line one\nline two'), '"line one\nline two"');
    });

    test('empty string needs no quoting', () {
      expect(CsvExportService.csvCell(''), '');
    });
  });
}
