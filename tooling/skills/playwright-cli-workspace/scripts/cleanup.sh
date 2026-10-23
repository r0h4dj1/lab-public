#!/usr/bin/env bash
# Tear down playwright-cli browser sessions and verify none survive.
#
# Usage:
#   cleanup.sh [session-name ...]
#
# Closes each named session, then close-all, then verifies against BOTH the CLI
# registry and the process table. An orphaned daemon is missing from the registry
# while still running, so the process check is the authoritative one. Escalates to
# kill-all only when a survivor is found. Exits non-zero if anything remains.

set -uo pipefail

survivors() {
  ps -eo pid,ppid,etime,command | grep '[c]liDaemon' || true
}

for session in "$@"; do
  echo "closing session: $session"
  playwright-cli -s="$session" close >/dev/null 2>&1 || true
done

playwright-cli close-all >/dev/null 2>&1 || true

if [ -z "$(survivors)" ]; then
  echo "clean: no daemon processes remain"
  exit 0
fi

echo "stale daemons detected, escalating to kill-all:"
survivors
playwright-cli kill-all || true

remaining="$(survivors)"
if [ -n "$remaining" ]; then
  echo "FAILED: daemons still running after kill-all:" >&2
  echo "$remaining" >&2
  exit 1
fi

echo "clean: stale daemons reaped"
