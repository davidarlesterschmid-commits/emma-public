import 'package:domain_employer_mobility/src/entities/profile_mode.dart';
import 'package:domain_identity/domain_identity.dart';
import 'package:domain_rules/domain_rules.dart';
import 'package:domain_wallet/domain_wallet.dart';

enum BmmProfileRole { privateCustomer, employerMember }

enum BmmEntitlementSource {
  identityRole,
  employerContract,
  rulesCatalog,
  budget,
}

class BmmEntitlement {
  const BmmEntitlement({
    required this.id,
    required this.label,
    required this.source,
    required this.isActive,
  });

  final String id;
  final String label;
  final BmmEntitlementSource source;
  final bool isActive;
}

class BmmProfileContext {
  const BmmProfileContext({
    required this.profile,
    required this.accountId,
    required this.activeMode,
    required this.availableModes,
    required this.roles,
    required this.entitlements,
    required this.budget,
  });

  final IdentityProfile profile;
  final String accountId;
  final UserMode activeMode;
  final List<UserMode> availableModes;
  final List<BmmProfileRole> roles;
  final List<BmmEntitlement> entitlements;
  final MobilityBudget? budget;

  bool get isEmployerContext => activeMode == UserMode.employer;
}

class BmmProfilePolicy {
  const BmmProfilePolicy._();

  static const privateRole = 'private';
  static const employerRole = 'employer';
  static const bmmContractPrefix = 'bmm:';

  static List<BmmProfileRole> resolveRoles(UserAccount account) {
    final roles = <BmmProfileRole>[];
    if (account.roles.isEmpty || account.roles.contains(privateRole)) {
      roles.add(BmmProfileRole.privateCustomer);
    }
    if (_hasEmployerContext(account)) {
      roles.add(BmmProfileRole.employerMember);
    }
    return List.unmodifiable(roles);
  }

  static List<UserMode> availableModes(UserAccount account) {
    final modes = <UserMode>[UserMode.private];
    if (_hasEmployerContext(account)) {
      modes.add(UserMode.employer);
    }
    return List.unmodifiable(modes);
  }

  static UserMode resolveActiveMode(
    UserAccount account, {
    UserMode requestedMode = UserMode.private,
  }) {
    if (requestedMode == UserMode.employer && !_hasEmployerContext(account)) {
      return UserMode.private;
    }
    return requestedMode;
  }

  static List<BmmEntitlement> resolveEntitlements({
    required UserAccount account,
    MobilityBudget? budget,
    List<TariffRule> tariffRules = const <TariffRule>[],
    List<ProductCatalogProduct> productCatalog =
        const <ProductCatalogProduct>[],
  }) {
    final entitlements = <BmmEntitlement>[
      const BmmEntitlement(
        id: 'profile.private',
        label: 'Privatprofil',
        source: BmmEntitlementSource.identityRole,
        isActive: true,
      ),
    ];

    if (_hasEmployerContext(account)) {
      entitlements.add(
        const BmmEntitlement(
          id: 'profile.employer',
          label: 'Arbeitgeberprofil',
          source: BmmEntitlementSource.employerContract,
          isActive: true,
        ),
      );
    }

    if (budget != null) {
      entitlements.add(
        BmmEntitlement(
          id: 'budget.fake',
          label: 'Mobilitaetsbudget',
          source: BmmEntitlementSource.budget,
          isActive: budget.remainingAmount > 0,
        ),
      );
    }

    for (final rule in tariffRules) {
      for (final entitlementId in rule.entitlements) {
        entitlements.add(
          BmmEntitlement(
            id: entitlementId,
            label: entitlementId,
            source: BmmEntitlementSource.rulesCatalog,
            isActive: true,
          ),
        );
      }
    }

    for (final product in productCatalog) {
      entitlements.add(
        BmmEntitlement(
          id: 'product.${product.id}',
          label: product.label,
          source: BmmEntitlementSource.rulesCatalog,
          isActive: product.status == ProductCatalogStatus.simulationOnly,
        ),
      );
    }

    return List.unmodifiable(entitlements);
  }

  static BmmProfileContext buildContext({
    required IdentityProfile profile,
    required UserAccount account,
    UserMode requestedMode = UserMode.private,
    MobilityBudget? budget,
    List<TariffRule> tariffRules = const <TariffRule>[],
    List<ProductCatalogProduct> productCatalog =
        const <ProductCatalogProduct>[],
  }) {
    return BmmProfileContext(
      profile: profile,
      accountId: account.id,
      activeMode: resolveActiveMode(account, requestedMode: requestedMode),
      availableModes: availableModes(account),
      roles: resolveRoles(account),
      entitlements: resolveEntitlements(
        account: account,
        budget: budget,
        tariffRules: tariffRules,
        productCatalog: productCatalog,
      ),
      budget: budget,
    );
  }

  static bool _hasEmployerContext(UserAccount account) {
    return account.roles.contains(employerRole) &&
        account.contracts.any(
          (contract) => contract.startsWith(bmmContractPrefix),
        );
  }
}
