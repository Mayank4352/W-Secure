import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/error/app_exception.dart';

void main() {
  group('AppException', () {
    test('exposes the message it was created with', () {
      const exception = AppException('Something failed');
      expect(exception.message, 'Something failed');
    });

    test('toString returns the raw message', () {
      const exception = AppException('Network unavailable');
      expect(exception.toString(), 'Network unavailable');
    });

    test('is an Exception', () {
      expect(const AppException('x'), isA<Exception>());
    });
  });
}
