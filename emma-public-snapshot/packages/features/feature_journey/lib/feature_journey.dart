/// Public surface of the `feature_journey` package.
///
/// Exposes:
///   * [JourneyNotifier] — state machine; app defines [journeyCaseProvider] in
///     `apps/emma_app/lib/core/journey_providers.dart`.
///   * [journeyRepositoryProvider] — throw-by-default; app overrides with
///     [JourneyRepositoryImpl].
///   * Port-bindings ([journeyTariffPortProvider],
///     [journeyRoutingPortProvider], [journeyBudgetPortProvider]) that the
///     composition root must override in the [ProviderScope].
///   * Routable widgets ([JourneySearchScreen], [JourneyStepScreen],
///     [JourneyStepWidget]).
library;

export 'package:domain_customer_service/domain_customer_service.dart'
    show SupportCase;
export 'package:domain_reporting/domain_reporting.dart' show ReportingEvent;

export 'src/data/journey_repository_impl.dart' show JourneyRepositoryImpl;
export 'src/presentation/notifiers/journey_notifier.dart' show JourneyNotifier;
export 'src/presentation/providers/journey_repository_provider.dart'
    show journeyRepositoryProvider;
export 'src/presentation/screens/journey_option_detail_screen.dart';
export 'src/presentation/screens/journey_search_screen.dart';
export 'src/presentation/screens/journey_step_screen.dart';
export 'src/presentation/widgets/journey_step_widget.dart';
export 'src/presentation/widgets/travel_leg_row.dart';
export 'src/presentation/widgets/travel_option_card.dart';
export 'src/wiring/feature_journey_ports.dart'
    show
        journeyBudgetPortProvider,
        journeyRoutingPortProvider,
        journeyTariffPortProvider;
