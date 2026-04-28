/// Central re-export of all top-level app providers.
///
/// Feature-specific providers are self-contained in their own files.
/// Import this file for convenient access to all providers in one place.
library;

export 'package:emma_app/core/infra_providers.dart';

export 'package:emma_app/core/journey_providers.dart';
export 'package:emma_app/features/employer_mobility/presentation/providers/employer_mobility_providers.dart';

export 'package:emma_app/features/trips/presentation/providers/trip_search_provider.dart'
    show
        tripRepositoryProvider,
        TripSearchState,
        TripSearchNotifier,
        tripSearchProvider;
