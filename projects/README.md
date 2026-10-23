# Projects

Active projects, one flat folder each, named with a category prefix (`web-`,
`mobile-`, `game-`, `lib-`). Each project keeps its own design docs, so its
full context travels with it if it is extracted to a dedicated repo.

> **Redacted in the public copy.** The private repo holds the active projects.

A typical project looks like this:

```text
projects/web-example/
├── README.md          # definition, current status, intended destination
├── docs/
│   ├── product-brief.md
│   ├── architecture.md
│   ├── specs/
│   └── delivery/      # build-plan → phase-issues → issue-plan output
└── src/
```
