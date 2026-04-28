import 'package:domain_journey/src/contracts/common/contract_enums.dart';
import 'package:domain_journey/src/contracts/common/contract_models.dart';

Map<String, dynamic> _map(Object? input) =>
    Map<String, dynamic>.from(input as Map? ?? const {});

class EmmaPhaseEnvelope {
  const EmmaPhaseEnvelope({
    required this.schemaVersion,
    required this.messageType,
    required this.phase,
    required this.producer,
    required this.generatedAt,
    required this.caseKeys,
    required this.phaseMeta,
    required this.payload,
    required this.error,
    required this.auditEntry,
  });

  factory EmmaPhaseEnvelope.fromJson(Map<String, dynamic> json) {
    return EmmaPhaseEnvelope(
      schemaVersion: json['schema_version']?.toString() ?? 'emma.message.v1',
      messageType: EmmaMessageType.phaseResult,
      phase: EmmaPhase.fromValue(
        json['phase']?.toString() ?? EmmaPhase.phase1.value,
      ),
      producer: json['producer']?.toString() ?? '',
      generatedAt: DateTime.parse(json['generated_at'].toString()),
      caseKeys: EmmaCaseKeys.fromJson(_map(json['case_keys'])),
      phaseMeta: EmmaPhaseMeta.fromJson(_map(json['phase_meta'])),
      payload: _map(json['payload']),
      error: EmmaErrorBlock.fromJson(_map(json['error'])),
      auditEntry: EmmaAuditEntry.fromJson(_map(json['audit_entry'])),
    );
  }

  final String schemaVersion;
  final EmmaMessageType messageType;
  final EmmaPhase phase;
  final String producer;
  final DateTime generatedAt;
  final EmmaCaseKeys caseKeys;
  final EmmaPhaseMeta phaseMeta;
  final Map<String, dynamic> payload;
  final EmmaErrorBlock error;
  final EmmaAuditEntry auditEntry;

  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'message_type': messageType.value,
      'phase': phase.value,
      'producer': producer,
      'generated_at': generatedAt.toIso8601String(),
      'case_keys': caseKeys.toJson(),
      'phase_meta': phaseMeta.toJson(),
      'payload': payload,
      'error': error.toJson(),
      'audit_entry': auditEntry.toJson(),
    };
  }
}
