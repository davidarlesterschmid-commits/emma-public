/// Identity domain — contracts and entities for authentication and
/// customer account. Flutter-free by design so it stays portable and
/// can be exercised with pure `dart test`.
library;

export 'src/entities/identity_profile.dart';
export 'src/entities/user.dart';
export 'src/entities/user_account.dart';
export 'src/errors/identity_errors.dart';
export 'src/repositories/account_repository.dart';
export 'src/repositories/auth_repository.dart';
