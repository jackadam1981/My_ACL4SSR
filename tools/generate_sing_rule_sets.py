#!/usr/bin/env python3

import json
from pathlib import Path
from typing import Dict, List


REPO_ROOT = Path(__file__).resolve().parent.parent
PROVIDERS_DIR = REPO_ROOT / "providers"
OUTPUT_DIR = REPO_ROOT / "sing-rule-set"

RULE_MAP = {
    "DOMAIN": "domain",
    "DOMAIN-SUFFIX": "domain_suffix",
    "DOMAIN-KEYWORD": "domain_keyword",
    "DOMAIN-REGEX": "domain_regex",
    "IP-CIDR": "ip_cidr",
    "IP-CIDR6": "ip_cidr",
}


def parse_provider(provider_path: Path) -> Dict[str, List[str]]:
    parsed: Dict[str, List[str]] = {value: [] for value in RULE_MAP.values()}
    unsupported: List[str] = []

    for raw_line in provider_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line == "payload:" or line.startswith("#"):
            continue
        if not line.startswith("- "):
            continue

        entry = line[2:].strip()
        parts = [part.strip() for part in entry.split(",")]
        if len(parts) < 2:
            continue

        rule_type = parts[0]
        target = parts[1]
        mapped_key = RULE_MAP.get(rule_type)
        if not mapped_key:
            unsupported.append(entry)
            continue

        parsed[mapped_key].append(target)

    if unsupported:
        joined = "\n".join(f"  - {item}" for item in unsupported)
        raise ValueError(f"Unsupported rules in {provider_path.name}:\n{joined}")

    return {key: values for key, values in parsed.items() if values}


def build_rule_set(parsed: Dict[str, List[str]]) -> Dict[str, object]:
    return {
        "version": 4,
        "rules": [parsed],
    }


def main() -> None:
    if not PROVIDERS_DIR.is_dir():
        raise SystemExit(f"Providers directory not found: {PROVIDERS_DIR}")

    OUTPUT_DIR.mkdir(exist_ok=True)

    for provider_path in sorted(PROVIDERS_DIR.glob("*.yaml")):
        parsed = parse_provider(provider_path)
        rule_set = build_rule_set(parsed)
        output_path = OUTPUT_DIR / f"{provider_path.stem}.json"
        output_path.write_text(
            json.dumps(rule_set, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print(f"generated {output_path.relative_to(REPO_ROOT)}")


if __name__ == "__main__":
    main()
