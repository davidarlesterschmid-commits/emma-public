/// Single partner-side action required to fulfil a [BookingIntent].
class BookingAction {
  const BookingAction({
    required this.provider,
    required this.action,
    required this.critical,
  });

  final String provider;
  final String action;
  final bool critical;

  Map<String, dynamic> toJson() {
    return {'provider': provider, 'action': action, 'critical': critical};
  }
}

/// emma's internal booking authorisation: everything that must happen
/// to turn a selected travel option into confirmed bookings.
class BookingIntent {
  const BookingIntent({
    required this.bookingIntentId,
    required this.journeyId,
    required this.optionId,
    required this.requiredActions,
    required this.partnerActions,
    required this.bookingStatus,
    required this.blockingReasons,
    required this.handoffRequired,
  });

  final String bookingIntentId;
  final String journeyId;
  final String optionId;
  final List<String> requiredActions;
  final List<BookingAction> partnerActions;
  final String bookingStatus;
  final List<String> blockingReasons;
  final bool handoffRequired;

  Map<String, dynamic> toJson() {
    return {
      'booking_intent_id': bookingIntentId,
      'journey_id': journeyId,
      'option_id': optionId,
      'required_actions': requiredActions,
      'partner_actions': partnerActions
          .map((action) => action.toJson())
          .toList(),
      'booking_status': bookingStatus,
      'blocking_reasons': blockingReasons,
      'handoff_required': handoffRequired,
    };
  }
}
