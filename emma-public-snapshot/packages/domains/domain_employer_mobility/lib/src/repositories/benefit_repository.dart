import '../entities/benefit.dart';

/// Quelle der Wahrheit für vermittelte Arbeitgeber-Benefits.
abstract interface class BenefitRepository {
  /// Listet Benefits. Wenn [inBudgetOnly] gesetzt ist, werden nur
  /// budgetrelevante Einträge zurückgeliefert.
  Future<List<Benefit>> getBenefits({bool inBudgetOnly = false});
}
