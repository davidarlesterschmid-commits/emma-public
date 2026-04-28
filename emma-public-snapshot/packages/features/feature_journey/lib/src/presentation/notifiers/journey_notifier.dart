import 'package:domain_journey/domain_journey.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:feature_journey/src/presentation/providers/journey_repository_provider.dart';

/// Orchestriert Ladezyklus und Phasenfortschritt der Journey.
class JourneyNotifier extends Notifier<JourneyCase?> {
  @override
  JourneyCase? build() {
    Future.microtask(() => loadJourney('user1'));
    return null;
  }

  JourneyRepository get _repo => ref.read(journeyRepositoryProvider);

  Future<void> loadJourney(String userId) async {
    if (!ref.mounted) return;
    final loaded = await _repo.getJourneyCase(userId);
    if (!ref.mounted) return;
    state = loaded;
  }

  Future<void> selectTravelOption(TravelOption option) async {
    final current = state ?? await _repo.getJourneyCase('user1');
    if (!ref.mounted) return;
    final selected = await _repo.selectTravelOption(current, option);
    if (!ref.mounted) return;
    state = selected;
    await _repo.updateJourneyCase(selected);
  }

  Future<void> confirmMockBooking() async {
    final current = state;
    if (current == null) return;
    final booked = await _repo.confirmMockBooking(current);
    if (!ref.mounted) return;
    state = booked;
    await _repo.updateJourneyCase(booked);
  }

  Future<void> simulateDisruption() async {
    final current = state;
    if (current == null) return;
    final disrupted = await _repo.simulateDisruption(current);
    if (!ref.mounted) return;
    state = disrupted;
    await _repo.updateJourneyCase(disrupted);
  }

  Future<void> acceptFallback() async {
    final current = state;
    if (current == null) return;
    final accepted = await _repo.acceptFallback(current);
    if (!ref.mounted) return;
    state = accepted;
    await _repo.updateJourneyCase(accepted);
  }

  Future<void> completeJourney() async {
    final current = state;
    if (current == null) return;
    final completed = await _repo.completeJourney(current);
    if (!ref.mounted) return;
    state = completed;
    await _repo.updateJourneyCase(completed);
  }

  Future<void> advanceStep() async {
    final current = state;
    if (current == null) return;
    if (!ref.mounted) return;
    final advanced = await _repo.advanceJourneyCase(current);
    if (!ref.mounted) return;
    state = advanced;
    await _repo.updateJourneyCase(advanced);
  }
}
