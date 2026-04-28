import 'package:emma_app/features/home/domain/assistant_intake/assistant_intake_models.dart';
import 'package:flutter/material.dart';

/// Zeigt kodierte Reise-Intake-Felder — nur Anzeige, keine Validierung/Logik.
class StructuredIntakePreviewCard extends StatelessWidget {
  const StructuredIntakePreviewCard({super.key, required this.result});

  final AssistantIntakeResult? result;

  @override
  Widget build(BuildContext context) {
    if (result == null || !result!.isTravelIntent) {
      return const SizedBox.shrink();
    }

    final r = result!;
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Kontext (UI-Entwurf)',
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            if (r.journeyReadyInput != null) ...[
              const SizedBox(height: 4),
              _Line(
                label: 'Von',
                value: r.journeyReadyInput!.origin,
              ),
              _Line(
                label: 'Nach',
                value: r.journeyReadyInput!.destination,
              ),
            ] else if (r.structuredRequest != null) ...[
              const SizedBox(height: 4),
              if (r.structuredRequest!.origin != null)
                _Line(
                  label: 'Von',
                  value: r.structuredRequest!.origin!,
                ),
              if (r.structuredRequest!.destination != null)
                _Line(
                  label: 'Nach',
                  value: r.structuredRequest!.destination!,
                ),
              if (r.structuredRequest!.targetDateHint.isNotEmpty)
                _Line(
                  label: 'Zeit/Tag',
                  value: r.structuredRequest!.targetDateHint,
                ),
            ],
            if (r.missingRequiredFields.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Fehlend (Intake): ${r.missingRequiredFields.join(", ")}',
                style: const TextStyle(fontSize: 12, height: 1.2),
              ),
            ],
            const SizedBox(height: 4),
            const Text(
              'Übergabe an Domäne folgt; hier nur sichtbares Strukturmodell',
              style: TextStyle(fontSize: 11.5, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12.5, height: 1.3),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
