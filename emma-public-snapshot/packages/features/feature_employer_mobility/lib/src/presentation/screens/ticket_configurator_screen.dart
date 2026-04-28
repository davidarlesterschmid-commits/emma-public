import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:flutter/material.dart';

/// Auswahl- und Buchungsflow für verfügbare Jobtickets.
///
/// Lade- und Fehlerzustand sowie [onBook] steuert die App-Shell
/// (z. B. per Riverpod).
class TicketConfiguratorScreen extends StatefulWidget {
  const TicketConfiguratorScreen({
    super.key,
    required this.isLoading,
    this.error,
    this.tickets,
    required this.onBook,
  });

  final bool isLoading;
  final Object? error;
  final List<JobTicket>? tickets;
  final Future<void> Function(String ticketId) onBook;

  @override
  State<TicketConfiguratorScreen> createState() =>
      _TicketConfiguratorScreenState();
}

class _TicketConfiguratorScreenState extends State<TicketConfiguratorScreen> {
  String? _selectedTicketId;

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (widget.error != null) {
      return Scaffold(body: Center(child: Text('Fehler: ${widget.error}')));
    }
    final tickets = widget.tickets;
    if (tickets == null || tickets.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Keine Tickets verfügbar.')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Jobticket Konfigurator')),
      body: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          final isSelected = _selectedTicketId == ticket.id;
          return GestureDetector(
            onTap: () => setState(() => _selectedTicketId = ticket.id),
            child: _TicketCard(ticket: ticket, isSelected: isSelected),
          );
        },
      ),
      bottomNavigationBar: _selectedTicketId == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () async {
                  final id = _selectedTicketId!;
                  await widget.onBook(id);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ticket erfolgreich gebucht!'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Ticket buchen'),
              ),
            ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.isSelected});

  final JobTicket ticket;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: isSelected ? Colors.blue.shade50 : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        ticket.type == TicketType.dticket
                            ? 'D-Ticket (bundesweit)'
                            : 'Regionales Jobticket',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Gesamtpreis',
                    value: '${ticket.totalPrice.toStringAsFixed(2)} €',
                  ),
                  _InfoRow(
                    label: 'Dein Anteil',
                    value: '${ticket.employeeShare.toStringAsFixed(2)} €',
                    valueColor: Colors.orange,
                  ),
                  _InfoRow(
                    label: 'Arbeitgeber-Zuschuss',
                    value: '${ticket.employerSubsidy.toStringAsFixed(2)} €',
                    valueColor: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Gültig bis ${ticket.validTo.toString().split(' ')[0]}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }
}
