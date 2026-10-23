# Lab

A personal monorepo for exploration, active projects, shared AI tooling, and
personal knowledge.

> **Public snapshot.** This is a copy of my private `lab` monorepo, shared so
> people can see how I work with AI coding agents. The tooling is real and in
> daily use. Ideas and active projects stay private, so `brain/` and
> `projects/` contain only a README describing what goes there.

## For Visitors

I do most of my development with Claude Code and Codex. This repo is where I
keep what makes them useful across projects: agent skills, workflow processes
and conventions. They live in one place, so an improvement reaches every
project at once.

Worth a look:

- **[Delivery chain](tooling/skills/README.md#the-delivery-chain):** three
  skills I wrote ([`build-plan`](tooling/skills/build-plan/SKILL.md),
  [`phase-issues`](tooling/skills/phase-issues/SKILL.md),
  [`issue-plan`](tooling/skills/issue-plan/SKILL.md)) that turn finished design
  docs into a phased build plan, then issues with acceptance criteria, then a
  step-by-step implementation plan. Each one writes for a specific reader and
  stops for review before the next.
- **[One source, two agents](tooling/skills/README.md#why-centralized):** skills
  are defined once in `tooling/skills/` and linked into `.claude/skills/` and
  `.agents/skills/`, so Claude Code and Codex read the same files.
- **[`playwright-cli-workspace`](tooling/skills/playwright-cli-workspace/SKILL.md):**
  a skill I wrote that gives every browser automation run its own session name
  and artifact folder, and checks the browser is closed afterwards.
- **[Processes](tooling/processes/):** written workflows for idea to design,
  doc writing and issue writing.
- **[Skill sources](tooling/skills/README.md#skill-sources):** which skills I
  wrote and which are vendored, with upstream links and licenses.

| Path | In this copy |
| ------ | -------------- |
| `tooling/` | Complete |
| `brain/`, `projects/` | Redacted, README only |
| `templates/`, `extracted/` | Not created yet |

The rest of this README is unchanged from the private repo.

## What This Is

This monorepo is a unified personal "lab" and single source of truth, replacing
a split setup of a standalone "second-brain" repo and individual project repos.
It solves two core problems: design docs no longer require manual syncing
between a central brain and individual codebases, and shared AI workflow
infrastructure (skills, commands, hooks, processes) propagates improvements to
all projects instantly.

The lifecycle follows a one-way extraction model. All projects begin here as
low-friction experiments. When a project is ready to ship, it is permanently
extracted to its own dedicated repository using `git subtree split`. Active
development then moves entirely to the new repo, leaving a minimal pointer in
`extracted/` for discoverability.

## Directory Structure

```text
lab/
├── README.md
├── brain/                     # ideas, notes, cross-cutting design thinking
│   ├── ideas/                 # pre-project brainstorming
│   ├── notes/                 # general personal knowledge
│   └── patterns/              # reusable design/architectural patterns
├── projects/                  # active projects, flat structure
│   └── {project-name}/
│       ├── docs/              # project-specific design docs
│       ├── src/               # or web/, mobile/, game/, etc.
│       └── README.md
├── tooling/                   # shared AI workflow infrastructure
│   ├── skills/                # SKILL.md files
│   ├── commands/              # slash commands
│   ├── hooks/                 # hooks
│   ├── prompts/               # prompt templates
│   └── processes/             # workflows: idea→design, issue creation, doc writing
├── templates/                 # scaffolds for starting new projects
├── extracted/                 # markdown stubs for projects moved to dedicated repos
└── .gitignore
```

The directory structure separates abstract knowledge, active projects, shared
workflows, and project lifecycle states:

- `brain/`: Non-executable personal knowledge. Includes `ideas/` for pre-project
  brainstorming, `notes/` for general knowledge, and `patterns/` for reusable
  architectural patterns.
- `projects/`: Self-contained active projects in a flat structure. Each project
  holds its own source code and project-specific design documentation.
- `tooling/`: Top-level shared developer infrastructure. Houses custom agent
  instructions (`skills/`), slash commands (`commands/`), automation triggers
  (`hooks/`), reusable templates (`prompts/`), and workflow guidelines
  (`processes/`).
- `templates/`: Baseline scaffolds for initializing new projects.
- `extracted/`: Markdown stubs referencing projects migrated to dedicated
  external repositories.

## Conventions

To keep the monorepo organized, adhere to these structural conventions:

- **Flat Project Naming:** All projects live under `projects/` using prefixes
  for quick categorization (e.g., `web-`, `mobile-`, `game-`, `lib-`).
- **Co-located Documentation:** All project-specific design and documentation
  must live in `projects/{project-name}/docs/`, not in `brain/`. When a project
  is extracted, its entire context and history travel with it.
- **Top-Level Tooling:** Executable developer environment assets are stored in
  `tooling/` instead of `brain/` to clearly separate runtime infrastructure from
  static notes.
- **Patterns vs. Processes:** `brain/patterns/` contains abstract design
  thinking and architectural shapes ("what" to build). `tooling/processes/`
  contains step-by-step operational workflows and action plans ("how" to build
  it).

## Workflows

### Markdown Formatting and Linting

Install the repository-local Markdown tooling once from the repository root:

```bash
npm install
```

Use `npm ci` instead when setting up from a fresh clone or recreating the exact
locked dependency tree.

Run both Markdown commands from the repository root:

```bash
npm run format:md
npm run lint:md
```

`format:md` applies safe automatic fixes to first-party Markdown. `lint:md`
checks the same files without modifying them. The configured scope excludes
dependencies, temporary files, generated agent-skill links, and vendored
content.

To lint one literal file without the repository-wide globs, pass a `:`-prefixed
path:

```bash
npm run lint:md -- --no-globs ":path/to/file.md"
```

### Starting a New Project

Select a category prefix, copy a scaffold from `templates/` to `projects/`, and
immediately initialize a `README.md` detailing the project's scope, status, and
destination. Create a `docs/` directory to contain design proposals and
architectural plans before writing code.

### Updating Shared Tooling

Keep `tooling/` updates generic and backward-compatible. Test modifications to
skills, commands, or hooks across multiple projects to prevent regressions, and
document new workflow steps in `tooling/processes/`.

### Extracting a Project

To extract a mature project into a dedicated repository while preserving its git
history, execute:

```bash
cd lab
git subtree split --prefix=projects/foo -b foo-extracted
git clone . ../foo --branch foo-extracted
cd ../foo
git remote remove origin
git remote add origin git@github.com:owner/foo.git
git push -u origin main
```

Verify the new repository, delete `projects/foo/` from the lab, and add
`extracted/foo.md` containing the new URL, project status, and license.

## Per-Project README Requirements

Every project under `projects/` must maintain a `README.md` that explicitly declares:

- **Definition:** What the project is and its core scope.
- **Current Status:** Its active development phase or stability level.
- **Intended Destination:** Where the codebase will end up (e.g., private,
  open-source, or commercial release).

Declaring these properties early prevents scope creep and clarifies extraction
requirements. Intended destinations dictate architectural choices, credential
management, and dependency licenses during initial development. Keep these
fields updated to ensure the monorepo's global state remains accurate.
