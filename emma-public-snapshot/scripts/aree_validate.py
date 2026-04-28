#!/usr/bin/env python3
"""Deterministic AREE quiz validator for EMM-199."""

from __future__ import annotations

import json
import re
import sys
from collections import Counter
from pathlib import Path
from typing import Any


REPO_ROOT = Path(__file__).resolve().parents[1]
QUIZ_PATH = Path("docs/operations/aree/aree_quiz_v1.json")
PROMPT_TEMPLATE_PATH = Path("docs/operations/aree/aree_prompt_template.md")

EXPECTED_QUESTIONS = 50
EXPECTED_CLUSTERS = 5
EXPECTED_QUESTIONS_PER_CLUSTER = 10
MIN_OPTIONS = 2
MAX_OPTIONS = 4
MIN_VALIDATION_RULES = 6

SNAKE_KEY = re.compile(r"\b[a-z][a-z0-9]*(?:_[a-z0-9]+)+\b")
JSON_KEY = re.compile(r'"([a-z][a-z0-9_]+)"\s*:')
INLINE_CODE = re.compile(r"`([^`]+)`")
FREE_TEXT_VALUES = {
    "custom",
    "free_text",
    "freitext",
    "manual",
    "manual_input",
    "open",
    "other",
    "sonstiges",
    "text",
}
FREE_TEXT_FIELDS = {
    "allow_free_text",
    "allow_text",
    "free_text",
    "freitext",
    "input",
    "open",
    "requires_text",
    "text_input",
}
FREE_TEXT_TYPES = {
    "custom",
    "free_text",
    "freitext",
    "manual_input",
    "open",
    "textarea",
    "text",
}


def repo_path(path: Path) -> Path:
    return REPO_ROOT / path


def line_of(raw: str, needle: str) -> int | None:
    for line_number, line in enumerate(raw.splitlines(), start=1):
        if needle in line:
            return line_number
    return None


def location(path: Path, line: int | None = None) -> str:
    return f"{path}:{line}" if line else str(path)


def add_error(errors: list[str], path: Path, message: str, line: int | None = None) -> None:
    errors.append(f"{location(path, line)}: {message}")


def read_text(path: Path, errors: list[str]) -> str | None:
    absolute = repo_path(path)
    try:
        return absolute.read_text(encoding="utf-8")
    except FileNotFoundError:
        add_error(errors, path, "file not found")
    except OSError as exc:
        add_error(errors, path, f"could not read file: {exc}")
    return None


def load_quiz(raw: str | None, errors: list[str]) -> dict[str, Any] | None:
    if raw is None:
        return None
    try:
        parsed = json.loads(raw)
    except json.JSONDecodeError as exc:
        add_error(
            errors,
            QUIZ_PATH,
            f"JSON is not parseable: {exc.msg} at column {exc.colno}",
            exc.lineno,
        )
        return None
    if not isinstance(parsed, dict):
        add_error(errors, QUIZ_PATH, "root value must be a JSON object", 1)
        return None
    return parsed


def as_list(value: Any, name: str, errors: list[str], raw: str) -> list[Any]:
    if isinstance(value, list):
        return value
    add_error(errors, QUIZ_PATH, f"`{name}` must be an array", line_of(raw, f'"{name}"'))
    return []


def as_object(value: Any, name: str, errors: list[str], raw: str) -> dict[str, Any]:
    if isinstance(value, dict):
        return value
    add_error(errors, QUIZ_PATH, f"`{name}` must be an object", line_of(raw, f'"{name}"'))
    return {}


def duplicate_items(values: list[str]) -> list[str]:
    counts = Counter(values)
    return sorted(value for value, count in counts.items() if count > 1)


def validate_questions(
    quiz: dict[str, Any], raw: str, errors: list[str]
) -> tuple[list[dict[str, Any]], set[str]]:
    questions_raw = as_list(quiz.get("questions"), "questions", errors, raw)
    if len(questions_raw) != EXPECTED_QUESTIONS:
        add_error(
            errors,
            QUIZ_PATH,
            f"`questions` must contain exactly {EXPECTED_QUESTIONS} entries, "
            f"found {len(questions_raw)}",
            line_of(raw, '"questions"'),
        )

    questions: list[dict[str, Any]] = []
    question_ids: list[str] = []
    config_keys: list[str] = []

    for index, value in enumerate(questions_raw, start=1):
        if not isinstance(value, dict):
            add_error(errors, QUIZ_PATH, f"questions[{index}] must be an object")
            continue
        question = value
        questions.append(question)

        question_id = question.get("id")
        question_line = line_of(raw, f'"id": "{question_id}"') if isinstance(question_id, str) else None
        label = question_id if isinstance(question_id, str) and question_id else f"questions[{index}]"

        if not isinstance(question_id, str) or not question_id:
            add_error(errors, QUIZ_PATH, f"questions[{index}].id must be a non-empty string")
        else:
            question_ids.append(question_id)

        key = question.get("key")
        if not isinstance(key, str) or not key:
            add_error(errors, QUIZ_PATH, f"{label}.key must be exactly one non-empty string", question_line)
        else:
            config_keys.append(key)

        options = question.get("options")
        if not isinstance(options, list):
            add_error(errors, QUIZ_PATH, f"{label}.options must be an array", question_line)
            continue
        if not MIN_OPTIONS <= len(options) <= MAX_OPTIONS:
            add_error(
                errors,
                QUIZ_PATH,
                f"{label}.options must contain {MIN_OPTIONS}-{MAX_OPTIONS} entries, "
                f"found {len(options)}",
                question_line,
            )

        for option_index, option in enumerate(options, start=1):
            if not isinstance(option, dict):
                add_error(errors, QUIZ_PATH, f"{label}.options[{option_index}] must be an object", question_line)
                continue
            option_value = option.get("v")
            if not isinstance(option_value, str) or not option_value:
                add_error(errors, QUIZ_PATH, f"{label}.options[{option_index}].v must be a non-empty string", question_line)
            validate_no_free_text_option(errors, label, option_index, option, question_line)

    for duplicate in duplicate_items(question_ids):
        add_error(errors, QUIZ_PATH, f"question id `{duplicate}` is not unique", line_of(raw, f'"id": "{duplicate}"'))
    if len(set(question_ids)) != EXPECTED_QUESTIONS:
        add_error(errors, QUIZ_PATH, f"expected {EXPECTED_QUESTIONS} unique question ids, found {len(set(question_ids))}")

    for duplicate in duplicate_items(config_keys):
        add_error(errors, QUIZ_PATH, f"config key `{duplicate}` is not unique", line_of(raw, f'"key": "{duplicate}"'))
    if len(set(config_keys)) != EXPECTED_QUESTIONS:
        add_error(errors, QUIZ_PATH, f"expected {EXPECTED_QUESTIONS} unique config keys, found {len(set(config_keys))}")

    return questions, set(config_keys)


def validate_no_free_text_option(
    errors: list[str],
    question_label: str,
    option_index: int,
    option: dict[str, Any],
    line: int | None,
) -> None:
    option_value = str(option.get("v", "")).strip().lower()
    if option_value in FREE_TEXT_VALUES:
        add_error(errors, QUIZ_PATH, f"{question_label}.options[{option_index}] declares free-text value `{option.get('v')}`", line)

    for field in sorted(FREE_TEXT_FIELDS):
        if bool(option.get(field)):
            add_error(errors, QUIZ_PATH, f"{question_label}.options[{option_index}] declares open/free-text field `{field}`", line)

    option_type = str(option.get("type", "")).strip().lower()
    if option_type in FREE_TEXT_TYPES:
        add_error(errors, QUIZ_PATH, f"{question_label}.options[{option_index}] declares free-text type `{option.get('type')}`", line)


def validate_clusters(
    quiz: dict[str, Any], questions: list[dict[str, Any]], raw: str, errors: list[str]
) -> None:
    clusters_raw = as_list(quiz.get("clusters"), "clusters", errors, raw)
    if len(clusters_raw) != EXPECTED_CLUSTERS:
        add_error(
            errors,
            QUIZ_PATH,
            f"`clusters` must contain exactly {EXPECTED_CLUSTERS} entries, found {len(clusters_raw)}",
            line_of(raw, '"clusters"'),
        )

    cluster_ids: list[str] = []
    for index, value in enumerate(clusters_raw, start=1):
        if not isinstance(value, dict):
            add_error(errors, QUIZ_PATH, f"clusters[{index}] must be an object")
            continue
        cluster_id = value.get("id")
        if not isinstance(cluster_id, str) or not cluster_id:
            add_error(errors, QUIZ_PATH, f"clusters[{index}].id must be a non-empty string")
        else:
            cluster_ids.append(cluster_id)

    for duplicate in duplicate_items(cluster_ids):
        add_error(errors, QUIZ_PATH, f"cluster id `{duplicate}` is not unique", line_of(raw, f'"id": "{duplicate}"'))

    known_clusters = set(cluster_ids)
    counts: Counter[str] = Counter()
    for question in questions:
        question_id = str(question.get("id", "<missing id>"))
        cluster_id = question.get("cluster")
        question_line = line_of(raw, f'"id": "{question_id}"')
        if not isinstance(cluster_id, str) or not cluster_id:
            add_error(errors, QUIZ_PATH, f"{question_id}.cluster must be a non-empty string", question_line)
            continue
        if cluster_id not in known_clusters:
            add_error(errors, QUIZ_PATH, f"{question_id}.cluster references unknown cluster `{cluster_id}`", question_line)
            continue
        counts[cluster_id] += 1

    for cluster_id in cluster_ids:
        if counts[cluster_id] != EXPECTED_QUESTIONS_PER_CLUSTER:
            add_error(
                errors,
                QUIZ_PATH,
                f"cluster `{cluster_id}` must contain {EXPECTED_QUESTIONS_PER_CLUSTER} questions, found {counts[cluster_id]}",
                line_of(raw, f'"id": "{cluster_id}"'),
            )


def validate_config_template(
    quiz: dict[str, Any], config_keys: set[str], raw: str, errors: list[str]
) -> set[str]:
    template = as_object(quiz.get("config_object_template"), "config_object_template", errors, raw)
    template_keys = set(template)
    for key in sorted(config_keys - template_keys):
        add_error(errors, QUIZ_PATH, f"config_object_template is missing config key `{key}`", line_of(raw, f'"key": "{key}"'))
    for key in sorted(template_keys - config_keys):
        add_error(errors, QUIZ_PATH, f"config_object_template contains extra config key `{key}`", line_of(raw, f'"{key}"'))
    return template_keys


def validate_validation_rules(quiz: dict[str, Any], raw: str, errors: list[str]) -> None:
    rules = as_list(quiz.get("validation_rules"), "validation_rules", errors, raw)
    if len(rules) < MIN_VALIDATION_RULES:
        add_error(
            errors,
            QUIZ_PATH,
            f"`validation_rules` must contain at least {MIN_VALIDATION_RULES} rules, found {len(rules)}",
            line_of(raw, '"validation_rules"'),
        )
    rule_ids: list[str] = []
    for index, value in enumerate(rules, start=1):
        if not isinstance(value, dict):
            add_error(errors, QUIZ_PATH, f"validation_rules[{index}] must be an object")
            continue
        rule_id = value.get("rule")
        if not isinstance(rule_id, str) or not rule_id:
            add_error(errors, QUIZ_PATH, f"validation_rules[{index}].rule must be a non-empty string")
        else:
            rule_ids.append(rule_id)
        if not isinstance(value.get("desc"), str) or not value.get("desc"):
            add_error(errors, QUIZ_PATH, f"validation_rules[{index}].desc must be a non-empty string", line_of(raw, f'"rule": "{rule_id}"') if isinstance(rule_id, str) else None)
    for duplicate in duplicate_items(rule_ids):
        add_error(errors, QUIZ_PATH, f"validation rule `{duplicate}` is not unique", line_of(raw, f'"rule": "{duplicate}"'))


def extract_prompt_references(raw: str) -> list[tuple[int, str]]:
    references: list[tuple[int, str]] = []
    in_json = False

    for line_number, line in enumerate(raw.splitlines(), start=1):
        stripped = line.strip()
        if stripped.startswith("```"):
            in_json = stripped == "```json" if not in_json else False
            continue

        if in_json:
            for match in JSON_KEY.finditer(line):
                references.append((line_number, match.group(1)))
            continue

        if stripped.startswith("|"):
            cells = [cell.strip() for cell in stripped.strip("|").split("|")]
            if len(cells) >= 2 and cells[0].startswith("`{{"):
                for match in SNAKE_KEY.finditer(cells[1]):
                    references.append((line_number, match.group(0)))
            elif cells and "=" in cells[0]:
                key = cells[0].split("=", 1)[0].strip(" `")
                if SNAKE_KEY.fullmatch(key):
                    references.append((line_number, key))
            continue

        if stripped.startswith("###") and " aus " in stripped:
            for token in INLINE_CODE.findall(stripped.split(" aus ", 1)[1]):
                for match in SNAKE_KEY.finditer(token):
                    references.append((line_number, match.group(0)))

    return references


def validate_prompt_template(
    raw: str | None, config_keys: set[str], errors: list[str]
) -> None:
    if raw is None:
        return
    refs = extract_prompt_references(raw)
    referenced_keys = {key for _, key in refs}

    for line_number, key in refs:
        if key not in config_keys:
            add_error(errors, PROMPT_TEMPLATE_PATH, f"unknown config-key reference `{key}`", line_number)

    for key in sorted(config_keys - referenced_keys):
        add_error(errors, PROMPT_TEMPLATE_PATH, f"config key `{key}` is not referenced by prompt template")


def validate() -> list[str]:
    errors: list[str] = []
    quiz_raw = read_text(QUIZ_PATH, errors)
    prompt_raw = read_text(PROMPT_TEMPLATE_PATH, errors)
    quiz = load_quiz(quiz_raw, errors)
    if quiz is None or quiz_raw is None:
        return errors

    questions, config_keys = validate_questions(quiz, quiz_raw, errors)
    validate_clusters(quiz, questions, quiz_raw, errors)
    template_keys = validate_config_template(quiz, config_keys, quiz_raw, errors)
    validate_validation_rules(quiz, quiz_raw, errors)
    validate_prompt_template(prompt_raw, config_keys | template_keys, errors)
    return errors


def main() -> int:
    errors = validate()
    if errors:
        print("FAIL")
        for error in errors:
            print(f"- {error}")
        return 1
    print("PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
