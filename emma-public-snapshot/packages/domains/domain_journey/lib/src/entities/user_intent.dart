class UserIntent {
  const UserIntent({
    required this.intentId,
    required this.userId,
    required this.source,
    required this.rawText,
    required this.origin,
    required this.destination,
    required this.targetArrivalTime,
    required this.tripPurpose,
    required this.preferencesSnapshot,
    required this.needsClarification,
  });

  final String intentId;
  final String userId;
  final String source;
  final String rawText;
  final String origin;
  final String destination;
  final DateTime targetArrivalTime;
  final String tripPurpose;
  final Map<String, dynamic> preferencesSnapshot;
  final bool needsClarification;

  UserIntent copyWith({
    String? intentId,
    String? userId,
    String? source,
    String? rawText,
    String? origin,
    String? destination,
    DateTime? targetArrivalTime,
    String? tripPurpose,
    Map<String, dynamic>? preferencesSnapshot,
    bool? needsClarification,
  }) {
    return UserIntent(
      intentId: intentId ?? this.intentId,
      userId: userId ?? this.userId,
      source: source ?? this.source,
      rawText: rawText ?? this.rawText,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      targetArrivalTime: targetArrivalTime ?? this.targetArrivalTime,
      tripPurpose: tripPurpose ?? this.tripPurpose,
      preferencesSnapshot: preferencesSnapshot ?? this.preferencesSnapshot,
      needsClarification: needsClarification ?? this.needsClarification,
    );
  }
}
