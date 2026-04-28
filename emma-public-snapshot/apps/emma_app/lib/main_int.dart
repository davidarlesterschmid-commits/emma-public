import 'package:emma_app/bootstrap/app_environment.dart';
import 'package:emma_app/bootstrap/bootstrap.dart';

Future<void> main() {
  return bootstrap(
    const AppEnvironment(
      flavor: AppFlavor.integration,
      apiBaseUrl: 'http://localhost:8081',
    ),
  );
}
