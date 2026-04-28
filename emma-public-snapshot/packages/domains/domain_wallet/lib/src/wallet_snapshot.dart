import 'package:domain_wallet/src/entities/mobility_budget.dart';

enum PaymentGateStatus { simulationOnly, pspGateRequired }

class WalletSnapshot {
  const WalletSnapshot({
    required this.walletId,
    required this.budget,
    required this.paymentGateStatus,
    required this.gateNote,
  });

  final String walletId;
  final MobilityBudget budget;
  final PaymentGateStatus paymentGateStatus;
  final String gateNote;
}

abstract interface class WalletSnapshotPort {
  Future<WalletSnapshot> loadSnapshot();
}
