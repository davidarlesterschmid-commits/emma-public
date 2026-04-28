import 'dart:convert';

import 'package:domain_identity/domain_identity.dart';
import 'package:emma_contracts/emma_contracts.dart'
    show InvoiceReadModel, InvoiceStatus;
import 'package:fake_customer_account/src/fixtures/customer_account_fixtures.json.dart';

/// In-memory view over embedded JSON demo data: users, accounts, invoices.
class CustomerAccountCatalog {
  factory CustomerAccountCatalog.fromEmbeddedJson() {
    final data =
        jsonDecode(kCustomerAccountFixturesJson) as Map<String, dynamic>;
    return CustomerAccountCatalog._(data);
  }

  CustomerAccountCatalog._(this._root);

  final Map<String, dynamic> _root;

  Map<String, dynamic> get _users => _root['users']! as Map<String, dynamic>;

  /// Demo user ids in fixture order.
  List<String> get demoUserIds => _users.keys.toList()..sort();

  UserAccount userAccountFor(String userId) {
    final u = _users[userId] as Map<String, dynamic>?;
    if (u == null) {
      throw StateError('Unknown demo userId: $userId');
    }
    return UserAccount(
      id: userId,
      email: u['email']! as String,
      roles: List<String>.from(u['roles']! as List<dynamic>),
      contracts: List<String>.from(u['contracts']! as List<dynamic>),
      ticketHistory: List<String>.from(u['ticketHistory']! as List<dynamic>),
      preferences: Map<String, dynamic>.from(
        (u['preferences'] ?? <String, dynamic>{}) as Map,
      ),
    );
  }

  List<InvoiceReadModel> invoicesForUser(String userId) {
    final u = _users[userId] as Map<String, dynamic>?;
    if (u == null) {
      return <InvoiceReadModel>[];
    }
    final list = u['invoices'] as List<dynamic>? ?? <dynamic>[];
    final out = <InvoiceReadModel>[];
    for (final e in list) {
      out.add(_invoiceFromMap(userId, e as Map<String, dynamic>));
    }
    out.sort(InvoiceReadModel.compareForListing);
    return out;
  }

  InvoiceReadModel? invoiceById(String userId, String invoiceId) {
    for (final inv in invoicesForUser(userId)) {
      if (inv.id == invoiceId) {
        return inv;
      }
    }
    return null;
  }

  static InvoiceReadModel _invoiceFromMap(
    String userId,
    Map<String, dynamic> m,
  ) {
    return InvoiceReadModel(
      id: m['id']! as String,
      userId: userId,
      invoiceNumber: m['invoiceNumber']! as String,
      issuedAt: DateTime.parse(m['issuedAt']! as String),
      dueAt: m['dueAt'] == null ? null : DateTime.parse(m['dueAt']! as String),
      amountCents: m['amountCents']! as int,
      status: _parseStatus(m['status']! as String),
      title: m['title']! as String,
    );
  }

  static InvoiceStatus _parseStatus(String s) {
    switch (s) {
      case 'open':
        return InvoiceStatus.open;
      case 'paid':
        return InvoiceStatus.paid;
      case 'overdue':
        return InvoiceStatus.overdue;
      case 'voided':
        return InvoiceStatus.voided;
      default:
        throw FormatException('Unknown invoice status: $s');
    }
  }
}
