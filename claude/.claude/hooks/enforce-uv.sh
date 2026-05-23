#!/usr/bin/env bash
# PreToolUse:Bash — block pip / bare python in uv-managed projects.
#
# Fires only when $CLAUDE_PROJECT_DIR/uv.lock exists. The escape hatch
# .claude/no-python-hooks short-circuits.
#
# Contract: Claude Code sends a JSON tool-use payload on stdin. We exit 0 to
# allow, or exit 2 with a stderr message to block (Claude treats exit 2 as a
# rejection and re-plans). Drop `set -e` so unexpected non-zero from any single
# pipeline doesn't masquerade as a block; we only exit non-zero via `block()`.

set -uo pipefail

project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"

[[ -f "$project_dir/.claude/no-python-hooks" ]] && exit 0
[[ -f "$project_dir/uv.lock" ]] || exit 0

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
command="$(printf '%s' "$input" | jq -r '.tool_input.command // ""')"
[[ -z "$command" ]] && exit 0

block() {
  printf 'Blocked: %s. Use %s instead.\n' "$1" "$2" >&2
  exit 2
}

# Match a bare tool at start-of-command, after a shell separator (`&&`, `||`,
# `;`, `|`), or following whitespace. Tool must be followed by whitespace or
# end-of-string so substrings inside paths/strings don't match.
matches_bare() {
  local tool="$1" cmd="$2"
  [[ "$cmd" =~ (^|\&\&|\|\||\;|\|)[[:space:]]*${tool}([[:space:]]|$) ]]
}

case "$command" in
  *"pip install"*|*"pip3 install"*)              block "pip install"        "uv add" ;;
  *"pip uninstall"*|*"pip3 uninstall"*)          block "pip uninstall"      "uv remove" ;;
  *"python -m pip"*|*"python3 -m pip"*)          block "python -m pip"      "uv add / uv remove" ;;
  *"python -m pytest"*|*"python3 -m pytest"*)    block "python -m pytest"   "uv run pytest" ;;
esac

# Pre-clear: allow anything that's already uv-managed.
case "$command" in "uv "*|"uvx "*) exit 0 ;; esac

for bare in pip pip3 python python3 pytest; do
  matches_bare "$bare" "$command" && block "bare '$bare'" "uv run $bare"
done
matches_bare ruff "$command" && block "bare 'ruff'" "uvx ruff"

exit 0
