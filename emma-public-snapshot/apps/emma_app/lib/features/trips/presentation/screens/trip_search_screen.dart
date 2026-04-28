import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:emma_app/core/providers.dart';
import 'package:emma_app/features/trips/presentation/widgets/trip_card.dart';

class TripSearchScreen extends ConsumerStatefulWidget {
  const TripSearchScreen({super.key});

  @override
  ConsumerState<TripSearchScreen> createState() => _TripSearchScreenState();
}

class _TripSearchScreenState extends ConsumerState<TripSearchScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  DateTime _departureTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _departureTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (!mounted) return;

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_departureTime),
      );

      if (!mounted) return;

      if (time != null) {
        setState(() {
          _departureTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _searchTrips() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isNotEmpty && to.isNotEmpty) {
      ref
          .read(tripSearchProvider.notifier)
          .searchTrips(from: from, to: to, departureTime: _departureTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(tripSearchProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reisesuche')),
      body: Column(
        children: [
          // Search Form
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _fromController,
                    decoration: const InputDecoration(
                      labelText: 'Von',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _toController,
                    decoration: const InputDecoration(
                      labelText: 'Nach',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: _selectDateTime,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Abfahrt',
                        prefixIcon: Icon(Icons.schedule),
                      ),
                      child: Text(
                        '${_departureTime.day}.${_departureTime.month}.${_departureTime.year} ${_departureTime.hour}:${_departureTime.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _searchTrips,
                      child: const Text('Suchen'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Results
          Expanded(
            child: searchState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchState.error != null
                ? Center(child: Text('Fehler: ${searchState.error}'))
                : searchState.trips.isEmpty
                ? const Center(child: Text('Keine Routen gefunden'))
                : ListView.builder(
                    itemCount: searchState.trips.length,
                    itemBuilder: (context, index) {
                      final trip = searchState.trips[index];
                      return TripCard(
                        trip: trip,
                        onTap: () => context.go('/trips/detail', extra: trip),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
