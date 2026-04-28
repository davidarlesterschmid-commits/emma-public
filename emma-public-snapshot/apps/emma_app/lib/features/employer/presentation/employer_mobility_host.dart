import 'package:emma_app/features/employer_mobility/presentation/screens/employer_mobility_screen_shell.dart';
import 'package:flutter/material.dart';

/// App route host: [EmployerMobilityScreenShell] mappt Riverpod → parameterisiertes UI.
class EmployerMobilityHost extends StatelessWidget {
  const EmployerMobilityHost({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmployerMobilityScreenShell();
  }
}
