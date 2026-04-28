import 'package:domain_identity/domain_identity.dart';

import 'package:fake_customer_account/src/fake/customer_account_catalog.dart';
import 'package:fake_customer_account/src/fake/fake_customer_user_id_resolver.dart';

/// [AccountRepository] backed by [CustomerAccountCatalog] +
/// [FakeCustomerUserIdResolver].
class FakeAccountRepository implements AccountRepository {
  FakeAccountRepository({
    required CustomerAccountCatalog catalog,
    required FakeCustomerUserIdResolver currentCatalogUserId,
  }) : _catalog = catalog,
       _currentCatalogUserId = currentCatalogUserId;

  final CustomerAccountCatalog _catalog;
  final FakeCustomerUserIdResolver _currentCatalogUserId;

  @override
  Future<UserAccount> getUserAccount() async {
    final id = _currentCatalogUserId();
    if (id == null) {
      throw const NotAuthenticatedFailure();
    }
    return _catalog.userAccountFor(id);
  }

  @override
  Future<void> updatePreferences(Map<String, dynamic> prefs) async {
    final id = _currentCatalogUserId();
    if (id == null) {
      throw const NotAuthenticatedFailure();
    }
    // In-memory no-op: catalog is immutable; callers in tests can ignore.
    if (prefs.isEmpty) {
      return;
    }
  }
}
