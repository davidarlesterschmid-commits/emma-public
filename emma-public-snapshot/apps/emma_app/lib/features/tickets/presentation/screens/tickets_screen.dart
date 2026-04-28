import 'package:domain_journey/domain_journey.dart';
import 'package:domain_ticketing/domain_ticketing.dart';
import 'package:emma_app/features/auth/presentation/view_models/auth_notifier.dart';
import 'package:emma_app/core/journey_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final journeyCase = ref.watch(journeyCaseProvider);
    final bookingIntent = journeyCase?.bookingIntent;
    final selectedOption = journeyCase?.selectedOption;

    return Scaffold(
      appBar: AppBar(title: const Text('Meine Tickets')),
      body: authState.user == null
          ? _LoggedOut(
              onLogin: () => context.go('/login'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Drei Kauf- bzw. Anzeigepfade (MVP, siehe Produktdoku):',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                _ProcessCard(
                  title: '${TicketingUsecaseIds.uCTick01EmmaNet} emma-Preis/Netz',
                  subtitle: 'Auskunft aus M11-Regelwerk (Fake/Fixture in dieser Build).',
                  child: _buildJourneyM11Section(
                    journeyCase: journeyCase,
                    bookingIntent: bookingIntent,
                    selectedOption: selectedOption,
                  ),
                ),
                const SizedBox(height: 12),
                const _ProcessCard(
                  title:
                      '${TicketingUsecaseIds.uCTick02Operator} Dienstleister-Publikation',
                  subtitle:
                      'Noch Anzeige-Stub: Preis wuerde aus VVU-Publikations-Fixture kommen, '
                      'trennbar via TicketingLineItem-Metadaten.',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('(Stub) Naechster Schritt: operatorPublished-Repository'),
                    subtitle: Text('Gleiche Route, anderer priceSourceKind als M11.'),
                  ),
                ),
                const SizedBox(height: 12),
                const _ProcessCard(
                  title: '${TicketingUsecaseIds.uCTick03Subscription} Abo / D-Ticket (Anzeige)',
                  subtitle:
                      'MVP: reine Anzeige / Historie, kein Zahl-PSP. Verknuepft z. B. mit fake_customer_account.',
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('(Stub) Deutschlandticket / Abo-Status — Daten aus Konto-Read-Model'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _LoggedOut extends StatelessWidget {
  const _LoggedOut({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.confirmation_number_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'Melde dich an, um Prozesse und Handoffs zu sehen.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onLogin,
            child: const Text('Anmelden'),
          ),
        ],
      ),
    );
  }
}

Widget _buildJourneyM11Section({
  required JourneyCase? journeyCase,
  required BookingIntent? bookingIntent,
  required TravelOption? selectedOption,
}) {
  if (journeyCase == null) {
    return const ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Journey-Case: noch kein Szenario geladen (Route/Chat).'),
    );
  }
  final fd = journeyCase.fareDecision;
  if (fd == null) {
    return const ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('Preis: —'),
    );
  }
  final cents = fd.tariffPriceEuroCents;
  String priceLine;
  if (cents != null) {
    final eur = (cents / 100).toStringAsFixed(2);
    priceLine = '$eur EUR (M11, product=${fd.tariffProductCode}, '
        'trace=${(fd.tariffRuleTrace ?? const []).join(" > ")}), '
        'Fallback=${fd.tariffIsFallback == true}';
  } else {
    priceLine = 'Hinweis: noch kein M11-Quote in dieser Journey (Legacy-Demo).';
  }
  final buffer = StringBuffer();
  if (selectedOption != null) {
    buffer.writeln(
      '${selectedOption.legs.first.originLabel} \u2192 ${selectedOption.legs.last.destinationLabel}',
    );
  }
  if (bookingIntent != null) {
    buffer.writeln(
      'Buchung ${TicketingUsecaseIds.uCTick01EmmaNet}: ${bookingIntent.bookingIntentId} — '
      'Handoff: ${bookingIntent.handoffRequired ? "ja" : "nein"}',
    );
  }
  buffer.write(priceLine);
  if (selectedOption == null) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('emma-Preis/Netz (Journey)'),
      subtitle: Text(
        buffer.toString(),
        maxLines: 8,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  return ListTile(
    contentPadding: EdgeInsets.zero,
    title: const Text('emma-Preis/Netz (M11 + Journey)'),
    subtitle: Text(
      buffer.toString(),
      maxLines: 8,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
