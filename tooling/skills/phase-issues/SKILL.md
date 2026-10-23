---
name: phase-issues
description: Turns one phase of a build plan into a set of ready-to-work issues, written as observable behaviour with acceptance criteria. This skill should be used when the user wants to break down a phase, write the issues for a phase, or work out what actually needs doing in a phase. Optionally creates the issues on GitHub after review. Second skill in the chain: build-plan → phase-issues → issue-plan.
---

# Phase Issues

## What this produces

One file: `<docs>/delivery/phase-<N>/phase-<N>-issues-<slug>.md`.

It answers **what specifically has to be true for this phase to be done**. It
does not answer how
any of it gets built. That is `issue-plan`, the next skill in the chain.

A small phase can be one issue. A big phase is several. Do not split for the
sake of splitting,
and do not cram unrelated behaviour into one issue to keep the count down.

## Who the document is for

**A junior business analyst and a junior QA engineer.**

The BA should be able to say whether the issues cover the phase. The QA should
be able to
test every issue from the acceptance criteria alone, without asking a developer
what the feature
is meant to do.

Neither of them reads code. Neither of them should need to.

## Process

### 1. Find the build plan and the phase

Look for `<docs>/delivery/build-plan-*.md`. The filename carries a slug naming
its subject, so
match the pattern rather than an exact name, and ask which one if more than one
turns up.

If the user did not say which phase, ask — do not guess, and do not do all of
them at once.

If there is no build plan, say so and suggest `/build-plan` first. If the user
wants to press on
from a phase they describe verbally, that is fine, but note it in the doc.

### 2. Read three things

1. **The phase in the build plan** — the outcome sentence, what's true at the
   end, how we'll know
   it worked. This is the contract.
2. **The design docs** — the detail the build plan deliberately left out. Most
   acceptance criteria
   come from here.
3. **The existing code** — enough to know what already exists, so the issues
   describe real
   remaining work rather than work that is already done.

Where two design docs disagree about the behaviour, do not pick silently. Say
which one was
followed and put the conflict in **What you should check** — an acceptance
criterion built on the
stale doc is worse than no criterion, because someone will build to it.

> **The code informs accuracy, never content.** Read it so that the behaviour
> described is correct
> and the scope is real. Nothing technical learned from it goes in the document.
> No file paths, no
> component names, no framework names, no "this touches the scoring module". Any
> of that appearing
> in a draft gets deleted — it belongs in `issue-plan`.

### 3. Decide the split

Each issue should be one coherent piece of behaviour that could be finished and
checked on its
own.

Split when: two behaviours could ship separately, or a QA would test them in
unrelated ways, or
one part is genuinely uncertain and the rest is not.

Do not split when: the pieces are meaningless alone, or the only reason to
separate them is that
they touch different parts of the code. That is a technical split, and it is the
wrong axis here.

### 4. Propose the issue titles in chat, before writing

List the titles and one line each. Ask whether the split is right and whether
anything is missing.
Changing the split now costs a sentence; changing it after the file exists costs
a rewrite.

### 5. Write the file

`<docs>/delivery/phase-<N>/phase-<N>-issues-<slug>.md`

**The slug says what the phase covers.** Kebab-case, 30 characters at most, two
to four words,
taken from the phase's outcome sentence. It is there so that searching for the
subject finds the
file:

`Phase 2 — You can browse the catalogue and open a product page`
→ `phase-2-issues-catalogue-and-products.md`

### 6. Run the persona self-check (below)

### 7. Offer to create them on GitHub

Only after the user has read the doc. Ask first. Then, if they say yes, create
each issue with
`gh issue create`, and write the returned number back into the doc next to the
local ID:

```markdown
## P2-I1 — Feat: List all products on the catalogue page  (#47)
```

Issues only. Do not create milestones, do not apply labels, do not assign
anyone. Those vary per
repo and are not worth the failure modes.

## Issue IDs

`P<phase>-I<number>`, assigned in the doc immediately: `P2-I1`, `P2-I2`. They
exist so the issues
doc and the implementation plans can reference each other before anything is
pushed anywhere. The
GitHub number, once it exists, goes alongside — it does not replace the local ID.

## The document

```markdown
# Phase <N> Issues: <the phase's outcome sentence>

<N> issues. From `build-plan-<slug>.md` → Phase <N>.

## What you should check
- <where you chose to split, or not split, and why it could be wrong>
- <an assumption baked into the acceptance criteria>
- <anything the phase implies that no design doc actually states>

## P<N>-I1 — <Type>: <short description>

**Why:** <What this is worth, and to whom. One or two sentences. Not "because the phase needs it".>

**Story:** As a <who>, I want to <do this>, so that <this is true for me>.

**Acceptance criteria:**
- Given <situation>, when <action>, then <observable result>.
- Given <situation>, when <action>, then <observable result>.
- Given <edge case>, when <action>, then <observable result>.

**Depends on:** P<N>-I<x>  ← omit the line entirely if nothing blocks it

## P<N>-I2 — <Type>: <short description>
...
```

### Titles

`Type: Description`, where type is `Feat`, `Fix`, `Chore`, or `Docs`. The
description says what
the thing does, in the words a user would use.

- Good: `Feat: List all products on the catalogue page`
- Bad: `Feat: Implement catalogue index route`

### Acceptance criteria

Written as behaviour a person could watch happen. Given / When / Then, one line
each.

They are the shared contract between the author, the user, and whoever tests it
— so they have to be
unambiguous. "Works correctly" is not a criterion. "Loads quickly" is not a
criterion. "Given the
catalogue page, when it loads, then every in-stock product appears" is.

Cover the ordinary path first, then the edge cases that matter: empty states,
missing data, small
screens, failure. Do not pad with edge cases nobody will hit.

### About "What you should check"

Three to five specific things decided on the user's behalf. The split is usually
the most
important one, because it is the decision they are least likely to notice and
most likely to
disagree with.

Not this: "check the acceptance criteria are complete."
This: "I split listing and the product page into separate issues — if they're
really one job, say so."

## Before presenting: the persona self-check

**Mandatory.** After writing and before presenting, read the doc back twice.

**As the junior BA:** Do the issues together actually deliver the phase's
outcome sentence? Is
anything in the phase not covered by any issue? Is anything here that the phase
did not ask for?

**As the junior QA:** Could every criterion be tested without asking anyone a
question? Is any
criterion untestable because it describes an intention rather than a result?
Does any criterion
need knowledge of the code to make sense?

Rewrite what fails. Look especially for:

- Technical detail that leaked in from step 2. It happens, and this is where it
  gets caught.
- A criterion that says what the system *is* rather than what it *does*.
- A "Why" that restates the title instead of saying who benefits.
- Jargon a BA would have to look up.

## Then

Tell the user where the file is, ask whether they want the issues on GitHub, and
mention that
`/issue-plan` is the next step on any individual issue.

## Anti-patterns

| Don't | Do instead |
| ------- | ------------ |
| Put file paths, component or framework names in an issue | Describe the behaviour; save that for `issue-plan` |
| Add an "Implementation suggestions" section | Leave it out entirely — different skill, different doc |
| Split issues along code boundaries | Split along behaviour that could ship on its own |
| Write acceptance criteria as a task list | Write them as Given / When / Then |
| Write "works as expected" | Say what is observably true |
| Do every phase at once | One phase per run |
| Push to GitHub before the user has read the doc | Ask, every time |
| Invent edge cases to look thorough | Cover the ones that will actually happen |
