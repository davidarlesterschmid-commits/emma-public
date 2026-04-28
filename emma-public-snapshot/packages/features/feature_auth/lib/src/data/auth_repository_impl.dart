import 'package:domain_identity/domain_identity.dart';
import 'package:fake_identity/fake_identity.dart';

import 'auth_local_datasource.dart';
import 'auth_remote_datasource.dart';

/// Session token for mock auth: `emma_sess_v1|{id}|{email}`.
/// Legacy tokens: `mock_token_{id}` and `mock_oauth_token_{id}`.
const _sessionV1Prefix = 'emma_sess_v1|';

/// Default [AuthRepository] implementation.
///
/// Orchestrates the remote identity provider and the local session-token
/// store. Still mock-backed; swapping the remote data source with an
/// OIDC adapter is the next logical step.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  }) : _remote = remote,
       _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  static const _useFakes = bool.fromEnvironment('USE_FAKES', defaultValue: true);

  @override
  Future<User?> getCurrentUser() async {
    final token = await _local.getToken();
    if (token == null) return null;

    final fromV1 = _userFromV1SessionToken(token);
    if (fromV1 != null) return fromV1;

    final fromLegacy = _userFromLegacyMockToken(token);
    if (fromLegacy != null) return fromLegacy;

    if (_useFakes) {
      final uid = await _local.getUserId();
      if (uid != null) {
        final u = FakeAccountCatalog.userById(uid);
        if (u != null) return u;
      }
    }

    return _demo001User;
  }

  @override
  Future<User> login(String email, String password) async {
    final user = await _remote.login(email, password);
    await _local.saveUserId(user.id);
    await _local.saveToken(_v1Token(user));
    return user;
  }

  @override
  Future<User> loginWithOAuth(String provider) async {
    final user = await _remote.loginWithOAuth(provider);
    await _local.saveUserId(user.id);
    await _local.saveToken(_v1Token(user));
    return user;
  }

  @override
  Future<void> logout() => _local.deleteToken();
}

User get _demo001User => User(
      id: 'user-demo-001',
      email: 'demo@emma.de',
      name: 'Max Mustermann',
      company: 'Musterfirma GmbH',
      phone: '+49 123 456789',
      address: 'Musterstraße 123, 12345 Musterstadt',
      birthDate: DateTime(1990, 5, 15),
      language: 'de',
      notificationsEnabled: true,
    );

User get _pilotUser => User(
      id: 'user-pilot-002',
      email: 'pilot@emma.de',
      name: 'Anna Schmidt',
      company: 'Tech Solutions AG',
      phone: '+49 987 654321',
      address: 'Innovationsweg 45, 54321 Zukunftstadt',
      birthDate: DateTime(1985, 8, 22),
      language: 'de',
      notificationsEnabled: false,
    );

String _v1Token(User user) {
  final e = _escapeEmail(user.email);
  return '$_sessionV1Prefix${user.id}|$e';
}

String _escapeEmail(String email) {
  return email.replaceAll('|', '%7C');
}

String? _unescapeEmail(String s) {
  if (s.isEmpty) return null;
  return s.replaceAll('%7C', '|');
}

User? _userFromV1SessionToken(String token) {
  if (!token.startsWith(_sessionV1Prefix)) return null;
  final rest = token.substring(_sessionV1Prefix.length);
  final i = rest.indexOf('|');
  if (i <= 0 || i >= rest.length - 1) return null;
  final id = rest.substring(0, i);
  final email = _unescapeEmail(rest.substring(i + 1));
  if (email == null) return null;

  final fake = FakeAccountCatalog.userById(id);
  if (fake != null && fake.email.toLowerCase() == email.toLowerCase()) {
    return fake;
  }

  if (id == 'user-demo-001' && email.toLowerCase() == _demo001User.email.toLowerCase()) {
    return _demo001User;
  }
  if (id == 'user-pilot-002' && email.toLowerCase() == _pilotUser.email.toLowerCase()) {
    return _pilotUser;
  }
  if (id == 'user-demo-001') {
    return _demo001User.copyWith(email: email);
  }
  if (id == 'user-pilot-002') {
    return _pilotUser.copyWith(email: email);
  }
  return User(
    id: id,
    email: email,
    name: 'Max Mustermann',
  );
}

User? _userFromLegacyMockToken(String token) {
  const prefix1 = 'mock_token_';
  const prefix2 = 'mock_oauth_token_';
  if (token.startsWith(prefix1)) {
    return _userForId(token.substring(prefix1.length));
  }
  if (token.startsWith(prefix2)) {
    return _userForId(token.substring(prefix2.length));
  }
  return null;
}

User? _userForId(String id) {
  final fromCatalog = FakeAccountCatalog.userById(id);
  if (fromCatalog != null) {
    return fromCatalog;
  }
  if (id == 'user-demo-001') return _demo001User;
  if (id == 'user-pilot-002') return _pilotUser;
  return null;
}
