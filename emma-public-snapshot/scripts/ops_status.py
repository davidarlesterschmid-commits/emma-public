#!/usr/bin/env python3
"""Local GitHub PR status dashboard for emma agent operations."""

from __future__ import annotations

import argparse
import json
import re
import shutil
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


MARKERS = (
    "BLOCKED_BY_AGENT",
    "BLOCKED_BY_INPUT",
    "BLOCKED_BY_CONTEXT_DRIFT",
    "WAITING_FOR_CLAUDE",
    "CLAUDE_REVIEW_RUNNING",
    "CLAUDE_PASS",
    "CLAUDE_REQUEST_CHANGES",
    "CLAUDE_BLOCKED",
)


class OpsStatusError(RuntimeError):
    pass


@dataclass(frozen=True)
class CheckSummary:
    total: int
    passed: int
    failed: int
    pending: int

    @property
    def state(self) -> str:
        if self.failed:
            return "FAIL"
        if self.pending:
            return "PENDING"
        if self.total == 0:
            return "NO_CHECKS"
        return "PASS"


@dataclass(frozen=True)
class PullRequestRow:
    number: int
    title: str
    url: str
    state: str
    readiness: str
    updated_at: str
    head: str
    base: str
    author: str
    labels: list[str]
    linear_id: str
    risk: str
    checks: CheckSummary
    check_details: str
    markers: list[str]


def run_gh(args: list[str]) -> str:
    try:
        completed = subprocess.run(
            ["gh", *args],
            check=True,
            capture_output=True,
            encoding="utf-8",
            errors="replace",
        )
    except FileNotFoundError as exc:
        raise OpsStatusError(
            "GitHub CLI `gh` wurde nicht gefunden. Installiere `gh` und stelle sicher, "
            "dass es im PATH verfuegbar ist."
        ) from exc
    except subprocess.CalledProcessError as exc:
        stderr = (exc.stderr or "").strip()
        stdout = (exc.stdout or "").strip()
        detail = stderr or stdout or f"exit code {exc.returncode}"
        raise OpsStatusError(
            "GitHub CLI-Aufruf fehlgeschlagen. Pruefe `gh auth status` und Repo-Zugriff. "
            f"Details: {detail}"
        ) from exc
    return completed.stdout


def ensure_gh_ready() -> None:
    if shutil.which("gh") is None:
        raise OpsStatusError(
            "GitHub CLI `gh` wurde nicht gefunden. Installiere `gh` und stelle sicher, "
            "dass es im PATH verfuegbar ist."
        )
    run_gh(["auth", "status"])


def load_open_prs(limit: int) -> list[dict[str, Any]]:
    fields = [
        "number",
        "title",
        "url",
        "isDraft",
        "updatedAt",
        "headRefName",
        "baseRefName",
        "author",
        "labels",
        "state",
        "body",
        "statusCheckRollup",
    ]
    raw = run_gh(
        [
            "pr",
            "list",
            "--state",
            "open",
            "--limit",
            str(limit),
            "--json",
            ",".join(fields),
        ]
    )
    payload = json.loads(raw or "[]")
    if not isinstance(payload, list):
        raise OpsStatusError("Unerwartete `gh pr list` Ausgabe: JSON-Liste erwartet.")
    return payload


def load_comment_text(pr_number: int) -> str:
    raw = run_gh(["pr", "view", str(pr_number), "--json", "comments"])
    payload = json.loads(raw)
    comments = payload.get("comments") or []
    return "\n".join(str(comment.get("body") or "") for comment in comments)


def extract_labels(pr: dict[str, Any]) -> list[str]:
    labels = pr.get("labels") or []
    if isinstance(labels, dict):
        labels = labels.get("nodes") or []
    names: list[str] = []
    for label in labels:
        if isinstance(label, dict) and isinstance(label.get("name"), str):
            names.append(label["name"])
        elif isinstance(label, str):
            names.append(label)
    return sorted(set(names), key=str.lower)


def extract_author(pr: dict[str, Any]) -> str:
    author = pr.get("author")
    if isinstance(author, dict):
        login = author.get("login")
        name = author.get("name")
        if isinstance(login, str) and login:
            return login
        if isinstance(name, str) and name:
            return name
    if isinstance(author, str) and author:
        return author
    return "unknown"


def extract_linear_id(text: str) -> str:
    match = re.search(r"\bEMM-\d+\b", text, flags=re.IGNORECASE)
    return match.group(0).upper() if match else "?"


def extract_risk(body: str, labels: list[str]) -> str:
    for label in labels:
        match = re.search(r"\brisk:\s*(R[0-5])\b", label, flags=re.IGNORECASE)
        if match:
            return match.group(1).upper()
    patterns = (
        r"Risikoklasse\s*[:\n\r ]+[-*\s`]*(R[0-5])\b",
        r"Risk\s*[:\n\r ]+[-*\s`]*(R[0-5])\b",
        r"[-*]\s*\*\*(R[0-5])\*\*",
        r"\b(R[0-5])\b",
    )
    for pattern in patterns:
        match = re.search(pattern, body, flags=re.IGNORECASE)
        if match:
            return match.group(1).upper()
    return "?"


def marker_list(text: str, labels: list[str]) -> list[str]:
    haystack = "\n".join([text, *labels])
    markers = {marker for marker in MARKERS if marker in haystack}
    markers.update(markers_from_claude_blocks(haystack))
    return sorted(markers, key=str.lower)


def markers_from_claude_blocks(text: str) -> set[str]:
    """Derive high-level markers from the machine-readable Claude marker block.

    Spec is defined in docs/operations/review_merge_automation.md.
    """
    start = "<!-- EMMA_CLAUDE_MARKER_START -->"
    end = "<!-- EMMA_CLAUDE_MARKER_END -->"
    blocks: list[str] = []
    cursor = 0
    while True:
        s = text.find(start, cursor)
        if s < 0:
            break
        e = text.find(end, s)
        if e < 0:
            break
        blocks.append(text[s + len(start) : e].strip())
        cursor = e + len(end)

    def parse_block(block: str) -> dict[str, str]:
        data: dict[str, str] = {}
        for line in block.splitlines():
            line = line.strip()
            if not line or ":" not in line:
                continue
            key, value = line.split(":", 1)
            data[key.strip().upper()] = value.strip().upper()
        return data

    derived: set[str] = set()
    for raw in blocks:
        data = parse_block(raw)
        status = data.get("EMMA_CLAUDE_STATUS") or ""
        outcome = data.get("EMMA_CLAUDE_OUTCOME") or ""
        passed = data.get("EMMA_CLAUDE_PASS") or ""

        if status == "WAITING_FOR_CLAUDE":
            derived.add("WAITING_FOR_CLAUDE")
            continue

        if status == "OUTCOME_RECORDED":
            if passed == "TRUE" and outcome == "PASS":
                derived.add("CLAUDE_PASS")
            elif outcome == "FAIL":
                derived.add("CLAUDE_REQUEST_CHANGES")
            elif outcome == "GATE_REQUIRED":
                derived.add("CLAUDE_BLOCKED")
    return derived


def check_started_at(check: dict[str, Any]) -> str:
    return str(check.get("startedAt") or check.get("completedAt") or "")


def check_state(check: dict[str, Any]) -> str:
    status = str(check.get("status") or "").upper()
    conclusion = str(check.get("conclusion") or "").upper()
    if status and status != "COMPLETED":
        return "PENDING"
    if conclusion == "SUCCESS":
        return "PASS"
    if conclusion == "FAILURE":
        return "FAIL"
    if conclusion == "CANCELLED":
        return "CANCELLED"
    if conclusion == "SKIPPED":
        return "SKIPPED"
    if conclusion:
        return conclusion
    return status or "UNKNOWN"


def summarize_checks(checks: list[dict[str, Any]]) -> tuple[CheckSummary, str]:
    if not checks:
        return CheckSummary(total=0, passed=0, failed=0, pending=0), "no checks"

    latest_by_name: dict[str, dict[str, Any]] = {}
    for check in checks:
        name = str(check.get("name") or check.get("workflowName") or "check")
        current = latest_by_name.get(name)
        if current is None or check_started_at(check) >= check_started_at(current):
            latest_by_name[name] = check

    states = [check_state(check) for check in latest_by_name.values()]
    failed_states = {"FAIL", "CANCELLED", "TIMED_OUT", "ACTION_REQUIRED"}
    pending_states = {"PENDING", "QUEUED", "IN_PROGRESS", "WAITING", "REQUESTED"}
    summary = CheckSummary(
        total=len(states),
        passed=sum(1 for state in states if state in {"PASS", "SKIPPED"}),
        failed=sum(1 for state in states if state in failed_states),
        pending=sum(1 for state in states if state in pending_states),
    )
    details = ", ".join(
        f"{name}:{check_state(check)}" for name, check in sorted(latest_by_name.items())
    )
    return summary, details


def build_rows(prs: list[dict[str, Any]]) -> list[PullRequestRow]:
    rows: list[PullRequestRow] = []
    for pr in prs:
        number = int(pr["number"])
        body = str(pr.get("body") or "")
        labels = extract_labels(pr)
        comments = load_comment_text(number)
        combined_text = f"{body}\n{comments}"
        check_summary, check_details = summarize_checks(pr.get("statusCheckRollup") or [])
        rows.append(
            PullRequestRow(
                number=number,
                title=str(pr.get("title") or ""),
                url=str(pr.get("url") or ""),
                state=str(pr.get("state") or "OPEN"),
                readiness="Draft" if pr.get("isDraft") else "Ready",
                updated_at=str(pr.get("updatedAt") or ""),
                head=str(pr.get("headRefName") or ""),
                base=str(pr.get("baseRefName") or ""),
                author=extract_author(pr),
                labels=labels,
                linear_id=extract_linear_id(combined_text),
                risk=extract_risk(body, labels),
                checks=check_summary,
                check_details=check_details,
                markers=marker_list(combined_text, labels),
            )
        )
    return sorted(rows, key=lambda row: row.updated_at, reverse=True)


def format_age(iso_timestamp: str) -> str:
    try:
        updated = datetime.fromisoformat(iso_timestamp.replace("Z", "+00:00"))
        delta = datetime.now(timezone.utc) - updated.astimezone(timezone.utc)
        minutes = int(delta.total_seconds() // 60)
    except ValueError:
        return "?"
    if minutes < 60:
        return f"{minutes}m"
    hours = minutes // 60
    if hours < 48:
        return f"{hours}h"
    return f"{hours // 24}d"


def shorten(value: str, max_width: int) -> str:
    value = value.replace("\n", " ").strip()
    if len(value) <= max_width:
        return value
    return value[: max_width - 1] + "..."


def render_table(rows: list[PullRequestRow]) -> str:
    headers = [
        "PR",
        "Linear",
        "Risk",
        "State",
        "Checks",
        "Markers",
        "Age",
        "Branch -> Base",
        "Title",
    ]
    data = [
        [
            f"#{row.number}",
            row.linear_id,
            row.risk,
            f"{row.state}/{row.readiness}",
            f"{row.checks.state} ({row.checks.passed}/{row.checks.total})",
            ", ".join(row.markers) if row.markers else "-",
            format_age(row.updated_at),
            f"{row.head} -> {row.base}",
            row.title,
        ]
        for row in rows
    ]
    max_widths = [6, 10, 5, 16, 18, 42, 5, 42, 56]
    clipped = [[shorten(cell, max_widths[i]) for i, cell in enumerate(row)] for row in data]
    widths = [
        min(max_widths[i], max([len(headers[i]), *(len(row[i]) for row in clipped)] or [0]))
        for i in range(len(headers))
    ]

    def format_row(cells: list[str]) -> str:
        return " | ".join(cells[i].ljust(widths[i]) for i in range(len(cells)))

    separator = "-+-".join("-" * width for width in widths)
    lines = ["emma ops status", format_row(headers), separator]
    lines.extend(format_row(row) for row in clipped)
    if not rows:
        lines.append("No open pull requests found.")
    return "\n".join(lines)


def render_markdown(rows: list[PullRequestRow]) -> str:
    headers = [
        "PR",
        "Linear",
        "Risk",
        "State",
        "Checks",
        "Markers",
        "Branch",
        "Base",
        "Title",
        "URL",
    ]
    lines = [
        "# Ops Status Dashboard",
        "",
        "| " + " | ".join(headers) + " |",
        "| " + " | ".join(["---"] * len(headers)) + " |",
    ]
    for row in rows:
        cells = [
            str(row.number),
            row.linear_id,
            row.risk,
            f"{row.state}/{row.readiness}",
            f"{row.checks.state} ({row.check_details})",
            ", ".join(row.markers) if row.markers else "-",
            row.head,
            row.base,
            row.title,
            row.url,
        ]
        lines.append("| " + " | ".join(cell.replace("|", "\\|") for cell in cells) + " |")
    return "\n".join(lines)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Local ops dashboard for open PR status, checks and agent markers."
    )
    parser.add_argument("--limit", type=int, default=100, help="Max open PRs to scan.")
    parser.add_argument(
        "--only-blocked",
        action="store_true",
        help="Show only PRs with BLOCKED/WAITING/CLAUDE markers.",
    )
    parser.add_argument(
        "--format",
        choices=("table", "md"),
        default="table",
        help="Output format.",
    )
    parser.add_argument(
        "--write-md",
        metavar="PATH",
        help="Write a markdown report to PATH in addition to stdout.",
    )
    return parser.parse_args(argv)


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    try:
        ensure_gh_ready()
        rows = build_rows(load_open_prs(args.limit))
    except OpsStatusError as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2

    if args.only_blocked:
        rows = [row for row in rows if row.markers]

    output = render_markdown(rows) if args.format == "md" else render_table(rows)
    print(output)

    if args.write_md:
        Path(args.write_md).write_text(render_markdown(rows) + "\n", encoding="utf-8")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
