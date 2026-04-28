import 'package:dio/dio.dart';
import 'package:domain_identity/domain_identity.dart';
import 'package:fake_identity/fake_identity.dart';

/// Remote side of the auth repository.
///
/// The current implementation is a mock. A real OIDC/OAuth adapter will
/// replace [AuthRemoteDataSourceImpl] without touching the contract.
abstract interface class AuthRemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> loginWithOAuth(String provider);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  // ignore: unused_field
  final Dio _dio;

  static const _useFakes = bool.fromEnvironment('USE_FAKES', defaultValue: true);

  @override
  Future<User> login(String email, String password) async {
    if (_useFakes) {
      return FakeAuthBackend.loginWithPassword(email, password);
    }
    // TODO(emma-auth): IdP-Call. Fake-Katalog dient Konsistenz mit `fake_customer_account`.
    await Future<void>.delayed(const Duration(seconds: 1));
    return User(
      id: 'user-demo-001',
      email: email,
      name: 'Max Mustermann',
      company: 'Musterfirma GmbH',
      phone: '+49 123 456789',
      address: 'Musterstraße 123, 12345 Musterstadt',
      birthDate: DateTime(1990, 5, 15),
      language: 'de',
      notificationsEnabled: true,
    );
  }

  @override
  Future<User> loginWithOAuth(String provider) async {
    if (_useFakes) {
      return FakeAuthBackend.loginWithOAuth(provider);
    }
    await Future<void>.delayed(const Duration(seconds: 1));
    return User(
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
  }
}
