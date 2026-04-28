import 'dart:convert';

import 'package:domain_journey/contracts.dart';
import 'package:domain_journey/domain_journey.dart';
import 'package:domain_ticketing/domain_ticketing.dart';
import 'package:feature_ticketing/feature_ticketing.dart';
import 'package:flutter/material.dart';

/// Stateless rendering of a single [JourneyState].
///
/// Pure presentation over `domain_journey` entities and the optional
/// 5-phase contract bundle. The widget holds no Riverpod or repository
/// dependencies so it can be reused by any shell (app, preview harness,
/// storybook) that can provide a `JourneyState`.
class JourneyStepWidget extends StatelessWidget {
  const JourneyStepWidget({
    super.key,
    required this.state,
    this.onConfirmBooking,
  });

  final JourneyState state;
  final VoidCallback? onConfirmBooking;

  @override
  Widget build(BuildContext context) {
    final current = state.currentPhaseState;
    final theme = Theme.of(context);
    final blueprintEncoder = const JsonEncoder.withIndent('  ');
    final contractBundle = state.contractBundle;

    if (current.phase == JourneyPhase.transaction) {
      return _buildTransactionPhase(context);
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _JourneyHeroCard(state: state, current: current),
        const SizedBox(height: 20),
        Text(
          'Phase ${current.phase.phaseNumber}: ${current.phase.title}',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          current.description,
          style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
        ),
        if (current.trustLayer != null) ...[
          const SizedBox(height: 20),
          _TrustLayerSection(card: current.trustLayer!),
        ],
        const SizedBox(height: 20),
        _SectionCard(
          title: 'Blueprint JSON',
          child: SelectableText(
            blueprintEncoder.convert(current.blueprint),
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          title: '8-Phasen-Orchestrierung',
          child: Column(
            children: state.phases
                .map((phase) => _PhaseTimelineTile(phase: phase))
                .toList(),
          ),
        ),
        if (contractBundle != null) ...[
          const SizedBox(height: 20),
          _SectionCard(
            title: '5-Phasen-Contract',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: 'Current',
                  value: contractBundle
                      .orchestratorResult
                      .currentPhase
                      .schemaValue,
                ),
                _InfoRow(
                  label: 'Next',
                  value:
                      contractBundle
                          .orchestratorResult
                          .nextPhase
                          ?.schemaValue ??
                      'Keine',
                ),
                const SizedBox(height: 12),
                ...contractBundle.contractToUxMapping.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _InfoRow(
                      label: entry.key,
                      value: entry.value.join(', '),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        _SectionCard(
          title: 'Governance',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _InfoRow(
                label: 'Mission',
                value: state.context['mission']?.toString() ?? '-',
              ),
              _InfoRow(
                label: 'IP',
                value:
                    (state.context['governance']
                            as Map<String, dynamic>?)?['ip_owner']
                        ?.toString() ??
                    '-',
              ),
              _InfoRow(
                label: 'Betrieb',
                value:
                    (state.context['governance']
                            as Map<String, dynamic>?)?['operational_partner']
                        ?.toString() ??
                    '-',
              ),
              _InfoRow(
                label: 'Haftung',
                value:
                    (state.context['governance']
                            as Map<String, dynamic>?)?['liability_model']
                        ?.toString() ??
                    '-',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionPhase(BuildContext context) {
    final status = state.context['journey_status']?.toString() ?? 'unknown';
    final fareDecisionJson = state.context['fare_decision'] as Map<String, dynamic>?;

    final items = <TicketingLineItem>[];
    int totalCents = 0;

    if (fareDecisionJson != null) {
      final breakdown = fareDecisionJson['price_breakdown'] as List?;
      if (breakdown != null) {
        for (final item in breakdown) {
          final map = item as Map<String, dynamic>;
          final amountEuro = (map['amount_euro'] as num).toDouble();
          final cents = (amountEuro * 100).round();
          items.add(TicketingLineItem(
            label: map['label'] as String,
            priceEuroCents: cents,
            source: _mapSource(map['source'] as String),
          ));
          totalCents += cents;
        }
      }
    }

    final bundle = BookingBundle(
      bundleId: 'bundle-${state.id}',
      journeyId: state.id,
      items: items,
      totalPriceEuroCents: totalCents,
      currency: 'EUR',
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _JourneyHeroCard(state: state, current: state.currentPhaseState),
        const SizedBox(height: 20),
        BookingFulfillmentView(
          bundle: bundle,
          status: status,
          onConfirm: onConfirmBooking,
        ),
      ],
    );
  }

  TicketingPriceSource _mapSource(String source) {
    switch (source) {
      case 'tariff_m11': return TicketingPriceSource.emmaRuleEngine;
      case 'mobility_budget': return TicketingPriceSource.employerBudgetOnly;
      default: return TicketingPriceSource.operatorPublished;
    }
  }
}

class _JourneyHeroCard extends StatelessWidget {
  const _JourneyHeroCard({required this.state, required this.current});

  final JourneyState state;
  final JourneyPhaseState current;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final event = state.events.first;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF063B2D), Color(0xFF14795D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              'emma als Mobilitaetsabwicklungsinstanz',
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            current.headline,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            current.phase.mission,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome, color: Color(0xFF14795D)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${event.title} ${event.timestampLabel}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        event.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustLayerSection extends StatelessWidget {
  const _TrustLayerSection({required this.card});

  final TrustLayerCard card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionCard(
      title: 'Trust Layer',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(label: card.type),
              _Badge(label: card.primaryCta),
            ],
          ),
          const SizedBox(height: 14),
          ...card.summaryItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _InfoRow(label: item.label, value: item.value),
            ),
          ),
          if (card.legalText != null) ...[
            const SizedBox(height: 8),
            Text(
              card.legalText!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF8A4B08),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhaseTimelineTile extends StatelessWidget {
  const _PhaseTimelineTile({required this.phase});

  final JourneyPhaseState phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (phase.status) {
      JourneyPhaseStatus.completed => const Color(0xFF14795D),
      JourneyPhaseStatus.active => const Color(0xFF0057D8),
      JourneyPhaseStatus.risk => const Color(0xFFD97706),
      JourneyPhaseStatus.upcoming => const Color(0xFF6B7280),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${phase.phase.phaseNumber}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        phase.phase.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _Badge(label: phase.status.label, color: color),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  phase.headline,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                ),
                if (phase.riskHint != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    phase.riskHint!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFD97706),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.color = const Color(0xFF0F766E)});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
