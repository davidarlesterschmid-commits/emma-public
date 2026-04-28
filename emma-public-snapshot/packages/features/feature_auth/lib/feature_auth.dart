/// Public surface of the auth & account feature.
///
/// Das Paket liefert die konkreten Datasource- und Repository-Impls
/// sowie UI-Primitives. Jegliches Riverpod-Wiring (Provider, Notifier,
/// State) lebt in der App-Shell unter
/// `apps/emma_app/lib/features/auth/`; dieses Paket exportiert keine
/// Riverpod-Symbole (Monorepo-Invariante: Pakete definieren keine
/// Provider-Instanzen).
///
/// Consumers (der emma_app-Integrator) bekommen:
///   * Domain-Typen aus [domain_identity] (User, UserAccount, Failures,
///     Repository-Ports).
///   * [AuthRepositoryImpl] / [AccountRepositoryImpl] — Default-Impls
///     fuer den App-Shell-Provider.
///   * [AuthRemoteDataSourceImpl] / [AuthLocalDataSourceImpl] —
///     ausgesetzt fuer alternative Kompositionen und Tests.
///   * [AccountCard] / [ProfileEditWidget] — UI-Primitives ohne
///     Riverpod-Bindung.
library;

export 'package:domain_identity/domain_identity.dart'
    show
        AccountRepository,
        AuthRepository,
        IdentityFailure,
        IdentityRejectedFailure,
        IdentityUnavailableFailure,
        InvalidCredentialsFailure,
        NotAuthenticatedFailure,
        User,
        UserAccount;

export 'src/data/account_repository_impl.dart' show AccountRepositoryImpl;
export 'src/data/auth_local_datasource.dart'
    show AuthLocalDataSource, AuthLocalDataSourceImpl;
export 'src/data/auth_remote_datasource.dart'
    show AuthRemoteDataSource, AuthRemoteDataSourceImpl;
export 'src/data/auth_repository_impl.dart' show AuthRepositoryImpl;
export 'src/presentation/widgets/account_card.dart' show AccountCard;
export 'src/presentation/widgets/profile_edit_widget.dart'
    show ProfileEditWidget;
