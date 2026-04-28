/// Fake customer-account data: in-memory/JSON demo users and invoices (MVP).
///
/// DTOs and [InvoiceListPort] are defined in [emma_contracts]; this package
/// provides catalog + fake implementations.
library;

export 'package:fake_customer_account/src/fake/customer_account_catalog.dart'
    show CustomerAccountCatalog;
export 'package:fake_customer_account/src/fake/fake_account_repository.dart'
    show FakeAccountRepository;
export 'package:fake_customer_account/src/fake/fake_customer_user_id_resolver.dart'
    show FakeCustomerUserIdResolver;
export 'package:fake_customer_account/src/fake/fake_invoice_repository.dart'
    show FakeInvoiceRepository;
