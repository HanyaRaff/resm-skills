# Obsidian Vault Integration (`brainstorming`)

All design documents and brainstorm outputs produced by this skill are stored in the user's Obsidian vault at:

`D:\Obsidian_Vault\Brainstorm Idea`

## 1. Classification & Dedicated Topic Folders

Classify each topic into one of the vault's category folders (or create a new numbered category folder if the user explicitly requests one), and create a **dedicated folder for the topic** inside that category:

| Category Folder | Index Note (`[[wikilink]]`) | Tag Slug | When to Use |
|---|---|---|---|
| `01 - Software & Apps` | `[[Software & Apps]]` | `category/software-and-apps` | Apps, features, components, APIs, architecture, AI/dev tools |
| `02 - Business & Strategy` | `[[Business & Strategy]]` | `category/business-and-strategy` | Products, startups, pricing, marketing, workflows, operations |
| `03 - Creative & Content` | `[[Creative & Content]]` | `category/creative-and-content` | Talks, articles, media, storytelling, games, visual design |
| `04 - Personal & Life` | `[[Personal & Life]]` | `category/personal-and-life` | Renovations, habits, travel, learning plans, personal projects |
| `05 - Research & Exploration` | `[[Research & Exploration]]` | `category/research-and-exploration` | Open-ended inquiries, experiments, technical/domain research |

### Target Path Formula

```text
D:\Obsidian_Vault\Brainstorm Idea\<NN - Category>\YYYY-MM-DD - <Topic Title>\<Topic Title> - Design.md
```

Keep `<Topic Title>` human-readable (Title Case, filesystem-safe — avoid `:`, `/`, `\`, `?`, `*`, `"`, `<`, `>`, `|`). Any companion notes (e.g., spike notes, visual mockup summaries, follow-up plans) for the same brainstorm go inside that same `YYYY-MM-DD - <Topic Title>\` folder.

If the user is ALSO working inside a software git repository and wants a repo-committed spec, save the canonical Obsidian note above AND write a copy to `docs/superpowers/specs/YYYY-MM-DD-<topic-slug>-design.md` if appropriate.

## 2. Obsidian YAML Properties, Tags, and `[[wikilinks]]`

Every saved note MUST begin with valid Obsidian YAML frontmatter (Properties):

```yaml
---
title: "<Topic Title> - Design"
date: YYYY-MM-DD
type: design-spec
skill: brainstorming
category: "<Category Name>"
size: small-change | project
status: draft | approved
project_path: "<optional workspace path if linked to a codebase>"
tags:
  - brainstorm
  - type/design-spec
  - category/<category-slug>
  - status/draft
  - <1-3 specific topic tags in kebab-case>
related:
  - "[[Brainstorm Hub]]"
  - "[[<Category Name>]]"
---
```

When the user approves the design doc, update `status: approved` and replace `status/draft` with `status/approved` in `tags`.

### `[[wikilinks]]` Rules

1. Include a header callout or metadata line linking back to `[[<Category Name>]]` and `[[Brainstorm Hub]]`.
2. Link to any prior related notes discovered in `D:\Obsidian_Vault\Brainstorm Idea` using `[[Note Name]]` both in the `related` frontmatter property and inline where referenced.
3. Wrap distinct reusable concepts, sibling modules, or follow-up documents in `[[wikilinks]]` where natural so Obsidian's Graph View connects related ideas across sessions.

## 3. Indexing New Sessions

Whenever you create a new design note in the vault, append a bullet link under `## Sessions` in `D:\Obsidian_Vault\Brainstorm Idea\<NN - Category>\<Category Name>.md` AND under `## Recent Sessions` in `D:\Obsidian_Vault\Brainstorm Idea\00 - Index\Brainstorm Hub.md`:

```markdown
- YYYY-MM-DD — [[<Topic Title> - Design]] (`<Category Name>`, `brainstorming`) — <one-line summary>
```
