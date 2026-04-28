enum AppFlavor { dev, integration, production }

class AppEnvironment {
  const AppEnvironment({required this.flavor, required this.apiBaseUrl});

  final AppFlavor flavor;
  final String apiBaseUrl;

  String get label {
    switch (flavor) {
      case AppFlavor.dev:
        return 'dev';
      case AppFlavor.integration:
        return 'int';
      case AppFlavor.production:
        return 'prod';
    }
  }
}
