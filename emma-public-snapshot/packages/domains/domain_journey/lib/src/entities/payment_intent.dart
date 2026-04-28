/// Draft receipt attached to a [PaymentIntent].
class ReceiptDraft {
  const ReceiptDraft({
    required this.receiptId,
    required this.title,
    required this.lineItems,
  });

  final String receiptId;
  final String title;
  final List<String> lineItems;

  Map<String, dynamic> toJson() {
    return {'receipt_id': receiptId, 'title': title, 'line_items': lineItems};
  }
}

/// Split of the total amount between the private wallet and the
/// employer mobility budget, plus the receipt the PSP must emit.
class PaymentIntent {
  const PaymentIntent({
    required this.paymentIntentId,
    required this.journeyId,
    required this.bookingIntentId,
    required this.amountTotalEuro,
    required this.amountPrivateEuro,
    required this.amountEmployerEuro,
    required this.paymentMethodRef,
    required this.receiptDraft,
    required this.paymentStatus,
    required this.handoffRequired,
  });

  final String paymentIntentId;
  final String journeyId;
  final String bookingIntentId;
  final double amountTotalEuro;
  final double amountPrivateEuro;
  final double amountEmployerEuro;
  final String paymentMethodRef;
  final ReceiptDraft receiptDraft;
  final String paymentStatus;
  final bool handoffRequired;

  Map<String, dynamic> toJson() {
    return {
      'payment_intent_id': paymentIntentId,
      'journey_id': journeyId,
      'booking_intent_id': bookingIntentId,
      'amount_total_euro': amountTotalEuro,
      'amount_private_euro': amountPrivateEuro,
      'amount_employer_euro': amountEmployerEuro,
      'payment_method_ref': paymentMethodRef,
      'receipt_draft': receiptDraft.toJson(),
      'payment_status': paymentStatus,
      'handoff_required': handoffRequired,
    };
  }
}
