/// 8-phase emma journey lifecycle.
///
/// Encodes the emma master model: every customer journey is evaluated
/// against these eight phases. Labels are intentionally DE for the
/// current MVP audience; i18n comes via the presentation layer.
enum JourneyPhase {
  demandRecognition,
  intentValidation,
  orchestration,
  fareOptimization,
  transaction,
  activeMonitoring,
  crisisManagement,
  optimization,
}

extension JourneyPhaseX on JourneyPhase {
  int get phaseNumber => index + 1;

  String get title {
    switch (this) {
      case JourneyPhase.demandRecognition:
        return 'Bedarfserkennung';
      case JourneyPhase.intentValidation:
        return 'Mobilitaetsanlass';
      case JourneyPhase.orchestration:
        return 'Reiseplanung';
      case JourneyPhase.fareOptimization:
        return 'Tarifwahl';
      case JourneyPhase.transaction:
        return 'Buchung';
      case JourneyPhase.activeMonitoring:
        return 'Reisebegleitung';
      case JourneyPhase.crisisManagement:
        return 'Stoerfallmanagement';
      case JourneyPhase.optimization:
        return 'Abschluss';
    }
  }

  String get shortLabel => 'Phase $phaseNumber';

  String get mission {
    switch (this) {
      case JourneyPhase.demandRecognition:
        return 'Proaktiv erkennen, dass Mobilitaetsbedarf entsteht.';
      case JourneyPhase.intentValidation:
        return 'Anlass, Ziel und Verbindlichkeit absichern.';
      case JourneyPhase.orchestration:
        return 'Optionen nach Garantie, Zuverlaessigkeit und Budget kuratieren.';
      case JourneyPhase.fareOptimization:
        return 'Tarife, Bestandstickets und Arbeitgeberlogik kombinieren.';
      case JourneyPhase.transaction:
        return 'Rechtssichere Ausloesung ueber den Trust Layer.';
      case JourneyPhase.activeMonitoring:
        return 'Reise aktiv begleiten und Engpaesse antizipieren.';
      case JourneyPhase.crisisManagement:
        return 'Mobilitaetsgarantie und Ersatzmassnahmen aktivieren.';
      case JourneyPhase.optimization:
        return 'Reporting, Lernen und kaufmaennische Nachbereitung abschliessen.';
    }
  }
}

enum JourneyPhaseStatus { completed, active, upcoming, risk }

extension JourneyPhaseStatusX on JourneyPhaseStatus {
  String get label {
    switch (this) {
      case JourneyPhaseStatus.completed:
        return 'Abgeschlossen';
      case JourneyPhaseStatus.active:
        return 'Aktiv';
      case JourneyPhaseStatus.upcoming:
        return 'Vorbereitet';
      case JourneyPhaseStatus.risk:
        return 'Achtung';
    }
  }
}

class TrustLayerCard {
  const TrustLayerCard({
    required this.type,
    required this.primaryCta,
    required this.summaryItems,
    this.legalText,
    this.payload,
  });

  final String type;
  final String primaryCta;
  final List<TrustSummaryItem> summaryItems;
  final String? legalText;
  final Map<String, dynamic>? payload;
}

class TrustSummaryItem {
  const TrustSummaryItem({required this.label, required this.value});

  final String label;
  final String value;
}

class JourneyPhaseState {
  const JourneyPhaseState({
    required this.phase,
    required this.status,
    required this.headline,
    required this.description,
    required this.blueprint,
    this.trustLayer,
    this.riskHint,
  });

  final JourneyPhase phase;
  final JourneyPhaseStatus status;
  final String headline;
  final String description;
  final Map<String, dynamic> blueprint;
  final TrustLayerCard? trustLayer;
  final String? riskHint;

  JourneyPhaseState copyWith({
    JourneyPhase? phase,
    JourneyPhaseStatus? status,
    String? headline,
    String? description,
    Map<String, dynamic>? blueprint,
    TrustLayerCard? trustLayer,
    String? riskHint,
  }) {
    return JourneyPhaseState(
      phase: phase ?? this.phase,
      status: status ?? this.status,
      headline: headline ?? this.headline,
      description: description ?? this.description,
      blueprint: blueprint ?? this.blueprint,
      trustLayer: trustLayer ?? this.trustLayer,
      riskHint: riskHint ?? this.riskHint,
    );
  }
}

class JourneyEvent {
  const JourneyEvent({
    required this.title,
    required this.message,
    required this.timestampLabel,
    required this.isUser,
  });

  final String title;
  final String message;
  final String timestampLabel;
  final bool isUser;
}
