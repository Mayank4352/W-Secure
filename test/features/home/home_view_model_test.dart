import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/features/home/view_model/home_view_model.dart';

void main() {
  group('HomeViewModel', () {
    test('is not recording when first built', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(homeViewModelProvider), isFalse);
    });

    test('stopEmergencyMode is safe to call when idle', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Reading the notifier builds it; stopping without an active timer
      // must not throw.
      expect(
        () => container.read(homeViewModelProvider.notifier).stopEmergencyMode(),
        returnsNormally,
      );
    });
  });
}
