import 'package:flutter/material.dart';

/// E2E: Ticket-Anzeige mit QR-/Strichcode-Platzhaltern — kein echter Scanner.
class PrepE2eWalletSimulationScreen extends StatelessWidget {
  const PrepE2eWalletSimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet (Demo)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _FakeTicketHeader(),
          SizedBox(height: 16),
          _FakeBarcode(),
          SizedBox(height: 20),
          _FakeQrBlock(),
          SizedBox(height: 20),
          Text(
            'Hinweis: alle Daten und Codes sind reine UI-Platzhalter, '
            'kein Wallet-Backend und keine echten Zahlungs- oder Validierungsdaten.',
            style: TextStyle(fontSize: 12.5, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _FakeTicketHeader extends StatelessWidget {
  const _FakeTicketHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tageskarte (Demo)',
              style: TextStyle(
                color: scheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text('Leipzig — Halle (Beispiel), gültig heute'),
            const SizedBox(height: 4),
            Text(
              'Ticket-ID: DEMO-7F3A-0091 (nicht echt)',
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FakeBarcode extends StatelessWidget {
  const _FakeBarcode();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Strichcode (Platzhalter)',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Semantics(
          label: 'Platzhalterbild: Strichcode',
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(4),
            ),
            child: CustomPaint(
              painter: _FakeBarcodePainter(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FakeBarcodePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bar = Paint()..color = Colors.black;
    const barWidth = 3.0;
    var x = 8.0;
    final heights = <double>[28, 40, 22, 40, 30, 40, 24, 38, 20, 40, 32];
    for (var i = 0; i < heights.length; i++) {
      final h = heights[i] * (size.height / 40);
      canvas.drawRect(
        Rect.fromLTWH(
          x,
          size.height - h - 4,
          barWidth,
          h,
        ),
        bar,
      );
      x += barWidth + (i % 3 == 0 ? 2 : 1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FakeQrBlock extends StatelessWidget {
  const _FakeQrBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'QR-Platzhalter',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Center(
          child: Semantics(
            label: 'Platzhalterbild: QR-Muster, nicht scannbar',
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CustomPaint(
                painter: _FakeQrPainter(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FakeQrPainter extends CustomPainter {
  const _FakeQrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.black;
    const cell = 8.0;
    final n = (size.width / cell).floor();
    for (var r = 0; r < n; r++) {
      for (var c = 0; c < n; c++) {
        if ((r * 7 + c * 3) % 4 == 0) {
          final left = c * cell + 4;
          final top = r * cell + 4;
          canvas.drawRect(
            Rect.fromLTWH(left, top, cell - 1, cell - 1),
            p,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
