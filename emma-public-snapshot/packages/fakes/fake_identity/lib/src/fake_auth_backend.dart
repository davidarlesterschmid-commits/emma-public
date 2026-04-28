import 'package:domain_identity/domain_identity.dart';
import 'package:fake_identity/src/fake_account_catalog.dart';

/// Kein Netz, keine kostenpflichtigen APIs (ADR-03).
class FakeAuthBackend {
  FakeAuthBackend._();

  static Future<User> loginWithPassword(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final spec = FakeAccountCatalog.specForEmail(email);
    if (spec == null) {
      throw const InvalidCredentialsFailure('Unbekannte E-Mail (Demo).');
    }
    if (password != spec.password) {
      throw const InvalidCredentialsFailure('Passwort ungueltig (Demo).');
    }
    return spec.user;
  }

  static Future<User> loginWithOAuth(String provider) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    // OAuth: Pilot-Nutzer (wie bisher) fuer Konsistenz mit Konto-Fixture
    return FakeAccountCatalog.userById('user-pilot-002')!;
  }
}
