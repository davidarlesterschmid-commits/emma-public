import 'package:domain_employer_mobility/domain_employer_mobility.dart';
import 'package:flutter/material.dart';

/// Schaltet zwischen [UserMode.private] und [UserMode.employer].
///
/// Persistenz- und Selektions-Logik (z. B. Riverpod) kommt von aussen.
class ProfileModeSwitch extends StatelessWidget {
  const ProfileModeSwitch({
    super.key,
    required this.isLoading,
    this.error,
    this.profileMode,
    required this.selectedMode,
    required this.onSelectPrivate,
    this.onSelectEmployer,
  });

  final bool isLoading;
  final Object? error;
  final ProfileMode? profileMode;
  final UserMode selectedMode;
  final VoidCallback onSelectPrivate;
  final VoidCallback? onSelectEmployer;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (error != null) {
      return Text('Error: $error');
    }
    final mode = profileMode;
    if (mode == null) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            label: 'Privat',
            isSelected: selectedMode == UserMode.private,
            onTap: onSelectPrivate,
          ),
          const SizedBox(width: 8),
          _ModeButton(
            label: 'Arbeitgeber',
            isSelected: selectedMode == UserMode.employer,
            onTap: mode.isEmployerModeAvailable
                ? () {
                    onSelectEmployer?.call();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'DSGVO-Hinweis: Ihre Daten werden entsprechend behandelt.',
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
