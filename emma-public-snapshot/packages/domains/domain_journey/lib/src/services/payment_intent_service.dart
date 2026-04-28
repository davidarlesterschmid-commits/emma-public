import 'package:domain_journey/src/entities/booking_intent.dart';
import 'package:domain_journey/src/entities/fare_decision.dart';
import 'package:domain_journey/src/entities/payment_intent.dart';

class PaymentIntentService {
  const PaymentIntentService();

  PaymentIntent buildIntent({
    required String journeyId,
    required BookingIntent bookingIntent,
    required FareDecision fareDecision,
  }) {
    final employerAmount = fareDecision.budgetImpactEuro;
    final privateAmount = (fareDecision.totalPriceEuro - employerAmount).clamp(
      0.0,
      fareDecision.totalPriceEuro,
    );

    return PaymentIntent(
      paymentIntentId: 'payment-intent-$journeyId',
      journeyId: journeyId,
      bookingIntentId: bookingIntent.bookingIntentId,
      amountTotalEuro: fareDecision.totalPriceEuro,
      amountPrivateEuro: privateAmount,
      amountEmployerEuro: employerAmount,
      paymentMethodRef: employerAmount > 0
          ? 'mobility_budget_primary'
          : 'private_default_method',
      receiptDraft: ReceiptDraft(
        receiptId: 'receipt-draft-$journeyId',
        title: 'Journey $journeyId',
        lineItems: fareDecision.priceBreakdown
            .map(
              (item) =>
                  '${item.label}: ${item.amountEuro.toStringAsFixed(2)} EUR',
            )
            .toList(),
      ),
      paymentStatus: bookingIntent.bookingStatus == 'READY_FOR_CONFIRMATION'
          ? 'PREPARED'
          : 'PENDING_REVIEW',
      handoffRequired: true,
    );
  }
}
