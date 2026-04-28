import 'package:domain_ticketing/domain_ticketing.dart';
import 'package:feature_ticketing/src/presentation/widgets/ticket_product_tile.dart';
import 'package:flutter/material.dart';

/// Katalog + Demo-Kauf — [TicketingRepository] kommt von der App-Shell.
class TicketingCatalogScreen extends StatefulWidget {
  const TicketingCatalogScreen({super.key, required this.repository});

  final TicketingRepository repository;

  @override
  State<TicketingCatalogScreen> createState() => _TicketingCatalogScreenState();
}

class _TicketingCatalogScreenState extends State<TicketingCatalogScreen> {
  List<TicketProduct>? _products;
  Object? _loadError;
  bool _loading = true;
  String? _purchasingId;
  TicketPurchaseResult? _lastPurchase;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final list = await widget.repository.listProducts();
      if (!mounted) return;
      setState(() {
        _products = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
        _loading = false;
      });
    }
  }

  Future<void> _buy(String id) async {
    setState(() => _purchasingId = id);
    try {
      final result = await widget.repository.purchase(id);
      if (!mounted) return;
      setState(() {
        _lastPurchase = result;
        _purchasingId = null;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Demo-Kauf OK. Beleg ${result.receiptId}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _purchasingId = null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tickets & Produkte')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$_loadError', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: _load, child: const Text('Erneut laden')),
            ],
          ),
        ),
      );
    }
    final products = _products ?? const <TicketProduct>[];
    if (products.isEmpty) {
      return const Center(child: Text('Keine Produkte.'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_lastPurchase != null)
          MaterialBanner(
            content: Text(
              'Letzter Demo-Beleg: ${_lastPurchase!.receiptId}',
            ),
            actions: [
              TextButton(
                onPressed: () => setState(() => _lastPurchase = null),
                child: const Text('OK'),
              ),
            ],
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return TicketProductTile(
                product: p,
                isPurchasing: _purchasingId == p.id,
                onPurchase: () => _buy(p.id),
              );
            },
          ),
        ),
      ],
    );
  }
}
