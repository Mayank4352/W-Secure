import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:security/core/error/app_exception.dart';
import 'package:security/core/services/secure_pin_store.dart';
import 'package:security/features/auth/view_model/set_pin_view_model.dart';

class _FakePinStore implements SecurePinStore {
  String? saved;

  @override
  Future<void> save(String pin) async => saved = pin;

  @override
  Future<String?> read() async => saved;

  @override
  Future<bool> hasPin() async => saved?.isNotEmpty ?? false;
}

void main() {
  group('SetPinViewModel.save', () {
    late _FakePinStore store;
    late ProviderContainer container;
    late SetPinViewModel vm;

    setUp(() {
      store = _FakePinStore();
      container = ProviderContainer(
        overrides: [securePinStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      vm = container.read(setPinViewModelProvider.notifier);
    });

    test('rejects a PIN shorter than 4 digits', () async {
      await expectLater(
        () => vm.save('123'),
        throwsA(isA<AppException>()),
      );
      expect(store.saved, isNull);
    });

    test('persists a valid PIN and clears the busy flag', () async {
      await vm.save('1234');

      expect(store.saved, '1234');
      expect(container.read(setPinViewModelProvider), isFalse);
    });
  });
}
