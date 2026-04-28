import 'package:domain_identity/domain_identity.dart';

/// Default [AccountRepository] implementation.
///
/// Mocked until the real customer-account backend is wired in. Kept in
/// the feature package so the app layer never imports data impls
/// directly — it only sees the domain contract.
class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl();

  @override
  Future<UserAccount> getUserAccount() async {
    return const UserAccount(
      id: 'user-demo-001',
      email: 'demo@emma.de',
      roles: ['private'],
      contracts: ['employer_contract'],
      ticketHistory: ['ticket1'],
      preferences: {'theme': 'light'},
    );
  }

  @override
  Future<void> updatePreferences(Map<String, dynamic> prefs) async {
    // Mock network latency.
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}
