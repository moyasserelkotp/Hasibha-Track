import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Abstract contract for token persistence
abstract class TokenStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> clearTokens();
}

/// Keys used in secure storage
class _Keys {
  static const String accessToken = 'hasibha_access_token';
  static const String refreshToken = 'hasibha_refresh_token';
}

/// Production implementation backed by [FlutterSecureStorage]
class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _storage;

  const SecureTokenStorage(this._storage);

  @override
  Future<String?> getAccessToken() async {
    return _storage.read(key: _Keys.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _Keys.refreshToken);
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _Keys.accessToken, value: accessToken),
      _storage.write(key: _Keys.refreshToken, value: refreshToken),
    ]);
  }

  @override
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _Keys.accessToken),
      _storage.delete(key: _Keys.refreshToken),
    ]);
  }
}
