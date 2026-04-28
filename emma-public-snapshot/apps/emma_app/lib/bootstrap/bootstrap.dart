import 'package:emma_app/bootstrap/app_environment.dart';
import 'package:emma_app/bootstrap/provider_overrides.dart';
import 'package:emma_app/composition/emma_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Single entry point for every flavor.
///
/// Responsibilities:
/// * Ensure Flutter bindings are ready.
/// * Wrap the app in a [ProviderScope] with:
///     - [appEnvironmentProvider] bound to the caller-supplied
///       [AppEnvironment], so Dio/timeouts resolve from one source.
///     - [buildAppProviderOverrides] — shared infra, Journey-, Employer- und
///       Port-Overrides (siehe [provider_overrides.dart]).
Future<void> bootstrap(AppEnvironment environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      overrides: buildAppProviderOverrides(environment),
      child: const EmmaApp(),
    ),
  );
}
