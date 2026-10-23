---
name: build-plan
description: Turns finished design work into a build plan — an ordered set of phases, each one ending in something genuinely usable. This skill should be used when the user says the design or planning is done and it is time to plan delivery, asks for a build plan, release plan, delivery plan, roadmap or phases, or asks what order to build something in. First skill in the chain: build-plan → phase-issues → issue-plan.
---

# Build Plan

## What this produces

One file: `<docs>/delivery/build-plan-<slug>.md`.

It answers **what are we delivering, in what order**. It does not answer how
anything gets built.
Technical decisions belong to `issue-plan`, further down the chain.

## Who the document is for

**A junior product manager or product owner who has never seen the codebase.**

That is the bar. They should be able to read the whole thing, understand what is
being built, and
say whether the order looks wrong — without asking anyone what a word means.

## Process

Follow these in order. Do not skip to writing the file.

### 1. Find where the docs live

Look for an existing docs folder near the work: `docs/`, or
`projects/<name>/docs/`. Never assume
a path — projects get extracted out of the monorepo into standalone repos, and
the skill has to
keep working after that. If there is no obvious docs folder, ask.

The plan goes at `<docs>/delivery/build-plan-<slug>.md`. Create `delivery/` if needed.

**The slug says what this plan covers.** Kebab-case, 30 characters at most, two
to four words,
taken from the release or the project rather than from the doc type. It is there
so that searching
for the subject finds the file:

- `build-plan-site-rebuild.md`
- `build-plan-billing-migration.md`
- `build-plan-mobile-app-v1.md`

Do not restate the type (`build-plan-plan`), and do not reach for a date or a
version number unless
that is genuinely what distinguishes this plan from another one.

### 2. Read the design work first

Read what already exists before asking anything: product brief, design doc,
architecture notes,
JTBD statement, Shape Up pitch, assumption audit, whatever is there. For work on
an existing
codebase, look at the code too, enough to know what is already built.

Look for: what is being built, who for, what is explicitly out of scope, and any
constraints that
force build order.

**When the docs contradict each other, say so.** Older docs go stale — a product
brief may still
list decisions that an architecture doc has since made. Work out which one is
current, use it, and
put the conflict in **What you should check** naming both documents. Do not
quietly average them,
and do not assume the newest file is the right one.

**When the design work is not actually finished, name what's missing.** If a
design doc lists
deliverables that do not exist yet, say which ones and which phases they block.
Keep them out of
the plan — they are design work, not delivery — but a plan that pretends its
prerequisites are met
is a plan that stalls in week two.

### 3. Settle the horizon

Ask which one this plan covers, unless it is already obvious:

- the first genuinely usable release, or
- the whole thing

**Default to the nearer horizon.** Short plans get reviewed properly. Long plans
get skimmed, and
their later phases are guesses that get rewritten anyway.

### 4. Ask only about real gaps

Do not ask what the design docs already answer. Work out what is genuinely
unknown, then ask about
that — and only that.

Batching a few related questions is fine where the tooling supports it, and
usually kinder than a
slow interrogation. What matters is that every question is one the documents
genuinely left open,
and that questioning stops as soon as the phases can be written. Where the
answer to one question
decides whether another is worth asking, ask those in sequence.

### 5. Propose the phases in chat, before writing anything

Show the draft phase list as plain text in the conversation: just the phase
names and one line
each. Ask whether the shape and order are right.

This is the cheapest moment to change direction. Once a file exists it feels decided.

### 6. Write the file, then run the persona self-check below

## What a phase is

**A phase ends with something someone can use, open, or show off.** The phase is
named by that
outcome, written as a sentence addressed to the reader:

- `Phase 2 — You can browse the catalogue and open a product page`
- `Phase 3 — You can add something to a basket and check out as a guest`

Where that sentence cannot be written, the phase is wrong-shaped. Say so rather
than inventing a
vague name.

### Groundwork phases

Work nobody can see — repo setup, deploy pipeline, a data model with no screens
— is allowed as
its own phase, but only when explicitly labelled:

```markdown
### Phase 1 — Groundwork: the site builds and deploys
Labelled groundwork because nothing here is user-visible.
What this unblocks: every phase after it.
```

A groundwork phase must always state what it unblocks. If it does not unblock
anything specific,
it should not exist yet.

### Ordering

Order by what genuinely must exist before what, and by what would be most
valuable to see working
early. Where the order is a real choice rather than a constraint, say so in
**Why this order** so
the user can push back.

## Do not put sizing in the plan

No time estimates, no appetite, no t-shirt sizes. A guess made before the work
is understood is
noise. How big a phase really is becomes clear when `phase-issues` turns it into
issues — nine
issues says more than an early "L" ever would.

## The document

```markdown
# Build Plan: <project or release name>

## What you should check
- <a judgement call you made that you are least sure about, and what changes if it's wrong>
- <an assumption you had to invent because nothing said otherwise>
- <anything that came from conversation rather than from a written design doc>

## What we're building
<One short paragraph. What exists at the end of all the phases, and who it's for.>

## Phases

### Phase 1 — <outcome sentence>
What's true at the end:
- <plainly observable fact>
- <plainly observable fact>
How we'll know it worked: <the signal that this phase is done and good>

### Phase 2 — <outcome sentence>
...

## What we're not doing
- <explicit cut, and one clause on why>

## Risks and unknowns
- <the thing that could make a phase go badly or turn out bigger than it looks>

## Why this order
<Two or three lines. What forced the sequence, and where the order was a choice.>
```

### About "What you should check"

This block is the reason the user will actually review the doc instead of
nodding at it. Give it
real content: three to five specific things, each one a decision made on the
user's behalf.

Not this: "check the phases are correct". That is worthless.
This: "I put install guides in Phase 4, not Phase 2 — check that's the right call."

Having genuinely made no judgement calls means the problem is not yet understood
well enough.

## Before presenting: the persona self-check

**This step is mandatory.** After writing the doc and before presenting it, read
it back as the
junior PM. Line by line.

For each line ask: would they understand this without looking anything up, and
does it tell them
something they can act on?

Rewrite anything that fails. Common failures to look for:

- A word they would not use in conversation. Cut it or say the plain version.
  The dangerous ones
  are the words that appear on every page of the design docs — "headless",
  "SKU", "metaobject",
  "walking skeleton" — because by the time the plan gets written they feel like
  ordinary English.
  They are not. The reader has not read those docs.
- An acronym or product-internal term that appears without explanation.
- A framework, library or hosting product named where the outcome would do instead.
- A phase named after a technical component rather than an outcome.
- A "risk" that is actually a task.
- A sentence that says something is important without saying what it does.

Drift happens while writing. That is why this is a separate pass, not something
to assume was
handled along the way.

## Then

Tell the user where the file is, and that the next step is `/phase-issues` on
whichever phase
they want to start.

## The plan is a snapshot

It is not a living document. There is no status tracking, no progress column, no
changelog. When
reality diverges far enough that the plan is wrong, write a new one.

## Anti-patterns

| Don't | Do instead |
| ------- | ------------ |
| Write the file before proposing phases in chat | Propose, get a reaction, then write |
| Ask questions the design docs already answer | Read first, ask about genuine gaps only |
| Name a phase after a component or layer | Name it after what someone can do at the end |
| Let a phase end with nothing usable | Reshape it, or label it groundwork and say what it unblocks |
| Add estimates or appetite | Leave sizing to issue count in `phase-issues` |
| Explain how something will be built | That's `issue-plan`'s job |
| Fill "What you should check" with generic prompts | Name the specific calls that were made |
| Skip the persona self-check because the draft reads fine | Run it anyway — the author is not the reader |
