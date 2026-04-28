"""Unit tests for tools/llm_routing.py (EMM-235)."""

from __future__ import annotations

import sys
import unittest
from datetime import datetime
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from llm_routing import classify_and_route  # noqa: E402


def _is_iso8601(value: str) -> bool:
    if not isinstance(value, str) or not value:
        return False
    try:
        datetime.fromisoformat(value)
        return True
    except ValueError:
        return False


class RoutingRulesTests(unittest.TestCase):
    def test_private_zone_a_routes_to_secure_worker(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "repository_visibility": "private",
                "data_classification": "zone_a_critical",
            }
        )
        self.assertEqual(result["route_to"], "secure_zone_a_worker")
        self.assertFalse(result["external_llm_allowed"])
        self.assertTrue(result["requires_human_review"])

    def test_public_zone_a_still_routes_to_secure_worker(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "repository_visibility": "public",
                "data_classification": "zone_a_critical",
            }
        )
        self.assertEqual(result["route_to"], "secure_zone_a_worker")
        self.assertFalse(result["external_llm_allowed"])

    def test_zone_b_routes_to_abstracted_worker(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "repository_visibility": "private",
                "data_classification": "zone_b_semi_critical",
            }
        )
        self.assertEqual(result["route_to"], "abstracted_zone_b_worker")
        self.assertTrue(result["external_llm_allowed"])
        self.assertTrue(result["requires_human_review"])

    def test_zone_c_routes_to_free_worker(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "repository_visibility": "public",
                "data_classification": "zone_c_non_critical",
            }
        )
        self.assertEqual(result["route_to"], "free_tier_zone_c_worker")
        self.assertTrue(result["external_llm_allowed"])
        self.assertFalse(result["requires_human_review"])


class FailSafeTests(unittest.TestCase):
    def test_missing_classification_falls_back_to_zone_a(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "repository_visibility": "private",
            }
        )
        self.assertEqual(result["route_to"], "secure_zone_a_worker")
        self.assertEqual(
            result["audit_log"]["classification"], "zone_a_critical"
        )
        self.assertFalse(result["external_llm_allowed"])

    def test_invalid_classification_falls_back_to_zone_a(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "repository_visibility": "private",
                "data_classification": "totally_made_up",
            }
        )
        self.assertEqual(result["route_to"], "secure_zone_a_worker")
        self.assertEqual(
            result["audit_log"]["classification"], "zone_a_critical"
        )

    def test_missing_visibility_defaults_to_private(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "data_classification": "zone_a_critical",
            }
        )
        self.assertEqual(result["route_to"], "secure_zone_a_worker")
        self.assertEqual(
            result["audit_log"]["repository_visibility"], "private"
        )

    def test_empty_payload_falls_back_to_zone_a(self) -> None:
        result = classify_and_route({})
        self.assertEqual(result["route_to"], "secure_zone_a_worker")
        self.assertEqual(result["audit_log"]["linear_id"], "UNKNOWN")
        self.assertEqual(
            result["audit_log"]["classification"], "zone_a_critical"
        )

    def test_non_dict_payload_falls_back_to_zone_a(self) -> None:
        result = classify_and_route(None)  # type: ignore[arg-type]
        self.assertEqual(result["route_to"], "secure_zone_a_worker")
        self.assertFalse(result["external_llm_allowed"])

    def test_non_string_classification_falls_back(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "data_classification": 42,
            }
        )
        self.assertEqual(result["route_to"], "secure_zone_a_worker")


class AuditLogTests(unittest.TestCase):
    def test_audit_log_contains_required_fields(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "repository_visibility": "private",
                "data_classification": "zone_b_semi_critical",
            }
        )
        log = result["audit_log"]
        for key in (
            "linear_id",
            "classification",
            "route",
            "external_llm_allowed",
            "timestamp",
        ):
            self.assertIn(key, log, f"audit_log missing key: {key}")

    def test_audit_log_linear_id_preserved(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "data_classification": "zone_c_non_critical",
            }
        )
        self.assertEqual(result["audit_log"]["linear_id"], "EMM-235")

    def test_audit_log_route_matches_top_level(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "data_classification": "zone_b_semi_critical",
            }
        )
        self.assertEqual(result["audit_log"]["route"], result["route_to"])

    def test_audit_log_classification_matches_resolved(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "data_classification": "garbage",
            }
        )
        self.assertEqual(
            result["audit_log"]["classification"], "zone_a_critical"
        )

    def test_audit_log_timestamp_is_iso8601(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "data_classification": "zone_a_critical",
            }
        )
        self.assertTrue(
            _is_iso8601(result["audit_log"]["timestamp"]),
            f"timestamp not ISO 8601: {result['audit_log']['timestamp']!r}",
        )

    def test_audit_log_external_llm_used_default_false(self) -> None:
        result = classify_and_route(
            {
                "linear_id": "EMM-235",
                "data_classification": "zone_c_non_critical",
            }
        )
        self.assertFalse(result["audit_log"]["external_llm_used"])


if __name__ == "__main__":
    unittest.main()
