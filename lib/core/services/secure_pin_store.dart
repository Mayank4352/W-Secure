import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/secure_pin_store.g.dart';

/// Persists the emergency-exit PIN in platform-encrypted local storage.
class SecurePinStore {
  const SecurePinStore(this._storage);

  final FlutterSecureStorage _storage;
  static const _key = 'app_pin';

  Future<void> save(String pin) => _storage.write(key: _key, value: pin);

  Future<String?> read() => _storage.read(key: _key);

  Future<bool> hasPin() async => (await read())?.isNotEmpty ?? false;
}

@Riverpod(keepAlive: true)
SecurePinStore securePinStore(Ref ref) =>
    SecurePinStore(const FlutterSecureStorage());
