import 'package:domain_journey/domain_journey.dart';
import 'package:emma_contracts/emma_contracts.dart';
import 'package:feature_journey/feature_journey.dart'
    show TravelOptionCard, journeyRoutingPortProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Legacy-Result-Screen der `trips/`-Welt, T3-Inkrement A:
///
/// Nutzt jetzt den kanonischen [journeyRoutingPortProvider] statt
/// `TriasService()` direkt zu instanzieren. Dadurch entfaellt die
/// harte Kopplung an TRIAS und die Testbarkeit steigt — Tests
/// ueberschreiben einfach den Provider.
///
/// Legacy bleibt: Die UI erzeugt intern noch eine [UserIntent] aus
/// zwei [EmmaLocation]-Parametern, damit der vorhandene
/// `/trips`-Flow unveraendert weiter funktioniert. In Inkrement B
/// wird dieser Screen samt `trips/`-Feature-Root entfernt; der
/// `/journey`-Flow ist der Zielpfad.
class TripResultScreen extends ConsumerStatefulWidget {
  const TripResultScreen({
    super.key,
    required this.origin,
    required this.destination,
    this.targetArrival,
  });

  final EmmaLocation origin;
  final EmmaLocation destination;

  /// Optionales Ziel-Ankunfts-Datetime. Default: jetzt + 2 h.
  final DateTime? targetArrival;

  @override
  ConsumerState<TripResultScreen> createState() => _TripResultScreenState();
}

class _TripResultScreenState extends ConsumerState<TripResultScreen> {
  List<TravelOption> _options = const <TravelOption>[];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    final port = ref.read(journeyRoutingPortProvider);
    final intent = _buildIntent();
    try {
      final result = await port.searchOptions(intent: intent);
      if (!mounted) return;
      setState(() {
        _options = result;
        _isLoading = false;
      });
    } catch (err) {
      if (!mounted) return;
      setState(() {
        _error = err.toString();
        _isLoading = false;
      });
    }
  }

  UserIntent _buildIntent() {
    final now = DateTime.now();
    return UserIntent(
      intentId: 'trip-${now.microsecondsSinceEpoch}',
      userId: 'legacy-trips-user',
      source: 'legacy-trip-search',
      rawText: '${widget.origin.name} -> ${widget.destination.name}',
      origin: widget.origin.name,
      destination: widget.destination.name,
      targetArrivalTime:
          widget.targetArrival ?? now.add(const Duration(hours: 2)),
      tripPurpose: 'unspecified',
      preferencesSnapshot: const <String, dynamic>{},
      needsClarification: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Verbindungen')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Fehler: $_error', textAlign: TextAlign.center),
          ),
        ),
      );
    }

    if (_options.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Verbindungen')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Keine Verbindungen gefunden.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Verbindungen')),
      body: ListView.builder(
        itemCount: _options.length,
        itemBuilder: (context, index) {
          return TravelOptionCard(option: _options[index]);
        },
      ),
    );
  }
}
