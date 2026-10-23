---
name: issue-plan
description: Turns one issue into an implementation plan — what to change, which files, in what order, and how to verify it. Works from an issue in a phase issues doc, or ad-hoc from a description of a feature or bug. This skill should be used when the user asks for an implementation plan, a technical plan, an approach, or how to build or fix something. Third skill in the chain: build-plan → phase-issues → issue-plan.
---

# Issue Plan

## What this produces

One file: the implementation plan for a single issue. It answers **how this gets
built**, in enough
detail that it could be handed to someone else without them coming back with questions.

This skill plans. It does not implement. Writing code is a separate, deliberate
act — see
**Hand-off** at the end.

## Who the document is for

**A junior developer who knows the language but has never seen this codebase.**

They should be able to work through the steps without guessing which file is
meant, and without
needing to reverse-engineer a decision that was already made for them.

## Two inputs, one skill

**From the chain (happy path).** The user names an issue — `P2-I1`, or "the
catalogue listing
issue". Find the phase's issues doc at
`<docs>/delivery/phase-<N>/phase-<N>-issues-*.md` — the
filename carries a slug naming its subject, so match the pattern rather than an
exact name. Read
that issue and treat its acceptance criteria as the definition of done. The plan
goes next to it:
`<docs>/delivery/phase-<N>/P<N>-I<n>-plan-<slug>.md`.

**Ad-hoc.** The user describes a feature or a bug with no issue behind it. That
is fine — plan it
anyway. Ask where the file should go, defaulting to `<docs>/delivery/adhoc/plan-<slug>.md`.

**The slug says what the plan covers.** Kebab-case, 30 characters at most, two
to four words, taken
from the issue title. It is there so that searching for the subject finds the file:

`P2-I5 — Feat: Show prices in the shopper's currency and let them switch it`
→ `P2-I5-plan-currency-switching.md`

Never assume a docs path. Look for `docs/` or `projects/<name>/docs/`; projects
get extracted into
standalone repos and this has to keep working afterwards.

## Two shapes, chosen automatically

Work out which one applies and **state which shape was used** when presenting
the plan.

- **Feature shape** — new behaviour, an enhancement, a refactor, a migration.
  The default, and
  what anything from the chain will be.
- **Bug shape** — something is broken. Adds a root cause section, and the first
  step is always
  reproducing it with a failing test.

If it is genuinely both, use the feature shape and note the defect inside it.

## Process

### 1. Investigate before writing anything

Not optional. A plan built on assumptions is worse than no plan, because it
looks trustworthy.

- **Read the real code.** Find the files that will actually change. Understand
  the patterns already
  in use — a plan that fights the existing conventions will be ignored or half-followed.
- **Check what is actually available.** Read `package.json`, `pyproject.toml`,
  `Cargo.toml`, or
  whatever applies, before naming any library. Do not assume a dependency is
  present because it
  usually is.
- **Confirm every path.** Every file referenced must be one actually opened, or
  explicitly marked
  `(new)`.
- **For bugs, reproduce it** or trace it precisely enough to name the cause.

### 2. Decide the approach, and note what was rejected

Where there was a real choice, pick one and record the alternative in **What you
should check**.
That is how the user gets to disagree with the decision rather than discover it
later in the code.

### 3. Write the file

### 4. Run the persona self-check (below)

### 5. Present it, then hand off

## The document

### Feature shape

```markdown
# Implementation Plan: P2-I1 — <issue title>

## What you should check
- <the approach decision you're least sure about, and what you rejected>
- <a constraint you're accepting that the user may not want to accept>
- <anything that will need revisiting later, and roughly when>

## What we're doing
<Two or three sentences. What changes, in plain terms.>

## How it fits
- Components touched: <the existing pieces involved and what changes about them>
- Data flow: <how data moves, only if it isn't obvious>

## Files
- `src/routes/catalogue/+page.svelte` (new) — the listing page
- `src/lib/ProductCard.svelte` (modify) — add a compact size variant

## Steps
- [ ] <one small step, doable and checkable on its own>
- [ ] <...>
- [ ] <...>

## How we'll verify
- Automated: <tests to add or run, named specifically>
- Manual: <what to click, and what you should see>

## Open questions
- <one to three genuine uncertainties, or "none">
```

### Bug shape

Same document, with one section added before **What we're doing**:

```markdown
## Root cause
- Found in: `src/lib/scoring.ts`
- What's wrong: <the actual mechanism, not the symptom>
- Why it wasn't caught: <the gap in tests or types that let it through>
```

And the first step is always:

```markdown
## Steps
- [ ] Reproduce the bug with a failing test
- [ ] <the fix>
- [ ] Confirm the test passes
```

## Steps should be atomic

One small change each, and each one leaves the codebase in a state where
stopping would be safe.
"Create the interface", "add the failing test", "implement the function" — not
"build the feature".

If a step needs a paragraph to explain, it is more than one step.

## Verification is not optional

Every plan says how the change gets proven. Name the actual test file and the
actual command. If
there is no automated way to check something, say that plainly and give the
manual steps instead —
do not pretend a test exists.

Where the issue came from the chain, the acceptance criteria are already
written. Verify against
those rather than inventing new ones.

## Before presenting: the persona self-check

**Mandatory.** After writing and before presenting, read it back as the junior developer.

- Could they start step 1 right now, without needing to ask the author anything?
- Is every file path real, or marked `(new)`?
- Is any library named that has not been confirmed as installed?
- Does any step hide a decision that should have been made for them?
- Does any step assume knowledge of a conversation they were not part of?

Rewrite what fails.

## Hand-off

Present the plan, state which shape was used, and then **stop**.

Recommend the user execute it in a fresh session, and give them the exact prompt
to paste. A clean
context window matters here: this session is full of planning deliberation,
rejected options and
investigation notes, and none of that helps during implementation — some of it
actively misleads.

Give them something like:

> Best executed in a fresh session. Paste this:
>
> ```text
> Implement the plan at docs/delivery/phase-2/P2-I1-plan-product-info-and-groups.md. Follow the steps in order. Stop after the last step and run the verification.
> ```

Do not start implementing, and do not offer to. If the user explicitly asks for
it to be built now,
that is their call — but the recommendation stands and it is worth one sentence.

## Anti-patterns

| Don't | Do instead |
| ------- | ------------ |
| Reference a file that was never opened | Confirm it exists, or mark it `(new)` |
| Assume a library is installed | Read the manifest first |
| Write pseudo-code or full code blocks | Name the real functions and classes involved |
| Say "update the controller" | Say `src/controllers/userController.ts` |
| Write one step that means "do the work" | Break it into steps that can each be checked |
| Skip verification because the change is small | Every plan says how it gets proven |
| Present a plan for a bug without a root cause | Investigate until the mechanism can be named |
| Start writing code at the end | Stop, and hand off to a fresh session |
| Silently pick between two real approaches | Name the rejected one in "What you should check" |
