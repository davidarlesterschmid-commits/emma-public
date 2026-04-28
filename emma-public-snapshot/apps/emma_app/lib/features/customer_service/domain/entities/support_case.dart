library;

// Moved to package:domain_customer_service (ADR-02 Schritt 3.a).
// SupportCase is referenced by JourneyCase and therefore needs to
// live in a cross-feature domain package. The feature-layer
// customer_service package will pick this up in Schritt 3.c / 4.
export 'package:domain_customer_service/domain_customer_service.dart'
    show SupportCase;
