import 'package:domain_journey/src/entities/booking_intent.dart';
import 'package:domain_journey/src/entities/fare_decision.dart';
import 'package:domain_journey/src/entities/travel_option.dart';

class BookingIntentService {
  const BookingIntentService();

  BookingIntent buildIntent({
    required String journeyId,
    required TravelOption selectedOption,
    required FareDecision fareDecision,
  }) {
    final actions = <BookingAction>[
      for (final leg in selectedOption.legs)
        BookingAction(
          provider: leg.provider,
          action: leg.mode == 'rail'
              ? 'ISSUE_TICKET'
              : 'RESERVE_${leg.mode.toUpperCase()}',
          critical: true,
        ),
    ];

    return BookingIntent(
      bookingIntentId: 'booking-intent-$journeyId',
      journeyId: journeyId,
      optionId: selectedOption.optionId,
      requiredActions: actions
          .map((action) => action.action.toLowerCase())
          .toList(),
      partnerActions: actions,
      bookingStatus: fareDecision.decisionStatus == 'APPROVED'
          ? 'READY_FOR_CONFIRMATION'
          : 'REVIEW_REQUIRED',
      blockingReasons: fareDecision.decisionStatus == 'APPROVED'
          ? const []
          : const ['fare_decision_requires_review'],
      handoffRequired: selectedOption.requiresPartnerBooking,
    );
  }
}
