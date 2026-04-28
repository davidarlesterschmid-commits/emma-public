import 'package:emma_contracts/emma_contracts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Port-Bindungs-Kontrakt fuer `feature_journey`.
///
/// Die App-Shell uebergibt beim Bootstrap konkrete Implementierungen
/// aus Adaptern (z. B. `adapter_trias`) oder App-lokalen Repositories
/// fuer jede dieser Dependencies. Ohne Override wirft der Zugriff — das
/// ist beabsichtigt, damit fehlende Wirings frueh auffallen.

final journeyTariffPortProvider = Provider<TariffPort>((ref) {
  throw UnimplementedError(
    'journeyTariffPortProvider wurde nicht im ProviderScope ueberschrieben.'
    ' Die App-Shell muss eine TariffPort-Implementierung bereitstellen.',
  );
});

final journeyRoutingPortProvider = Provider<RoutingPort>((ref) {
  throw UnimplementedError(
    'journeyRoutingPortProvider wurde nicht im ProviderScope ueberschrieben.'
    ' Die App-Shell muss eine RoutingPort-Implementierung bereitstellen.',
  );
});

final journeyBudgetPortProvider = Provider<BudgetPort>((ref) {
  throw UnimplementedError(
    'journeyBudgetPortProvider wurde nicht im ProviderScope ueberschrieben.'
    ' Die App-Shell muss eine BudgetPort-Implementierung bereitstellen.',
  );
});
