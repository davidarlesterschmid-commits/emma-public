import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/core/infra_providers.dart';
import 'package:emma_app/features/trips/data/datasources/trip_remote_datasource.dart';
import 'package:emma_app/features/trips/data/repositories/trip_repository_impl.dart';
import 'package:emma_app/features/trips/domain/entities/trip.dart';
import 'package:emma_app/features/trips/domain/repositories/trip_repository.dart';

// ── Infrastructure ──────────────────────────────────────────────────────────

final _tripRemoteDataSourceProvider = Provider<TripRemoteDataSource>((ref) {
  return TripRemoteDataSourceImpl(ref.watch(dioProvider));
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepositoryImpl(ref.watch(_tripRemoteDataSourceProvider));
});

// ── State ───────────────────────────────────────────────────────────────────

class TripSearchState {
  final List<Trip> trips;
  final bool isLoading;
  final String? error;
  final String? fromQuery;
  final String? toQuery;
  final DateTime? departureTime;

  const TripSearchState({
    this.trips = const [],
    this.isLoading = false,
    this.error,
    this.fromQuery,
    this.toQuery,
    this.departureTime,
  });

  TripSearchState copyWith({
    List<Trip>? trips,
    bool? isLoading,
    String? error,
    String? fromQuery,
    String? toQuery,
    DateTime? departureTime,
  }) => TripSearchState(
    trips: trips ?? this.trips,
    isLoading: isLoading ?? this.isLoading,
    error: error ?? this.error,
    fromQuery: fromQuery ?? this.fromQuery,
    toQuery: toQuery ?? this.toQuery,
    departureTime: departureTime ?? this.departureTime,
  );
}

// ── Notifier ────────────────────────────────────────────────────────────────

class TripSearchNotifier extends Notifier<TripSearchState> {
  @override
  TripSearchState build() => const TripSearchState();

  TripRepository get _repo => ref.read(tripRepositoryProvider);

  Future<void> searchTrips({
    required String from,
    required String to,
    required DateTime departureTime,
  }) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      fromQuery: from,
      toQuery: to,
      departureTime: departureTime,
    );
    try {
      final trips = await _repo.searchTrips(
        from: from,
        to: to,
        departureTime: departureTime,
      );
      state = state.copyWith(trips: trips, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void updateFromQuery(String query) =>
      state = state.copyWith(fromQuery: query);
}

final tripSearchProvider =
    NotifierProvider<TripSearchNotifier, TripSearchState>(
      TripSearchNotifier.new,
    );
