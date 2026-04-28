import 'package:flutter/material.dart';

import 'package:emma_app/features/trips/domain/entities/trip.dart';
import 'package:emma_app/features/trips/presentation/widgets/trip_leg_card_new.dart';

class TripDetailScreen extends StatelessWidget {
  final Trip trip;

  const TripDetailScreen({super.key, required this.trip});

  List<TripPartner> get _partners {
    final providerNames = trip.legs
        .map((leg) => leg.provider)
        .where((provider) => provider != null)
        .cast<String>()
        .toSet();

    return providerNames.map((provider) {
      switch (provider) {
        case 'Deutsche Bahn':
          return const TripPartner(
            name: 'Deutsche Bahn',
            description: 'Zugverbindung und Sitzplatzreservierung',
            contact: 'service@bahn.de',
            status: 'Verfügbar',
          );
        case 'Stadtbus':
          return const TripPartner(
            name: 'Stadtbus Leipzig',
            description: 'Busverbindung mit Onlineticket',
            contact: 'info@stadtbus.de',
            status: 'Leicht verzögert',
          );
        default:
          return TripPartner(
            name: provider,
            description: 'Mobilitätspartner für diesen Abschnitt',
            contact: 'kontakt@partner.de',
            status: 'Verfügbar',
          );
      }
    }).toList();
  }

  List<TripDisruption> get _disruptions {
    if (trip.id == 'trip_1') {
      return const [
        TripDisruption(
          title: 'Zugverspätung',
          description:
              'ICE 123 hat eine Verspätung von 10 Minuten aufgrund technischer Probleme.',
          impact: 'Ankunftszeit verzögert',
          severity: TripDisruptionSeverity.warning,
        ),
      ];
    }

    if (trip.id == 'trip_2') {
      return const [
        TripDisruption(
          title: 'Busumleitung',
          description: 'Bus 42 fährt aufgrund einer Baustelle eine Umleitung.',
          impact: 'Mehr Fußweg zum Ziel',
          severity: TripDisruptionSeverity.info,
        ),
      ];
    }

    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reisedetails')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${trip.from} → ${trip.to}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Abfahrt: ${trip.departureTime.day}.${trip.departureTime.month}.${trip.departureTime.year} ${trip.departureTime.hour.toString().padLeft(2, '0')}:${trip.departureTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Dauer: ${trip.totalDuration.inMinutes} min • Preis: €${trip.totalCost.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            const Text(
              'Reiseverlauf',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...trip.legs.map((leg) => TripLegCard(leg: leg)),
            const SizedBox(height: 24),
            const Text(
              'Partnerdaten',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ..._partners.map((partner) => _buildPartnerTile(partner)),
            const SizedBox(height: 24),
            const Text(
              'Störungsmeldungen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDisruptionSection(context),
            const SizedBox(height: 24),
            const Text(
              'Buchungsoptionen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildBookingOption(
              context,
              icon: Icons.shopping_cart,
              title: 'Ticket direkt buchen',
              subtitle: 'Online-Kauf des passenden Tickets für diese Reise.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticketkauf gestartet (Mock)')),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildBookingOption(
              context,
              icon: Icons.event_seat,
              title: 'Sitzplatz reservieren',
              subtitle: 'Reserviere deinen Platz im Zug oder Bus.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sitzplatzreservierung gestartet (Mock)'),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildBookingOption(
              context,
              icon: Icons.phone_iphone,
              title: 'Mobile Bezahlung',
              subtitle: 'Bezahlung per Mobile Wallet oder Partner-App.',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mobile Zahlung gestartet (Mock)'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Buchung startet (Mock)')),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Reise buchen'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerTile(TripPartner partner) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  partner.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(partner.status),
                  backgroundColor: partner.status == 'Verfügbar'
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(partner.description),
            const SizedBox(height: 8),
            Text(
              'Kontakt: ${partner.contact}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisruptionSection(BuildContext context) {
    final disruptions = _disruptions;
    if (disruptions.isEmpty) {
      return Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: const [
              Icon(Icons.check_circle_outline, color: Colors.green),
              SizedBox(width: 12),
              Expanded(child: Text('Aktuell keine Störungen für diese Route.')),
            ],
          ),
        ),
      );
    }

    return Column(
      children: disruptions.map((disruption) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      disruption.severity == TripDisruptionSeverity.warning
                          ? Icons.warning_amber_outlined
                          : Icons.info_outline,
                      color:
                          disruption.severity == TripDisruptionSeverity.warning
                          ? Colors.orange
                          : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        disruption.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(disruption.description),
                const SizedBox(height: 8),
                Text(
                  'Auswirkung: ${disruption.impact}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Störungsmeldung bestätigt (Mock)'),
                      ),
                    );
                  },
                  child: const Text('Störungsmeldung prüfen'),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBookingOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class TripPartner {
  final String name;
  final String description;
  final String contact;
  final String status;

  const TripPartner({
    required this.name,
    required this.description,
    required this.contact,
    required this.status,
  });
}

enum TripDisruptionSeverity { info, warning }

class TripDisruption {
  final String title;
  final String description;
  final String impact;
  final TripDisruptionSeverity severity;

  const TripDisruption({
    required this.title,
    required this.description,
    required this.impact,
    required this.severity,
  });
}
