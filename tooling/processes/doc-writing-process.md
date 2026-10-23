# Complex Doc Writing Process

A lightweight process for difficult, important, or long-running documents where
the work involves repeated drafting, decisions, and refinement. It keeps the
canonical document clean while preserving useful working context between
sessions.

## When To Use This

Use this process when a document is:

- Important enough that losing context would be costly.
- Detailed enough that open questions and final decisions can get mixed together.
- Likely to involve multiple AI sessions, review passes, or back-and-forth refinement.
- Stressful to edit directly because the polished doc becomes cluttered with
  temporary thinking.

Do not use this for small one-pass notes, simple checklists, or documents that
are already stable.

## 1. Create Two Documents

Use a canonical doc and a working doc.

Example:

- `project-name-spec.md`
- `project-name-working.md`

The canonical doc is the clean source of truth. It should contain only stable,
accepted content.

The working doc is the workshop. It can contain drafts, uncertainty, pending
decisions, rejected ideas, notes to future sessions, and anything that should
not bloat the canonical doc.

## 2. Start In The Working Doc

At the start of a session, read the working doc before editing the canonical doc.

Identify:

- Current status.
- Next actions.
- Open questions.
- Finalised decisions.
- Draft material that may be ready to promote.
- Superseded ideas that should not be reintroduced.

If the working doc is missing or stale, create or repair it before making major
changes to the canonical doc.

## 3. Draft And Debate In The Working Doc

Use the working doc for:

- Rough drafts.
- Alternative approaches.
- Notes from the current session.
- Decisions still being debated.
- Things that need user confirmation.
- Risks, constraints, and unresolved tradeoffs.
- Material that may be useful later but is not ready for the canonical doc.

The working doc is allowed to be messy, but it should still be structured enough
that a future session can understand it quickly.

## 4. Promote Only Finalised Content

When something is decided, write the clean version into the canonical doc.

After promotion, mark the related working note as `Promoted` instead of
immediately deleting it. This preserves the decision trail and prevents the same
question being reopened accidentally.

Remove old working notes later only when they are no longer useful.

## 5. Use Simple Status Labels

Use these labels in the working doc:

- `Open`: still unresolved.
- `Proposed`: likely direction, not yet final.
- `Decided`: decision has been made.
- `Promoted`: decision has been added to the canonical doc.
- `Superseded`: no longer current, kept only for context.
- `Blocked`: cannot proceed without external input.

Avoid inventing too many labels. The goal is clarity, not workflow overhead.

## 6. Suggested Working Doc Structure

```md
# Working Notes

## Current Status

## Next Actions

## Open Questions

## Decisions To Make

## Finalised Decisions To Promote

## Draft Material

## Superseded Ideas

## Session Notes
```

Keep the newest and most important information near the top. Archive older
session notes lower down if they are still useful.

## 7. Rules For AI Sessions

When using Codex or another agentic AI assistant:

- Read the working doc first for complex docs.
- Do not put scratch notes, pending questions, or session memory into the
  canonical doc.
- Make uncertain changes in the working doc first.
- Ask for confirmation when a decision affects the direction of the canonical doc.
- Promote only final, stable decisions into the canonical doc.
- End each session by updating the working doc handoff.

The canonical doc is the source of truth. The working doc is the memory and workspace.

## 8. End Of Session Handoff

At the end of a session, update the working doc with:

- What changed.
- What was finalised.
- What was promoted to the canonical doc.
- What remains unresolved.
- Recommended next action.

This handoff is the re-entry point for the next session.
