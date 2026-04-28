"""LLM Data Classification & Routing.

Implements the gate logic from
docs/operations/llm-data-classification-policy.md (v1.1).
"""

from __future__ import annotations

import json
from datetime import datetime, timezone
from typing import Any, Mapping

VALID_CLASSIFICATIONS = (
    "zone_a_critical",
    "zone_b_semi_critical",
    "zone_c_non_critical",
)

VALID_VISIBILITIES = ("private", "public")

DEFAULT_CLASSIFICATION = "zone_a_critical"
DEFAULT_VISIBILITY = "private"


def _now_iso() -> str:
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def _normalize(payload: Any) -> dict[str, Any]:
    if not isinstance(payload, Mapping):
        return {}
    return dict(payload)


def _resolve_classification(value: Any) -> str:
    if not isinstance(value, str) or value not in VALID_CLASSIFICATIONS:
        return DEFAULT_CLASSIFICATION
    return value


def _resolve_visibility(value: Any) -> str:
    if not isinstance(value, str) or value not in VALID_VISIBILITIES:
        return DEFAULT_VISIBILITY
    return value


def _route(classification: str, visibility: str) -> tuple[str, bool, bool, str]:
    if classification == "zone_a_critical":
        reason = (
            "private+zone_a_critical -> secure_zone_a_worker"
            if visibility == "private"
            else "zone_a_critical (any visibility) -> secure_zone_a_worker"
        )
        return "secure_zone_a_worker", False, True, reason
    if classification == "zone_b_semi_critical":
        return (
            "abstracted_zone_b_worker",
            True,
            True,
            "zone_b_semi_critical -> abstracted_zone_b_worker (no full diffs)",
        )
    if classification == "zone_c_non_critical":
        return (
            "free_tier_zone_c_worker",
            True,
            False,
            "zone_c_non_critical -> free_tier_zone_c_worker",
        )
    return (
        "secure_zone_a_worker",
        False,
        True,
        "fallback -> secure_zone_a_worker",
    )


def classify_and_route(input: dict) -> dict:  # noqa: A002 - signature per spec
    data = _normalize(input)
    linear_id = data.get("linear_id") or "UNKNOWN"
    visibility = _resolve_visibility(data.get("repository_visibility"))
    classification = _resolve_classification(data.get("data_classification"))

    route, external_allowed, requires_review, reason = _route(classification, visibility)

    audit_log: dict[str, Any] = {
        "linear_id": linear_id,
        "repository_visibility": visibility,
        "data_classification": classification,
        "classification": classification,
        "route": route,
        "external_llm_used": False,
        "external_llm_allowed": external_allowed,
        "requires_human_review": requires_review,
        "routing_decision_reason": reason,
        "timestamp": _now_iso(),
    }

    return {
        "route_to": route,
        "external_llm_allowed": external_allowed,
        "requires_human_review": requires_review,
        "audit_log": audit_log,
    }


if __name__ == "__main__":
    import sys

    raw = sys.stdin.read().strip()
    payload = json.loads(raw) if raw else {}
    result = classify_and_route(payload)
    json.dump(result, sys.stdout, ensure_ascii=False, indent=2)
    sys.stdout.write("\n")
