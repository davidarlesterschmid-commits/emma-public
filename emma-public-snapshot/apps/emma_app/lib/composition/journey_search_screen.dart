import 'package:domain_journey/domain_journey.dart';
import 'package:emma_app/routing/app_routes.dart';
import 'package:feature_journey/feature_journey.dart' show
    JourneySearchScreen, journeyRoutingPortProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// App-Shell-Wrapper um [JourneySearchScreen].
///
/// Reicht den per `ProviderScope` ueberschriebenen
/// [journeyRoutingPortProvider] durch und setzt den Navigations-Hook
/// auf die go_router-Route [AppRoutes.journeyDetail]. Damit bleibt
/// `feature_journey` frei von `go_router`- und Riverpod-Koppelungen in
/// den Screens selbst.
class AppJourneySearchScreen extends ConsumerWidget {
  const AppJourneySearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routingPort = ref.watch(journeyRoutingPortProvider);
    return JourneySearchScreen(
      routingPort: routingPort,
      onOptionSelected: (TravelOption option) {
        context.go(AppRoutes.journeyDetail, extra: option);
      },
    );
  }
}
