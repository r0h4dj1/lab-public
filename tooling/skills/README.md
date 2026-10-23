# Shared Project-Level Agent Skills

This directory serves as the centralized, canonical source of truth for **shared
project-level agent skills** in this monorepo.

## Why Centralized?

Different AI coding agents expect project-level skills in different
repository-local folders:

* **Claude Code:** `/.claude/skills/`
* **Codex:** `/.agents/skills/`

To prevent configuration drift, all canonical skills are defined once in
`./tooling/skills/` and then deployed to **both** tool-specific directories
(`.claude/skills/` and `.agents/skills/`) via file-system links (junctions on
Windows, symbolic links on Unix) for instant syncing.

> **Important: Edit `tooling/skills/` Directly**
> Always edit the files in `./tooling/skills/` directly. Do not edit files
> inside the generated target/link folders. While editing files inside linked
> folders will modify the underlying files on disk, working directly in the
> canonical path avoids IDE or agent confusion and keeps developer workflows
> clean and consistent.
>
> **Note on Version Control:**
> The generated target directories (`/.claude/skills/` and `/.agents/skills/`)
> are ignored in Git via `.gitignore`. Do not track these in version control;
> only the canonical `./tooling/skills/` directory should be committed and
> pushed to the remote repository. This ensures cross-platform compatibility and
> prevents duplicate files or broken links in other developers' environments.

---

## Skill Folder Structure

Each skill must live in its own subfolder and contain a `SKILL.md` file defining
its instructions:

```text
tooling/skills/
├── README.md               # This documentation
├── humanizer/
│   └── SKILL.md            # Canonical instructions for humanizer
├── build-plan/
│   └── SKILL.md            # Canonical instructions for build-plan
└── issue-plan/
    └── SKILL.md            # Canonical instructions for issue-plan
```

---

## The Delivery Chain

Three skills take finished design work to a plan a developer can execute. Each
writes one document for a specific reader and stops for review before the next.

| Skill | Input | Output | Written for |
| ------- | ------- | -------- | ------------- |
| `build-plan` | design docs | `docs/delivery/build-plan-<slug>.md` | junior PM / product owner |
| `phase-issues` | one phase | `docs/delivery/phase-N/phase-N-issues-<slug>.md` | junior BA / QA |
| `issue-plan` | one issue | `docs/delivery/phase-N/P1-I2-plan-<slug>.md` | junior developer |

Filenames lead with the type and end with a kebab-case slug (30 characters
max), so `P2-` finds a whole phase and `-plan-` finds every implementation plan.
Issue IDs are assigned locally so documents cross-reference before anything is
pushed; `phase-issues` adds the GitHub issue numbers after a push. `issue-plan`
also handles ad-hoc feature and bug planning outside the chain.

---

## Skill Sources

Skills are either authored in this repo or vendored from an upstream source.
Vendored skills may carry local edits; check upstream before pulling updates.
Keep upstream formatting intact; the Markdown lint configuration excludes the
vendored directories.

### Authored

| Skill | Notes |
| ------- | ------- |
| `build-plan` | Delivery chain, step 1 |
| `phase-issues` | Delivery chain, step 2 |
| `issue-plan` | Delivery chain, step 3 |
| `playwright-cli-workspace` | Workspace and lifecycle policy for `playwright-cli` |

### Vendored

| Skill | Upstream | Author | License |
| ------- | ---------- | -------- | --------- |
| `deep-research` | [affaan-m/ECC](https://github.com/affaan-m/ECC/tree/main/skills/deep-research) | Affaan Mustafa | MIT |
| `doc-coauthoring` | [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/doc-coauthoring) | Anthropic | See upstream |
| `humanizer` | [blader/humanizer](https://github.com/blader/humanizer) | Siqi Chen | MIT |
| `last30days` | [mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill/tree/main/skills/last30days) | Matt Van Horn | MIT |
| `skill-creator` | [anthropics/skills](https://github.com/anthropics/skills/tree/main/skills/skill-creator) | Anthropic | Apache-2.0 |
| `planning-with-files` | [OthmanAdi/planning-with-files](https://github.com/OthmanAdi/planning-with-files/tree/master/skills/planning-with-files) | Ahmad Othman Ammar Adi | MIT |
| `playwright-cli` | [microsoft/playwright-cli](https://github.com/microsoft/playwright-cli/tree/main/skills/playwright-cli) | Microsoft | Apache-2.0 |
| `ponytail`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-review` | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail/tree/main/skills) | Dietrich Gebert | MIT |
| `taste-skill` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill/tree/main/skills/taste-skill) | Leon Lin | MIT |

The current `last30days` runtime requires Python 3.12 or newer.

---

## Skill Deployment Setup

If a new skill is added to `./tooling/skills/`, you must rerun the appropriate
setup commands below to deploy it to the agent directories. Edits to existing
skills sync automatically through the links, so they do not require rerunning.

### Windows (PowerShell 7)

Run this PowerShell 7 script block from the repository root:

```powershell
# Deploy skills to both agent directories using junctions
$Targets = ".claude/skills", ".agents/skills"
foreach ($Target in $Targets) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
    Get-ChildItem -Path "tooling/skills" -Directory | ForEach-Object {
        $LinkPath = Join-Path $Target $_.Name
        if (-not (Test-Path $LinkPath)) {
            New-Item -ItemType Junction -Path $LinkPath -Value $_.FullName | Out-Null
        }
    }
}
```

### Unix / macOS / Linux (POSIX Shell)

Run this command from the repository root:

```bash
# Deploy skills to both agent directories using symbolic links
for target in .claude/skills .agents/skills; do
  mkdir -p "$target"
  for skill_dir in tooling/skills/*/; do
    skill_name=$(basename "$skill_dir")
    ln -sfn "$(pwd)/tooling/skills/$skill_name" "$target/$skill_name"
  done
done
```

---

## Cleaning Up / Resetting Setup

If you need to remove the deployed links, use the commands below. These commands
safely delete the file-system links **without** affecting the canonical skill
files in `./tooling/skills/`.

### Windows (PowerShell 7)

```powershell
# Remove junctions from both agent directories safely
$Targets = ".claude/skills", ".agents/skills"
foreach ($Target in $Targets) {
    if (Test-Path $Target) {
        Get-ChildItem -Path $Target | ForEach-Object {
            if ($_.Attributes -match "ReparsePoint") {
                Remove-Item -Path $_.FullName -Force
            }
        }
    }
}
```

### Unix / macOS / Linux (POSIX Shell)

```bash
# Remove symlinks from both agent directories
for target in .claude/skills .agents/skills; do
  if [ -d "$target" ]; then
    find "$target" -type l -exec rm {} +
  fi
done
```

---

## Deleting a Skill Permanently

If a canonical skill is no longer needed:

1. Delete the corresponding link from the tool-specific directories.
2. Delete the canonical source folder from `./tooling/skills/`.

For example, to permanently delete a skill named `old-skill`:

### Windows (PowerShell 7)

```powershell
# 1. Remove deployed links first
Remove-Item -Path ".\.claude\skills\old-skill" -Force
Remove-Item -Path ".\.agents\skills\old-skill" -Force

# 2. Delete the canonical source folder
Remove-Item -Path ".\tooling\skills\old-skill" -Recurse -Force
```

### Unix / macOS / Linux (POSIX Shell)

```bash
# 1. Remove deployed links first
rm -f .claude/skills/old-skill
rm -f .agents/skills/old-skill

# 2. Delete the canonical source folder
rm -rf tooling/skills/old-skill
```
