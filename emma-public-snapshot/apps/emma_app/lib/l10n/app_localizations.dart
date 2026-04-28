import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Minimal localization scaffold.
///
/// This repository currently runs `dart analyze` (not `flutter gen-l10n`) in CI.
/// The app code references `package:emma_app/l10n/app_localizations.dart`.
/// Keeping a small hand-written implementation avoids analyzer failures.
///
/// Replace with generated code once l10n generation is wired.
class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  // Strings currently used in the app/widgets/tests.
  String get appTitle => 'emma';
  String get settingsScreenTitle => 'Einstellungen';
  String get consentScreenAppBar => 'Datenschutz & Einwilligungen';
  String get settingsEmptyHint =>
      'Es sind noch keine weiteren Einstellungen hinterlegt. Du kannst Einwilligungen unten anpassen.';
  String get openConsentAction => 'Zu Einwilligungen wechseln';
  String get consentToggleAnalytics => 'Nutzungsanalyse (Stub)';
  String get consentToggleMarketing => 'Personalisierung / Marketing (Stub)';
  String get errorRetry => 'Erneut versuchen';
  String get errorUnknown => 'Unbekannter Fehler';
  String get profileListSettings => 'Einstellungen';
  String get semanticsSettingsLoading => 'Einstellungen werden geladen';
  String get semanticsConsentLoading => 'Einwilligungen werden geladen';
  String get semanticsError => 'Fehler';
  String get semanticsToggles => 'Einwilligungen, Schalter';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => const <String>['de', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
