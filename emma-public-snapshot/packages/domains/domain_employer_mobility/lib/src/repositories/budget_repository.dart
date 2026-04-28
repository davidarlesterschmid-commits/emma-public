import 'package:domain_wallet/domain_wallet.dart';
import 'package:emma_contracts/emma_contracts.dart';

/// Arbeitgeber-seitiges Budget-Repository.
///
/// Erweitert den [BudgetPort] aus [package:emma_contracts/emma_contracts.dart]
/// um employer-spezifische Operationen. Damit bleibt der Journey-Engine-
/// Konsument (`JourneyRepositoryImpl`) an den schmalen [BudgetPort]
/// gekoppelt, während die Employer-Feature-UI die erweiterte
/// `refreshBudget`-Operation nutzen kann.
abstract interface class BudgetRepository implements BudgetPort {
  @override
  Future<MobilityBudget> getBudget();

  /// Erzwingt einen erneuten Abruf aus der führenden Quelle.
  Future<void> refreshBudget();
}
