import 'package:flutter/material.dart';

/// E2E: platzhalterhafte Zusammenfassung, parallel zum Chat-Ergebnis.
class PrepE2eResultPlaceholderScreen extends StatelessWidget {
  const PrepE2eResultPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ergebnis (Demo)'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Kurzfassung (Dummy)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'Diese Seite fasst später feste Fahrplan- bzw. '
              'Buchungsergebnisse zusammen. Aktuell nur Layout und Typografie.',
            ),
            SizedBox(height: 20),
            _DummyDetailRow(
              label: 'Start',
              value: 'Hauptbahnhof (Beispiel)',
            ),
            _DummyDetailRow(
              label: 'Ziel',
              value: 'Halle, Marktplatz (Beispiel)',
            ),
            _DummyDetailRow(
              label: 'Abfahrt (Dummy)',
              value: 'nächster Slot',
            ),
            _DummyDetailRow(
              label: 'Hinweis',
              value: 'Keine echten Fahrplandaten',
            ),
          ],
        ),
      ),
    );
  }
}

class _DummyDetailRow extends StatelessWidget {
  const _DummyDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
