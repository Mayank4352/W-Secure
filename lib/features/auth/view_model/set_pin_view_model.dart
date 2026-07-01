import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/services/secure_pin_store.dart';

part 'generated/set_pin_view_model.g.dart';

@riverpod
class SetPinViewModel extends _$SetPinViewModel {
  @override
  bool build() => false;

  Future<void> save(String pin) async {
    if (pin.length < 4) {
      throw const AppException('PIN must be at least 4 digits.');
    }
    state = true;
    try {
      await ref.read(securePinStoreProvider).save(pin);
    } finally {
      state = false;
    }
  }
}
