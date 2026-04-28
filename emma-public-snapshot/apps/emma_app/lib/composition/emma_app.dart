import 'package:emma_app/l10n/app_localizations.dart';
import 'package:emma_app/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Root composition widget of the emma app.
///
/// Holds the [MaterialApp.router] and the [GoRouter] instance.
/// Environment, Dio and all feature providers are wired via Riverpod
/// higher up — see `bootstrap/bootstrap.dart`.
class EmmaApp extends StatefulWidget {
  const EmmaApp({super.key, this.initialLocation});

  /// Optional initial location override (used by tests).
  final String? initialLocation;

  @override
  State<EmmaApp> createState() => _EmmaAppState();
}

class _EmmaAppState extends State<EmmaApp> {
  late final GoRouter _router = buildAppRouter(
    initialLocation: widget.initialLocation ?? '/',
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF005F73)),
        useMaterial3: true,
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
