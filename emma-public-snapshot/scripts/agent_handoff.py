#!/usr/bin/env python3
"""Create an EMM-215 agent handoff and optionally post it to Linear."""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import urllib.error
import urllib.request
from datetime import datetime
from pathlib import Path


AGENTS = ("Codex", "Cursor", "Claude", "ChatGPT")
RESULT_STATUS = ("PASS", "FAIL", "BLOCKED")

WORK_STATE_BY_STATUS = {
    "PASS": "DONE",
    "FAIL": "PARTIAL",
    "BLOCKED": "BLOCKED",
}

HANDOFF_STATUS_BY_STATUS = {
    "PASS": "HANDOFF_READY",
    "FAIL": "BLOCKED_BY_AGENT",
    "BLOCKED": "BLOCKED_BY_AGENT",
}


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def timestamp() -> str:
    now = datetime.now().astimezone()
    offset = now.strftime("%z")
    offset_with_colon = f"{offset[:3]}:{offset[3:]}" if offset else ""
    return now.strftime("%Y-%m-%d %H:%M ") + offset_with_colon


def validate_issue(issue: str) -> str:
    normalized = issue.strip().upper()
    if not re.fullmatch(r"[A-Z]+-\d+", normalized):
        raise argparse.ArgumentTypeError("issue must look like EMM-199")
    return normalized


def bullet_lines(value: str | None, default: str) -> str:
    text = value.strip() if value else default
    lines = [line.strip() for line in text.splitlines() if line.strip()]
    if not lines:
        lines = [default]
    return "\n".join(line if line.startswith("- ") else f"- {line}" for line in lines)


def render_handoff(args: argparse.Namespace) -> str:
    issue = args.issue
    work_state = WORK_STATE_BY_STATUS[args.status]
    handoff_status = HANDOFF_STATUS_BY_STATUS[args.status]
    handoff_file = f"handoff_{issue}.md"

    scope = bullet_lines(args.scope, f"Agent-Handoff fuer {issue} erzeugt.")
    changed_files = bullet_lines(args.changed_files, handoff_file)
    diff = bullet_lines(args.diff, "(keine)")
    checks = bullet_lines(args.checks, "Script ausgefuehrt; Handoff-Datei geschrieben.")
    blocker = bullet_lines(args.blocker, "(keine)" if args.status == "PASS" else args.status)
    not_done = bullet_lines(args.not_done, "(keine)")
    next_step = bullet_lines(args.next_step, "Handoff im Repo- oder Linear-Prozess weiterverwenden.")

    return f"""## HANDOFF - {issue}

Agent: {args.agent}
Zeitpunkt: {timestamp()}
Risikoklasse: {args.risk}
Arbeitsstand: {work_state}

Scope:

{scope}

Geaenderte Dateien:

{changed_files}

Diff-Ueberblick:

{diff}

Checks:

{checks}

Blocker:

{blocker}

Nicht getan:

{not_done}

Naechster Schritt:

{next_step}

Status: {handoff_status}
"""


def post_to_linear(issue: str, body: str, api_key: str) -> bool:
    payload = {
        "query": """
mutation AgentHandoffComment($issueId: String!, $body: String!) {
  commentCreate(input: { issueId: $issueId, body: $body }) {
    success
    comment {
      id
    }
  }
}
""",
        "variables": {"issueId": issue, "body": body},
    }
    request = urllib.request.Request(
        "https://api.example.invalid/graphql",
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": api_key,
            "Content-Type": "application/json",
        },
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=15) as response:
            result = json.loads(response.read().decode("utf-8"))
    except (urllib.error.URLError, TimeoutError, json.JSONDecodeError) as exc:
        print(f"Linear post failed: {exc}", file=sys.stderr)
        return False

    if result.get("errors"):
        print(f"Linear post failed: {result['errors']}", file=sys.stderr)
        return False

    success = (
        result.get("data", {})
        .get("commentCreate", {})
        .get("success")
    )
    if not success:
        print("Linear post failed: commentCreate did not report success", file=sys.stderr)
        return False
    return True


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create an EMM-215 agent handoff markdown block."
    )
    parser.add_argument("--issue", required=True, type=validate_issue)
    parser.add_argument("--status", required=True, choices=RESULT_STATUS)
    parser.add_argument("--agent", choices=AGENTS, default="Codex")
    parser.add_argument("--risk", default="R1")
    parser.add_argument("--scope")
    parser.add_argument("--changed-files")
    parser.add_argument("--diff")
    parser.add_argument("--checks")
    parser.add_argument("--blocker")
    parser.add_argument("--not-done")
    parser.add_argument("--next-step")
    parser.add_argument(
        "--no-linear",
        action="store_true",
        help="Do not post to Linear even when LINEAR_API_KEY is present.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    body = render_handoff(args)
    output_path = repo_root() / f"handoff_{args.issue}.md"
    output_path.write_text(body, encoding="utf-8")

    print(body, end="")

    api_key = os.environ.get("LINEAR_API_KEY")
    if api_key and not args.no_linear:
        post_to_linear(args.issue, body, api_key)
    elif not api_key:
        print("LINEAR_API_KEY not set; skipped Linear post.", file=sys.stderr)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
