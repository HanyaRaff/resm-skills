# Obsidian Vault Integration (`bmad-brainstorming`)

All brainstorming logs, syntheses, and keepsakes produced by this skill are stored in the user's Obsidian vault at:

`D:\Obsidian_Vault\Brainstorm Idea`

## 1. Classification & Dedicated Topic Folders

Once the brainstorming topic and goal are clear, classify the session into one of the vault's category folders (or create a new numbered category folder if the user requests one) and bind `{doc_workspace}` to a **dedicated folder for the session**:

| Category Folder | Index Note (`[[wikilink]]`) | Tag Slug | When to Use |
|---|---|---|---|
| `01 - Software & Apps` | `[[Software & Apps]]` | `category/software-and-apps` | Apps, features, developer tools, AI systems, software ideas |
| `02 - Business & Strategy` | `[[Business & Strategy]]` | `category/business-and-strategy` | Products, startups, monetization, operations, strategy |
| `03 - Creative & Content` | `[[Creative & Content]]` | `category/creative-and-content` | Talks, writing, storytelling, games, art, media |
| `04 - Personal & Life` | `[[Personal & Life]]` | `category/personal-and-life` | Home, habits, learning, events, personal goals |
| `05 - Research & Exploration` | `[[Research & Exploration]]` | `category/research-and-exploration` | Open-ended ideation, wildcards, interdisciplinary research |

### Target `{doc_workspace}` Path Formula

```text
D:\Obsidian_Vault\Brainstorm Idea\<NN - Category>\YYYY-MM-DD - <Topic Title>\
```

Keep `<Topic Title>` human-readable and filesystem-safe (avoid `:`, `/`, `\`, `?`, `*`, `"`, `<`, `>`, `|`).

Inside `{doc_workspace}`, files follow these unique names (so Obsidian `[[wikilinks]]` never collide across folders):
- `<Topic Title> - Session Log.md` — Canonical running memlog of every idea, technique switch, question, insight, and decision (replaces `.memlog.md` when running in Obsidian Vault mode so it is directly visible in Obsidian's File Explorer and Graph View).
- `<Topic Title> - Brainstorm.md` — Synthesized themes, breakthroughs, convergence decisions, and actionable intent.
- `brainstorm.html` — Optional self-contained visual HTML keepsake.

*(If `_bmad/scripts/memlog.py` is active in a BMad-initialized repo, still write `<Topic Title> - Brainstorm.md` and `<Topic Title> - Session Log.md` into `{obsidian_topic_dir}` at wrap-up so the Obsidian vault stays complete.)*

## 2. Obsidian Memlog Format (`<Topic Title> - Session Log.md`)

When `_bmad/scripts/memlog.py` is not present in the workspace, initialize `{doc_workspace}/<Topic Title> - Session Log.md` directly with file tools using this exact Obsidian YAML frontmatter:

```yaml
---
title: "<Topic Title> - Session Log"
date: YYYY-MM-DD
type: brainstorm-log
skill: bmad-brainstorming
topic: "<topic>"
goal: "<goal>"
category: "<Category Name>"
mode: facilitator | partner | autonomous
status: in-progress
tags:
  - brainstorm
  - type/brainstorm-log
  - category/<category-slug>
  - status/in-progress
related:
  - "[[Brainstorm Hub]]"
  - "[[<Category Name>]]"
  - "[[<Topic Title> - Brainstorm]]"
---

# <Topic Title> — Session Log

> **Category:** [[<Category Name>]] · **Hub:** [[Brainstorm Hub]] · **Synthesis:** [[<Topic Title> - Brainstorm]]

## Entries
```

Append each turn's entries to `## Entries` in chronological order, one bullet per entry:
- `- [technique] Started **<Technique Name>**`
- `- [idea] <one-line gist>` *(in Creative Partner mode, add `(by user)` or `(by coach)`)*
- `- [question] <one-line gist>`
- `- [direction] <one-line gist>`
- `- [decision] <one-line gist>`
- `- [insight] <one-line gist>`

At wrap-up, update frontmatter `status: complete` and change tag `status/in-progress` to `status/complete`.

## 3. Obsidian Synthesis & Intent Note (`<Topic Title> - Brainstorm.md`)

Format the synthesis / intent note with rich Obsidian YAML Properties, hierarchical tags, and `[[wikilinks]]`:

```yaml
---
title: "<Topic Title> - Brainstorm"
date: YYYY-MM-DD
type: ideation-session
skill: bmad-brainstorming
category: "<Category Name>"
stance: facilitator | partner | autonomous
status: complete
techniques:
  - "<Technique 1>"
  - "<Technique 2>"
tags:
  - brainstorm
  - type/ideation-session
  - category/<category-slug>
  - status/complete
  - <1-3 topic tags in kebab-case>
related:
  - "[[Brainstorm Hub]]"
  - "[[<Category Name>]]"
  - "[[<Topic Title> - Session Log]]"
---
```

### `[[wikilinks]]` Rules

1. Link back to `[[<Category Name>]]`, `[[Brainstorm Hub]]`, and `[[<Topic Title> - Session Log]]`.
2. Link to any prior vault notes related to the topic (`[[Existing Note]]`) in both `related` frontmatter and inline body text.
3. Use `[[wikilinks]]` for standout named concepts or spin-off project candidates so future brainstorms or design docs (`brainstorming` skill) naturally connect to them in Obsidian's Graph View.

## 4. Indexing New Sessions

When creating a session folder (or finalizing `<Topic Title> - Brainstorm.md`), add/update an entry under `## Sessions` in `D:\Obsidian_Vault\Brainstorm Idea\<NN - Category>\<Category Name>.md` AND under `## Recent Sessions` in `D:\Obsidian_Vault\Brainstorm Idea\00 - Index\Brainstorm Hub.md`:

```markdown
- YYYY-MM-DD — [[<Topic Title> - Brainstorm]] (Log: [[<Topic Title> - Session Log]]) (`<Category Name>`, `bmad-brainstorming`) — <one-line gist>
```
