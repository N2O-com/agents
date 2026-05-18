#!/usr/bin/env bash
# Pre-push validation: outsource parsing to the official skills CLI.
# Fails if the CLI cannot enumerate every skill under skills/.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ ! -d skills ]]; then
  echo "[validate] ERROR: missing skills/ directory" >&2
  exit 1
fi

expected=$(find skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
if [[ "$expected" -eq 0 ]]; then
  echo "[validate] ERROR: no skill folders found under skills/" >&2
  exit 1
fi

output=$(npx --yes skills add . --list 2>&1)
echo "$output"

# Strip ANSI escapes, then look for "Found <N> skills".
found=$(
  printf '%s\n' "$output" \
    | sed 's/\x1b\[[0-9;]*m//g' \
    | grep -oE 'Found [0-9]+ skills?' \
    | grep -oE '[0-9]+' \
    | head -n1 \
    || true
)

if [[ -z "$found" ]]; then
  echo "[validate] ERROR: could not parse skill count from skills CLI output" >&2
  exit 1
fi

if [[ "$expected" != "$found" ]]; then
  echo "[validate] ERROR: expected $expected skill(s) under skills/, CLI found $found." >&2
  echo "[validate] A SKILL.md likely has malformed YAML frontmatter or missing 'name'/'description'." >&2
  exit 1
fi

echo "[validate] OK: $found skill(s) parsed by skills CLI"
