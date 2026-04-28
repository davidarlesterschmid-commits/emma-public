/// A user's routing request: where they want to go and under what conditions.
class JourneyIntent {
  const JourneyIntent({
    required this.origin,
    required this.destination,
    this.requiresGuarantee = false,
  });

  /// Human-readable or stop-ID origin (e.g. "Leipzig Hbf").
  final String origin;

  /// Human-readable or stop-ID destination (e.g. "Berlin Hbf").
  final String destination;

  /// Whether the user requires a mobility guarantee for this journey.
  final bool requiresGuarantee;
}
