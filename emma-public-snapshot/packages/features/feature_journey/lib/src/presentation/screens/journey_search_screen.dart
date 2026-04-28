import 'package:domain_journey/domain_journey.dart';
import 'package:emma_contracts/emma_contracts.dart';
import 'package:flutter/material.dart';

import 'package:feature_journey/src/presentation/widgets/travel_option_card.dart';

/// Navigations-Callback nach Option-Auswahl.
///
/// Wird vom composition-root gewired, damit das Feature-Paket
/// keine `go_router`-Abhaengigkeit traegt.
typedef JourneyOptionSelected = void Function(TravelOption option);

/// Such-Einstieg in die Journey-Domaene.
///
/// Bewusst Riverpod-frei: [routingPort] und [onOptionSelected] kommen
/// als Parameter. Wiring und Navigation verantwortet die App-Shell
/// (siehe `apps/emma_app/lib/composition/journey_search_screen.dart`).
///
/// State ist lokal: Formulareingaben, Lade-, Fehler- und Ergebnis-Zustand.
/// Deterministische Uebergaenge:
///   idle       → {loading:false, options:[], error:null}
///   loading    → {loading:true , options:prev, error:null}
///   success    → {loading:false, options:[…], error:null}
///   failed     → {loading:false, options:prev, error:String}
class JourneySearchScreen extends StatefulWidget {
  const JourneySearchScreen({
    super.key,
    required this.routingPort,
    this.onOptionSelected,
    this.userId = 'user1',
    this.initialArrival,
  });

  /// Port zur Routing-Backend-Seite. Der composition-root reicht hier
  /// z.B. `TriasRoutingPort` oder einen Fake fuer Tests/Preview hinein.
  final RoutingPort routingPort;

  /// Navigations-Hook nach Option-Auswahl. `null` = Auswahl-Tap inert.
  final JourneyOptionSelected? onOptionSelected;

  /// Platzhalter bis zur Auth-Integration (Task #26/#37).
  final String userId;

  /// Optionaler Start-Wert fuer die Ziel-Ankunftszeit. Default:
  /// `now + 1h`. In Tests nuetzlich fuer deterministische Zeitwahl.
  final DateTime? initialArrival;

  @override
  State<JourneySearchScreen> createState() => _JourneySearchScreenState();
}

class _JourneySearchScreenState extends State<JourneySearchScreen> {
  final _originCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();
  late DateTime _arrival;
  bool _loading = false;
  String? _error;
  List<TravelOption> _options = const [];

  @override
  void initState() {
    super.initState();
    _arrival =
        widget.initialArrival ?? DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _originCtrl.dispose();
    _destinationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickArrival() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _arrival,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (!mounted || date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_arrival),
    );
    if (!mounted || time == null) return;

    setState(() {
      _arrival = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  UserIntent _buildIntent({
    required String origin,
    required String destination,
  }) {
    return UserIntent(
      intentId: 'intent-${DateTime.now().microsecondsSinceEpoch}',
      userId: widget.userId,
      source: 'journey_search_screen',
      rawText: '$origin -> $destination',
      origin: origin,
      destination: destination,
      targetArrivalTime: _arrival,
      tripPurpose: 'private',
      preferencesSnapshot: const {},
      needsClarification: false,
    );
  }

  Future<void> _submit() async {
    final origin = _originCtrl.text.trim();
    final destination = _destinationCtrl.text.trim();
    if (origin.isEmpty || destination.isEmpty) {
      setState(() {
        _error = 'Bitte Start und Ziel angeben.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final options = await widget.routingPort.searchOptions(
        intent: _buildIntent(origin: origin, destination: destination),
      );
      if (!mounted) return;
      setState(() {
        _loading = false;
        _options = options;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  String _formatArrival(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final h = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.${dt.year} $h:$mi';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reisesuche')),
      body: Column(
        children: [
          _SearchForm(
            originController: _originCtrl,
            destinationController: _destinationCtrl,
            arrivalLabel: _formatArrival(_arrival),
            onPickArrival: _pickArrival,
            onSubmit: _loading ? null : _submit,
            loading: _loading,
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _error!,
                key: const Key('journey-search-error'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Expanded(
            child: _ResultsList(
              loading: _loading,
              options: _options,
              onOptionTap: widget.onOptionSelected,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchForm extends StatelessWidget {
  const _SearchForm({
    required this.originController,
    required this.destinationController,
    required this.arrivalLabel,
    required this.onPickArrival,
    required this.onSubmit,
    required this.loading,
  });

  final TextEditingController originController;
  final TextEditingController destinationController;
  final String arrivalLabel;
  final VoidCallback onPickArrival;
  final VoidCallback? onSubmit;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              key: const Key('journey-search-origin'),
              controller: originController,
              decoration: const InputDecoration(
                labelText: 'Von',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('journey-search-destination'),
              controller: destinationController,
              decoration: const InputDecoration(
                labelText: 'Nach',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              key: const Key('journey-search-arrival-picker'),
              onTap: onPickArrival,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ziel-Ankunft',
                  prefixIcon: Icon(Icons.schedule),
                ),
                child: Text(arrivalLabel),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                key: const Key('journey-search-submit'),
                onPressed: onSubmit,
                child: loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Suchen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({
    required this.loading,
    required this.options,
    required this.onOptionTap,
  });

  final bool loading;
  final List<TravelOption> options;
  final JourneyOptionSelected? onOptionTap;

  @override
  Widget build(BuildContext context) {
    if (loading && options.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (options.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Noch keine Suche ausgefuehrt.\n'
            'Start und Ziel eingeben und "Suchen" tippen.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      key: const Key('journey-search-results'),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return TravelOptionCard(
          option: option,
          onTap: onOptionTap == null ? null : () => onOptionTap!(option),
        );
      },
    );
  }
}
