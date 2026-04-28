import 'package:domain_wallet/domain_wallet.dart';

class FakeWalletSnapshotPort implements WalletSnapshotPort {
  const FakeWalletSnapshotPort();

  @override
  Future<WalletSnapshot> loadSnapshot() async {
    return WalletSnapshot(
      walletId: 'wallet-demo',
      budget: MobilityBudget(
        totalBudget: 58,
        usedAmount: 12,
        remainingAmount: 46,
        billingPeriodStart: DateTime.utc(2026, 4),
        billingPeriodEnd: DateTime.utc(2026, 4, 30),
        currency: 'EUR',
      ),
      paymentGateStatus: PaymentGateStatus.pspGateRequired,
      gateNote: 'Payment/PSP Gate erforderlich / nicht implementiert',
    );
  }
}
