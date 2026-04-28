/// Resolves the signed-in [User.id] (from [AuthRepository]) to the
/// [CustomerAccountCatalog] user key (`user-demo-001`, …).
///
/// When `null` is returned, account/invoice fakes treat the user as signed out
/// and throw like an empty session.
typedef FakeCustomerUserIdResolver = String? Function();
