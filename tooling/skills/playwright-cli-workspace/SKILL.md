---
name: playwright-cli-workspace
description: Workspace and lifecycle policy for playwright-cli in any project - keeps artifacts inside the project's tmp/playwright-cli directory, assigns a collision-proof session name per run, and guarantees browsers are closed and verified afterwards. This skill should be used alongside the playwright-cli skill whenever a browser session is opened, attached to, or cleaned up.
allowed-tools: Bash(playwright-cli:*) Bash(ps:*) Bash(git:*) Bash(mkdir:*)
---

# playwright-cli Workspace and Lifecycle Policy

This skill layers operational policy on top of the upstream `playwright-cli`
skill, and applies to
any project in which `playwright-cli` is run. The upstream skill documents
*what* the commands do;
this skill defines *how* to run them safely. Consult the `playwright-cli` skill's
`references/session-management.md` for command semantics.

Three rules govern every browser session: artifacts stay in the project,
sessions are named
uniquely, and browsers are closed and verified before handing work back. The
rules resolve paths
from the working project at run time, so they hold in a single-package
repository, a monorepo, or
a directory that is not a repository at all.

When a project documents its own artifact location or cleanup convention, that
convention wins;
apply the rules below only where the project is silent.

## Why this policy exists

The `playwright-cli` daemon launches browsers with `handleSIGINT: false` and
`handleSIGTERM: false`. This is deliberate — the browser survives between CLI
invocations. The
consequence is that **nothing reaps the browser when an agent session ends
without calling
`close`**. Orphaned daemons reparent to PID 1 and keep running indefinitely,
holding roughly
800 MB of RSS each.

Worse, when two runs in the same project derive the same session id, the second
daemon rebinds
the first daemon's socket path. The first daemon is then unreachable:
`playwright-cli list`
reports `(no browsers)` while a full Chrome process tree is still alive. Such a
session is
invisible to `close` and `close-all`, and only `kill-all` reclaims it.

Both failures are prevented by rules 2 and 3 below.

## Rule 1: Keep artifacts in the project

Store every artifact in the current project's `tmp/playwright-cli/` directory.
Do not use
`$TMPDIR`, `/tmp`, `/private/tmp`, or any other system temporary directory
unless explicitly
requested.

Before opening or attaching to a browser, resolve the project root and export
the output
directory. Treat the current working directory as the project root when it is
not a Git
repository. In a monorepo where the task is scoped to a single package, prefer
that package's
root over the repository root, so artifacts sit beside the code under test.

```bash
PLAYWRIGHT_PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
PLAYWRIGHT_ARTIFACT_DIR="$PLAYWRIGHT_PROJECT_ROOT/tmp/playwright-cli"
mkdir -p "$PLAYWRIGHT_ARTIFACT_DIR"
export PLAYWRIGHT_MCP_OUTPUT_DIR="$PLAYWRIGHT_ARTIFACT_DIR"
```

Each Bash invocation runs in a fresh shell, so exports do not persist between
commands. Prefix
the command that starts the session instead:

```bash
PLAYWRIGHT_MCP_OUTPUT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)/tmp/playwright-cli" \
  playwright-cli -s=<session> open https://example.com
```

Pass explicit output paths whenever a command accepts one, so scratch scripts, screenshots,
PDFs, videos, saved storage state, and downloads all land in the same directory:

```bash
playwright-cli -s=<session> screenshot --filename="$PLAYWRIGHT_ARTIFACT_DIR/page.png"
playwright-cli -s=<session> video-start "$PLAYWRIGHT_ARTIFACT_DIR/video.webm"
playwright-cli -s=<session> --raw snapshot > "$PLAYWRIGHT_ARTIFACT_DIR/before.yml"
```

Confirm the directory is ignored by version control before writing to it, and
never commit
artifacts when it is not:

```bash
git check-ignore -q "$PLAYWRIGHT_ARTIFACT_DIR" || echo "warning: artifact dir is not gitignored"
```

Before finishing, delete disposable files created by the current task and report
the paths of
any artifacts worth keeping. Never remove pre-existing or unrelated files from `tmp/`.

## Rule 2: Name the session explicitly on every command

Never rely on the default session. Two agents working in the same project will
derive the same
default id and clobber each other, orphaning one browser permanently.

Choose one session name at the start of the task, combining a short task slug
with a timestamp,
and state it in the transcript so later steps reuse it:

```bash
SESSION="checkout-flow-$(date +%H%M%S)"   # e.g. checkout-flow-142317
```

Pass `-s=$SESSION` on **every** invocation, including `close`.
`PLAYWRIGHT_CLI_SESSION` is not a
substitute under an agent harness, because each Bash call starts a fresh shell
and loses the
export.

```bash
playwright-cli -s=checkout-flow-142317 open https://example.com
playwright-cli -s=checkout-flow-142317 snapshot
playwright-cli -s=checkout-flow-142317 close
```

## Rule 3: Close and verify, always

Treat cleanup as a `finally` step: run it after success, after failure, and
after an interrupted
workflow. Never hand a task back with a Playwright-launched browser still running.

1. Stop any active tracing or video recording so output is flushed.
2. Run `delete-data` for persistent session data created solely for this task.
   Preserve profiles
   and saved state only when they are needed after the task.
3. Use `detach` for sessions created via `attach` — never close or kill a user's
   external browser.
4. Close every session launched during the task by name, then run `close-all` to
   catch strays.
5. Verify. Run this skill's `scripts/cleanup.sh`, or check both the registry and
   the process
   table by hand.

A clean `playwright-cli list` is **not** sufficient proof. An orphaned daemon is
absent from the
registry while still running, so confirm against the process table as well:

```bash
playwright-cli list
ps -eo pid,ppid,etime,command | grep '[c]liDaemon'
```

When either check finds a survivor, escalate:

```bash
playwright-cli kill-all
```

Then re-run both checks. For deeper diagnosis of stale sockets, temp profiles,
and cache
residue, read `references/zombie-recovery.md`.

## Bundled cleanup script

`scripts/cleanup.sh`, alongside this file, performs the full teardown-and-verify
sequence,
escalating to `kill-all` only when a survivor is found, and exits non-zero if
anything remains.
It depends only on `playwright-cli`, `ps`, and `grep`, so it runs from any
working directory and
needs nothing from the surrounding project.

Invoke it by its path within this skill directory, which varies with how the
skill is installed:

```bash
# close a named session, then verify nothing is left
<skill-dir>/scripts/cleanup.sh checkout-flow-142317

# verify and reap without a specific session in mind
<skill-dir>/scripts/cleanup.sh
```
