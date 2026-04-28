import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:emma_app/features/tariff_rules/domain/entities/tariff_rule.dart';
import 'package:emma_app/features/tariff_rules/domain/repositories/tariff_repository.dart';
import 'package:emma_app/features/tariff_rules/data/repositories/tariff_repository_impl.dart';

final tariffRepositoryProvider = Provider<TariffRepository>((ref) {
  return TariffRepositoryImpl();
});

final availableTariffsProvider = FutureProvider<List<TariffRule>>((ref) {
  final repo = ref.watch(tariffRepositoryProvider);
  return repo.getAvailableTariffs();
});
