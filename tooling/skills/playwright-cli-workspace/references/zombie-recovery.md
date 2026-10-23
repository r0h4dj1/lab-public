# Diagnosing and Recovering Orphaned playwright-cli Sessions

Reference for the case where a browser session has escaped the CLI's registry.
Read this when
`playwright-cli list` disagrees with the process table, or when browsers appear
to survive an
agent session.

## Symptom

`playwright-cli list` reports `(no browsers)` while `ps` shows live `cliDaemon`
processes and a
Chrome tree. `close` and `close-all` have no effect, because they resolve
sessions through the
registry the daemon has already dropped out of.

## Mechanism

Each session owns two Unix sockets under `$TMPDIR/pw-<hash>/`:

| Path | Purpose |
| --- | --- |
| `cli/<workspace-hash>-<session>.sock` | how the CLI finds the daemon |
| `browser/browser-<id>.sock` | how the daemon talks to the browser |

The daemon binds `cli/<workspace-hash>-<session>.sock` by session name. When a
second run derives
the same session name, it rebinds that path — the first daemon keeps the
now-unlinked inode and
becomes unreachable, though its browser keeps running. The CLI socket directory
is also cleared
when a session ends cleanly, which strands any daemon that was still alive at
that moment.

Because the browser is launched with `handleSIGINT: false` and
`handleSIGTERM: false`, ending the
owning agent session does not signal it. Orphans reparent to PID 1.

## Diagnostic commands

```bash
# authoritative check: live daemons, their parent, and age
ps -eo pid,ppid,etime,command | grep '[c]liDaemon'

# browser trees, identified by their temp profile
ps aux | grep '[p]laywright_chromiumdev_profile'

# registry view (may disagree with the above)
playwright-cli list --json

# sockets: an empty cli/ alongside a populated browser/ means stranded daemons
ls -la "$TMPDIR"/pw-*/cli "$TMPDIR"/pw-*/browser

# what a daemon still holds open, including its cwd and socket paths
lsof -nP -p <daemon-pid>
```

A daemon with `PPID 1` has outlived its owner. Cross-check `etime` against the
age of the current
agent session.

## Recovery

```bash
playwright-cli kill-all
```

This kills daemons by process rather than through the registry, so it reaches
orphans that
`close-all` cannot. Child Chrome processes exit with their daemon. Verify
afterwards with the
`ps` check above.

## Residue left behind

`kill-all` does not clear these. All are inert, and the OS reclaims the temp
entries in time.

Paths below use `$TMPDIR` (on macOS a per-user directory under `/var/folders`,
on Linux normally
`/tmp`) and `$PLAYWRIGHT_CACHE`, the Playwright cache root —
`~/Library/Caches/ms-playwright` on
macOS, `~/.cache/ms-playwright` on Linux,
`%USERPROFILE%\AppData\Local\ms-playwright` on Windows.

| Location | Contents |
| ---------- | ---------- |
| `$TMPDIR/playwright_chromiumdev_profile-*` | dead browser profiles, ~11 MB each |
| `$TMPDIR/playwright-artifacts-*` | scratch dirs, usually empty |
| `$TMPDIR/pw-*/browser/*.sock` | stale sockets pointing at dead endpoints |
| `$PLAYWRIGHT_CACHE/b/browser@*` | stale registry entries naming dead endpoints |
| `$PLAYWRIGHT_CACHE/daemon/<hash>/*.err` | per-session daemon logs |

Inspecting a `b/browser@*` entry reveals the session title, launch options, and
`tracesDir` of
the session that created it — useful for identifying which project and task
orphaned a browser.

## Prevention

Assign a unique `-s=<session>` per run and close it in a `finally` step. See the
parent
`SKILL.md`, rules 2 and 3.
