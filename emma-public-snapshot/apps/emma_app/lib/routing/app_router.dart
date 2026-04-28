import 'package:domain_journey/domain_journey.dart';
import 'package:emma_app/composition/journey_screen.dart';
import 'package:emma_app/composition/journey_search_screen.dart';
import 'package:emma_app/core/journey_providers.dart';
import 'package:emma_app/features/account/presentation/screens/invoice_list_screen.dart';
import 'package:emma_app/features/account/presentation/screens/profile_screen.dart';
import 'package:emma_app/features/auth/presentation/screens/login_screen.dart';
import 'package:emma_app/features/home/presentation/screens/home_screen.dart';
import 'package:emma_app/features/settings_consent/presentation/screens/consent_detail_screen.dart';
import 'package:emma_app/features/settings_consent/presentation/screens/settings_consent_screen.dart';
import 'package:emma_app/features/trips/domain/entities/trip.dart';
import 'package:emma_app/features/trips/presentation/screens/trip_detail_screen.dart';
import 'package:emma_app/features/ticketing/presentation/ticketing_catalog_host.dart';
import 'package:emma_app/features/prep_e2e/presentation/screens/prep_e2e_result_placeholder_screen.dart';
import 'package:emma_app/features/prep_e2e/presentation/screens/prep_e2e_routing_options_screen.dart';
import 'package:emma_app/features/prep_e2e/presentation/screens/prep_e2e_wallet_simulation_screen.dart';
import 'package:emma_app/features/trips/presentation/screens/trip_search_screen.dart';
import 'package:emma_app/routing/app_routes.dart';
import 'package:feature_journey/feature_journey.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Canonical emma app router.
///
/// Owns the route tree and the error page. Accepts an explicit
/// [initialLocation] so tests can bypass the default home screen.
GoRouter buildAppRouter({String initialLocation = AppRoutes.home}) {
  return GoRouter(
    initialLocation: initialLocation,
    debugLogDiagnostics: false,
    errorBuilder: (context, state) => _RouterErrorScreen(error: state.error),
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.account,
        name: 'account',
        builder: (context, state) => const ProfileScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'invoices',
            name: 'account-invoices',
            builder: (context, state) => const InvoiceListScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.ticketing,
        name: 'ticketing',
        builder: (context, state) => const TicketingCatalogHost(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsConsentScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'consent',
            name: 'consent',
            builder: (context, state) => const ConsentDetailScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.journey,
        name: 'journey',
        builder: (context, state) => const AppJourneySearchScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'detail',
            name: 'journey-detail',
            builder: (context, state) => _JourneyOptionDetailHost(
              option: state.extra as TravelOption,
            ),
          ),
          GoRoute(
            path: 'mvp',
            name: 'journey-mvp',
            builder: (context, state) => const JourneyScreen(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.trips,
        name: 'trips',
        builder: (context, state) => const TripSearchScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'detail',
            name: 'trip-detail',
            builder: (context, state) => TripDetailScreen(
              trip: state.extra as Trip,
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.prepE2eRouting,
        name: 'prep-e2e-routing',
        builder: (context, state) => const PrepE2eRoutingOptionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.prepE2eWallet,
        name: 'prep-e2e-wallet',
        builder: (context, state) => const PrepE2eWalletSimulationScreen(),
      ),
      GoRoute(
        path: AppRoutes.prepE2eResult,
        name: 'prep-e2e-result',
        builder: (context, state) => const PrepE2eResultPlaceholderScreen(),
      ),
    ],
  );
}

class _JourneyOptionDetailHost extends ConsumerWidget {
  const _JourneyOptionDetailHost({required this.option});

  final TravelOption option;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return JourneyOptionDetailScreen(
      option: option,
      onConfirm: () async {
        await ref.read(journeyCaseProvider.notifier).selectTravelOption(option);
        if (!context.mounted) return;
        context.go(AppRoutes.journeyMvp);
      },
    );
  }
}

class _RouterErrorScreen extends StatelessWidget {
  const _RouterErrorScreen({required this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route nicht gefunden')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            error?.toString() ?? 'Diese Route existiert nicht.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

