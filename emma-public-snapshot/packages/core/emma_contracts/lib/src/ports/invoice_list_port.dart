/// Read model for a customer invoice (MVP, display-only).
///
/// Lives in [emma_contracts] so app shell and fakes can share a stable shape
/// without a domain_ledger module yet. Amount is in the smallest currency unit
/// (e.g. Euro cents).
class InvoiceReadModel {
  const InvoiceReadModel({
    required this.id,
    required this.userId,
    required this.invoiceNumber,
    required this.issuedAt,
    this.dueAt,
    required this.amountCents,
    this.currency = 'EUR',
    required this.status,
    required this.title,
  });

  final String id;
  final String userId;
  final String invoiceNumber;
  final DateTime issuedAt;
  final DateTime? dueAt;
  final int amountCents;
  final String currency;
  final InvoiceStatus status;
  final String title;

  /// Newest [issuedAt] first; tie-breaker [id] ascending.
  static int compareForListing(InvoiceReadModel a, InvoiceReadModel b) {
    final byTime = b.issuedAt.compareTo(a.issuedAt);
    if (byTime != 0) {
      return byTime;
    }
    return a.id.compareTo(b.id);
  }
}

/// Coarse payment state for invoice lists in demos and tests.
enum InvoiceStatus { open, paid, overdue, voided }

/// Thrown by invoice adapters when the caller has no active customer session.
class InvoiceListException implements Exception {
  const InvoiceListException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() {
    if (cause == null) {
      return 'InvoiceListException: $message';
    }
    return 'InvoiceListException: $message ($cause)';
  }
}

/// Read access to the signed-in customer’s invoices.
///
/// Implementations: [package:fake_customer_account] (MVP fakes) and future
/// HTTP adapters. Callers (ViewModels) translate errors to UI.
abstract interface class InvoiceListPort {
  /// All invoices for the current user, newest first.
  Future<List<InvoiceReadModel>> listInvoices();

  /// One invoice, or `null` if [id] is unknown for this user.
  Future<InvoiceReadModel?> getInvoice(String id);
}
