/// emma_core public surface (Flutter-free).
///
/// Flutter-gebundene Bausteine wie [SecureStorage] werden NICHT vom
/// Barrel exportiert. Konsumenten der App-Shell importieren diese
/// explizit ueber ihren Unter-Pfad:
///
///     import 'package:emma_core/src/storage/secure_storage.dart';
///
/// Architektur-Ziel (Follow-up): flutter_secure_storage vollstaendig
/// aus emma_core ausgliedern — `SecureStorage` als Port hier lassen,
/// Impl in einen Adapter-Paket verschieben.
library;

export 'src/result.dart';
export 'src/logger.dart';
export 'src/errors/app_error.dart';
export 'src/network/api_client.dart';
export 'src/services/logging_service.dart';
export 'src/services/monitoring_service.dart';
