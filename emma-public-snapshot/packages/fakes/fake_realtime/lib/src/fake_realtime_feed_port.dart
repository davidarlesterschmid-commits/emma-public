import 'package:domain_realtime/domain_realtime.dart';

class FakeRealtimeFeedPort implements RealtimeFeedPort {
  const FakeRealtimeFeedPort();

  @override
  Future<List<RealtimeAlert>> alertsForJourney(String journeyId) async {
    return <RealtimeAlert>[
      RealtimeAlert(
        id: 'alert-demo-1',
        journeyId: journeyId,
        message: 'Demo delay, no live feed connected',
        severity: RealtimeAlertSeverity.warning,
        observedAt: DateTime.utc(2026, 4, 24, 8),
      ),
    ];
  }
}
