import 'package:emma_app/bootstrap/app_environment.dart';
import 'package:emma_app/bootstrap/bootstrap.dart';

/// Dev-flavor entry point. Goes through the shared [bootstrap]
/// so Riverpod, GoRouter and AppEnvironment wiring stay identical
/// to integration and production flavors.
Future<void> main() {
  return bootstrap(
    const AppEnvironment(
      flavor: AppFlavor.dev,
      apiBaseUrl: 'http://localhost:8080',
    ),
  );
}
