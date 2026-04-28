/// Canonical route paths used by the emma app router.
///
/// Keep feature screens importing this file instead of spreading
/// raw string literals across the codebase — so rename/refactor
/// of a route stays a one-file change.
class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const login = '/login';
  static const account = '/account';

  /// Demo-Rechnungsliste (Fake-Account, USE_FAKES).
  static const accountInvoices = '/account/invoices';

  /// Ticketing-Katalog (M03, Fake im MVP-Default).
  static const ticketing = '/ticketing';

  /// Einstellungen & Einwilligungen (Stub).
  static const settings = '/settings';
  static const consent = '/settings/consent';

  /// Kanonische Routen fuer die Routing-Domaene (T3-Inkrement A).
  /// Konsumieren `feature_journey` + `adapter_trias` ueber den
  /// `journeyRoutingPortProvider`. [trips]/[tripDetail] bleiben
  /// temporaer parallel bis Inkrement B.
  static const journey = '/journey';
  static const journeyDetail = '/journey/detail';
  static const journeyMvp = '/journey/mvp';

  /// Legacy-Routen. Werden in Inkrement B entfernt, sobald
  /// `/journey` funktional gleich oder besser ist.
  static const trips = '/trips';
  static const tripDetail = '/trips/detail';

  /// E2E-UI-Skelette (Platzhalter, App-Shell) — EMM-115
  static const prepE2eRouting = '/e2e/routing-options';
  static const prepE2eWallet = '/e2e/wallet';
  static const prepE2eResult = '/e2e/result';
}
