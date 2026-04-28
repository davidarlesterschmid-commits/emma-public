import 'package:emma_app/core/config/app_config.dart';
import 'package:emma_app/features/auth/presentation/view_models/auth_notifier.dart';
import 'package:emma_contracts/emma_contracts.dart'
    show InvoiceListException, InvoiceListPort, InvoiceReadModel;
import 'package:feature_auth/feature_auth.dart';
import 'package:fake_customer_account/fake_customer_account.dart' as fakes;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Single shared catalog (embedded JSON) for the fake account layer.
final fakeCustomerAccountCatalogProvider =
    Provider<fakes.CustomerAccountCatalog>(
      (ref) => fakes.CustomerAccountCatalog.fromEmbeddedJson(),
    );

/// Maps [User.id] from auth to the fake catalog. Mock auth now uses
/// `user-demo-001` / `user-pilot-002` keys; returns `null` when logged out.
final _currentFakeCatalogUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authNotifierProvider).user?.id;
});

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  if (!AppConfig.useFakes) {
    return const AccountRepositoryImpl();
  }
  final catalog = ref.watch(fakeCustomerAccountCatalogProvider);
  return fakes.FakeAccountRepository(
    catalog: catalog,
    currentCatalogUserId: () => ref.read(_currentFakeCatalogUserIdProvider),
  );
});

/// `null` when not using fakes; otherwise the fake adapter.
final invoiceListPortProvider = Provider<InvoiceListPort?>((ref) {
  if (!AppConfig.useFakes) {
    return null;
  }
  return fakes.FakeInvoiceRepository(
    catalog: ref.watch(fakeCustomerAccountCatalogProvider),
    currentCatalogUserId: () => ref.read(_currentFakeCatalogUserIdProvider),
  );
});

/// Resolves [UserAccount] for the current session (fake catalog when
/// [AppConfig.useFakes] is true). When fakes are on and the user is logged
/// out, returns a minimal placeholder instead of erroring.
final userAccountProvider = FutureProvider<UserAccount>((ref) async {
  final repo = ref.watch(accountRepositoryProvider);
  ref.watch(authNotifierProvider);
  try {
    return await repo.getUserAccount();
  } on NotAuthenticatedFailure catch (_) {
    return const UserAccount(
      id: 'guest',
      email: '',
      roles: <String>[],
      contracts: <String>[],
      ticketHistory: <String>[],
      preferences: <String, dynamic>{},
    );
  }
});

/// Demo invoice rows for the profile shell; empty when not in fake mode
/// or when logged out.
final customerInvoicesProvider = FutureProvider<List<InvoiceReadModel>>((
  ref,
) async {
  final port = ref.watch(invoiceListPortProvider);
  if (port == null) {
    return <InvoiceReadModel>[];
  }
  ref.watch(authNotifierProvider);
  try {
    return await port.listInvoices();
  } on InvoiceListException {
    return <InvoiceReadModel>[];
  }
});
