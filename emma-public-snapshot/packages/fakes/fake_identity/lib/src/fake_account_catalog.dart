import 'package:domain_identity/domain_identity.dart';

/// Stabile Demo-Konten (Passwort fuer alle: `demo2026` ausser wie dokumentiert).
///
/// IDs sind mit [CustomerAccountCatalog] (`fake_customer_account`) abgestimmt, wo
/// E-Mail uebereinstimmt.
class FakeAccountCatalog {
  FakeAccountCatalog._();

  static const demoPassword = 'demo2026';
  static const adminPassword = 'admin2026';

  static const List<FakeAccountSpec> accounts = [
    FakeAccountSpec(
      id: 'user-demo-001',
      email: 'demo@emma.de',
      password: demoPassword,
      user: User(
        id: 'user-demo-001',
        email: 'demo@emma.de',
        name: 'Max Mustermann',
        company: 'Musterfirma GmbH',
        phone: '+49 123 456789',
        address: 'Musterstrasse 123, 12345 Musterstadt',
        birthDate: null,
        language: 'de',
        notificationsEnabled: true,
      ),
    ),
    FakeAccountSpec(
      id: 'user-pilot-002',
      email: 'pilot@emma.de',
      password: demoPassword,
      user: User(
        id: 'user-pilot-002',
        email: 'pilot@emma.de',
        name: 'Anna Schmidt',
        company: 'Tech Solutions AG',
        phone: '+49 987 654321',
        address: 'Innovationsweg 45, 54321 Zukunftstadt',
        birthDate: null,
        language: 'de',
        notificationsEnabled: false,
      ),
    ),
    FakeAccountSpec(
      id: 'user-firm-003',
      email: 'firmenkunde@emma.de',
      password: adminPassword,
      user: User(
        id: 'user-firm-003',
        email: 'firmenkunde@emma.de',
        name: 'Chris Verwaltet',
        company: 'Regionalverbund Demo GmbH',
        phone: '+49 30 2000000',
        address: 'Verwaltungstrasse 1, 04109 Leipzig',
        birthDate: null,
        language: 'de',
        notificationsEnabled: true,
      ),
    ),
  ];

  static final Map<String, FakeAccountSpec> _byId = {
    for (final a in accounts) a.id: a,
  };
  static final Map<String, FakeAccountSpec> _byEmail = {
    for (final a in accounts) a.user.email.toLowerCase(): a,
  };

  static User? userById(String id) => _byId[id]?.user;

  static FakeAccountSpec? specForEmail(String email) =>
      _byEmail[email.trim().toLowerCase()];
}

class FakeAccountSpec {
  const FakeAccountSpec({
    required this.id,
    required this.email,
    required this.password,
    required this.user,
  });

  final String id;
  final String email;
  final String password;
  final User user;
}
