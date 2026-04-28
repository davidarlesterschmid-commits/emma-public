import 'package:domain_journey/src/contracts/case/emma_case_contract.dart';

export 'emma_case_contract.dart'
    show
        EmmaCaseContract,
        EmmaCaseHeader,
        EmmaCaseIdentity,
        EmmaCaseContext,
        EmmaCasePhaseState,
        EmmaPhaseSnapshot,
        EmmaSharedEntities,
        EmmaFinancialState;

typedef CanonicalCase = EmmaCaseContract;
typedef CanonicalCaseHeader = EmmaCaseHeader;
typedef CanonicalCaseIdentity = EmmaCaseIdentity;
typedef CanonicalCaseContext = EmmaCaseContext;
typedef CanonicalPhaseState = EmmaCasePhaseState;
typedef CanonicalPhaseSnapshot = EmmaPhaseSnapshot;
typedef CanonicalSharedEntities = EmmaSharedEntities;
typedef CanonicalFinancialState = EmmaFinancialState;
