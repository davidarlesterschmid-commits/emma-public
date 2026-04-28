import 'package:emma_app/core/config/app_config.dart';
import 'package:emma_app/features/auth/presentation/providers/auth_account_providers.dart';
import 'package:emma_app/features/auth/presentation/view_models/auth_notifier.dart';
import 'package:emma_contracts/emma_contracts.dart' show InvoiceReadModel, InvoiceStatus;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppConfig.useFakes) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rechnungen')),
        body: const Center(
          child: Text(
            'Rechnungsliste ist in diesem Build nur im Demo-Modus '
            '(--dart-define=USE_FAKES=true) verfuegbar.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final auth = ref.watch(authNotifierProvider);
    final invoices = ref.watch(customerInvoicesProvider);
    final dateFmt = DateFormat.yMMMd('de');

    return Scaffold(
      appBar: AppBar(title: const Text('Rechnungen (Demo)')),
      body: auth.user == null
          ? const Center(
              child: Text('Bitte zuerst anmelden, um Rechnungen zu sehen.'),
            )
          : invoices.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Fehler: $e', textAlign: TextAlign.center),
                ),
              ),
              data: (list) {
                if (list.isEmpty) {
                  return const Center(
                    child: Text('Keine Rechnungen vorhanden (Demo-Account).'),
                  );
                }
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    return _InvoiceTile(
                      invoice: list[i],
                      dateFormat: dateFmt,
                    );
                  },
                );
              },
            ),
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  const _InvoiceTile({
    required this.invoice,
    required this.dateFormat,
  });

  final InvoiceReadModel invoice;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final amountEur = (invoice.amountCents / 100).toStringAsFixed(2);
    return Semantics(
      label:
          'Rechnung ${invoice.invoiceNumber}, ${invoice.title}, $amountEur ${invoice.currency}',
      child: ListTile(
        title: Text(invoice.title),
        subtitle: Text(
          '${invoice.invoiceNumber} · ${dateFormat.format(invoice.issuedAt)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$amountEur ${invoice.currency}'),
            Text(
              _statusLabel(invoice.status),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

String _statusLabel(InvoiceStatus s) {
  switch (s) {
    case InvoiceStatus.open:
      return 'Offen';
    case InvoiceStatus.paid:
      return 'Bezahlt';
    case InvoiceStatus.overdue:
      return 'Ueberfaellig';
    case InvoiceStatus.voided:
      return 'Storniert';
  }
}
