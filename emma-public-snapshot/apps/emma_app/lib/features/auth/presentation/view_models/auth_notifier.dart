import 'package:domain_identity/domain_identity.dart';
import 'package:emma_app/features/auth/presentation/providers/auth_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-facing auth state.
///
/// Deterministic transitions:
///   idle          → {isLoading:false, user:null,     error:null}
///   loading       → {isLoading:true,  user:previous, error:null}
///   authenticated → {isLoading:false, user:User,     error:null}
///   failed        → {isLoading:false, user:previous, error:String}
class AuthState {
  const AuthState({this.user, this.isLoading = false, this.error});

  final User? user;
  final bool isLoading;
  final String? error;

  AuthState copyWith({User? user, bool? isLoading, Object? error = _noUpdate}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _noUpdate) ? this.error : error as String?,
    );
  }

  static const Object _noUpdate = Object();
}

/// Orchestriert den UI-Auth-State.
///
/// Lifecycle:
/// * [build] schedult einen Session-Restore via [checkAuthStatus] als
///   Microtask. Dadurch ist das App-Startverhalten „silent session
///   restore ohne expliziten Bootstrap-Aufruf" — erster `watch` des
///   Notifiers genuegt.
/// * Alle async Writes sind mit [Ref.mounted] gegen Disposal-Races
///   abgesichert. Ohne diesen Guard wuerden Tests, die den Container
///   disposen waehrend die Microtask noch laeuft, mit
///   „Cannot use the Ref ... after it has been disposed" crashen.
/// * [checkAuthStatus] ist oeffentlich, damit integrations- und
///   widget-Tests die Init deterministisch anstossen koennen, ohne
///   auf das Timing des Eager-Microtasks angewiesen zu sein.
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(checkAuthStatus);
    return const AuthState();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Laedt den aktuellen User aus dem Repository, ohne zu exceptionen.
  /// Fehler landen als `error`-String im State.
  Future<void> checkAuthStatus() async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.getCurrentUser();
      if (!ref.mounted) return;
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.login(email, password);
      if (!ref.mounted) return;
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loginWithOAuth(String provider) async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _repo.loginWithOAuth(provider);
      if (!ref.mounted) return;
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    if (!ref.mounted) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repo.logout();
      if (!ref.mounted) return;
      state = const AuthState();
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
