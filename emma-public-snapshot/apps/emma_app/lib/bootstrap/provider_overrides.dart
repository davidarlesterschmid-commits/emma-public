import 'package:adapter_gemini/adapter_gemini.dart';
import 'package:adapter_maps/adapter_maps.dart';
import 'package:adapter_trias/adapter_trias.dart';
import 'package:emma_app/bootstrap/app_environment.dart';
import 'package:emma_app/core/config/app_config.dart';
import 'package:emma_app/core/employer_providers.dart'
    show
        budgetRepositoryProvider,
        employerDioProvider,
        employerSecureStorageProvider;
import 'package:emma_app/core/infra_providers.dart';
import 'package:emma_app/features/tariff_rules/data/repositories/tariff_repository_impl.dart';
import 'package:emma_contracts/emma_contracts.dart'
    show ChatPort, DirectionsPort, PoiSearchPort, RoutingPort;
import 'package:fake_chat/fake_chat.dart';
import 'package:fake_maps/fake_maps.dart';
import 'package:feature_journey/feature_journey.dart'
    show
        JourneyRepositoryImpl,
        journeyBudgetPortProvider,
        journeyRepositoryProvider,
        journeyRoutingPortProvider,
        journeyTariffPortProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

/// Shared [ProviderScope] overrides for production [bootstrap] and tests.
///
/// [journeyRoutingForTests] ersetzt den TRIAS-Adapter durch einen Fake
/// (z. B. in Widget-Tests) — **eine** Override-Regel, kein Doppel-Override.
List<Override> buildAppProviderOverrides(
  AppEnvironment environment, {
  RoutingPort? journeyRoutingForTests,
}) {
  return <Override>[
    appEnvironmentProvider.overrideWithValue(environment),
    employerDioProvider.overrideWith((ref) => ref.watch(dioProvider)),
    employerSecureStorageProvider.overrideWith(
      (ref) => ref.watch(secureStorageProvider),
    ),
    journeyTariffPortProvider.overrideWith((ref) => TariffRepositoryImpl()),
    journeyRoutingPortProvider.overrideWith(
      (ref) =>
          journeyRoutingForTests ??
          (AppConfig.useFakes
              ? const FakeJourneyRoutingAdapter()
              : TriasRoutingPort(TriasService())),
    ),
    journeyBudgetPortProvider.overrideWith(
      (ref) => ref.watch(budgetRepositoryProvider),
    ),
    // Wire concrete repository (Task #37 — app shell owns provider impl).
    journeyRepositoryProvider.overrideWith((ref) {
      // Resolve ports after [journeyTariff] / [journeyRouting] overrides above.
      return JourneyRepositoryImpl(
        budgetPort: ref.watch(budgetRepositoryProvider),
        tariffPort: ref.watch(journeyTariffPortProvider),
        routingPort: ref.watch(journeyRoutingPortProvider),
      );
    }),
    directionsPortProvider.overrideWith(_resolveDirectionsPort),
    chatPortProvider.overrideWith(_resolveChatPort),
    poiSearchPortProvider.overrideWith(_resolvePoiSearchPort),
  ];
}

DirectionsPort _resolveDirectionsPort(Ref ref) {
  if (AppConfig.useFakes) {
    return const FakeDirectionsAdapter();
  }
  if (AppConfig.googleMapsApiKey.isNotEmpty) {
    return GoogleMapsDirectionsAdapter(apiKey: AppConfig.googleMapsApiKey);
  }
  return DirectionsOpenDataAdapter(
    nominatimBaseUrl: AppConfig.nominatimBaseUrl,
    osrmBaseUrl: AppConfig.osrmBaseUrl,
    userAgent: AppConfig.nominatimUserAgent,
  );
}

ChatPort _resolveChatPort(Ref ref) {
  if (AppConfig.useFakes) {
    return const FakeChatAdapter();
  }
  return GeminiChatAdapter(apiKey: AppConfig.geminiApiKey);
}

PoiSearchPort _resolvePoiSearchPort(Ref ref) {
  if (AppConfig.useFakes) {
    return const FakePoiSearchAdapter();
  }
  return PoiNominatimAdapter(
    baseUrl: AppConfig.nominatimBaseUrl,
    userAgent: AppConfig.nominatimUserAgent,
  );
}
