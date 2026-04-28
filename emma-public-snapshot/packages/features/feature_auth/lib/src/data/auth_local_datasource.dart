import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Local session-token storage port (feature-internal).
///
/// Kept as an abstract interface so tests can substitute an in-memory
/// fake without pulling in `flutter_secure_storage`.
abstract interface class AuthLocalDataSource {
  Future<String?> getToken();
  Future<void> saveToken(String token);
  /// Optional: stabile Nutzer-ID der Session (Fake/IdP-Subject), fuer Profil-Lookup.
  Future<String?> getUserId();
  Future<void> saveUserId(String userId);
  Future<void> deleteToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'auth_user_id';

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  @override
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  @override
  Future<String?> getUserId() => _storage.read(key: _userIdKey);

  @override
  Future<void> saveUserId(String userId) =>
      _storage.write(key: _userIdKey, value: userId);

  @override
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
  }
}
