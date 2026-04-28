import 'package:emma_contracts/emma_contracts.dart'
    show InvoiceListException, InvoiceListPort, InvoiceReadModel;
import 'package:fake_customer_account/src/fake/customer_account_catalog.dart';
import 'package:fake_customer_account/src/fake/fake_customer_user_id_resolver.dart';

/// Deterministic in-memory [InvoiceListPort] for demo and tests.
class FakeInvoiceRepository implements InvoiceListPort {
  FakeInvoiceRepository({
    required CustomerAccountCatalog catalog,
    required FakeCustomerUserIdResolver currentCatalogUserId,
  }) : _catalog = catalog,
       _currentCatalogUserId = currentCatalogUserId;

  final CustomerAccountCatalog _catalog;
  final FakeCustomerUserIdResolver _currentCatalogUserId;

  @override
  Future<List<InvoiceReadModel>> listInvoices() async {
    final id = _currentCatalogUserId();
    if (id == null) {
      throw const InvoiceListException('Not authenticated');
    }
    return _catalog.invoicesForUser(id);
  }

  @override
  Future<InvoiceReadModel?> getInvoice(String id) async {
    final userId = _currentCatalogUserId();
    if (userId == null) {
      throw const InvoiceListException('Not authenticated');
    }
    return _catalog.invoiceById(userId, id);
  }
}
