---
name: llm-wiki
description: >-
  Build, maintain, query, and lint persistent Karpathy-style LLM Wikis inside
  Obsidian vaults (immutable raw/ sources, interlinked wiki/ pages, index.md,
  log.md, and cross-vault Personal profile context). Use whenever the user asks
  to ingest notes/articles/files into a wiki, query their wiki or second brain,
  lint or audit wiki health, record durable personal profile/behavior notes in
  their Personal vault, or bootstrap a new Obsidian wiki vault.
---

# Karpathy LLM Wiki (Obsidian Connected)

Maintain a **persistent, compounding markdown knowledge base** where the user curates sources and direction while the agent handles all summarizing, `[[wiki-link]]` cross-referencing, contradiction tracking, indexing, and upkeep.

For background philosophy and Obsidian setup tips, see [karpathy-llm-wiki.md](./references/karpathy-llm-wiki.md).

---

## 1. Vault Topology & Cross-Vault Personal Hub

- **Vaults Root:** `D:\Obsidian_Vault\`
- **Personal Hub Vault (`D:\Obsidian_Vault\Personal`):** Stores the user's durable profile, behavior, communication preferences, decision-making patterns, and goals.
  - When operating in *any* other vault (e.g., `D:\Obsidian_Vault\Brainstorm Idea`) or project where user context shapes decisions, **read `D:\Obsidian_Vault\Personal\wiki\index.md` first** and load only the specific pages relevant to the task.
  - Vaults stay strictly isolated on disk (never create junctions or symlinks between vaults).
  - Reference `Personal` pages from other vaults using clickable Obsidian URI links:
    `[Page Title](obsidian://open?vault=Personal&file=wiki%2Fconcepts%2Fpage-slug)`

---

## 2. Three-Layer Vault Architecture

Compatible out of the box with **Obsidian Graph View**, **Obsidian Bases**, **Dataview**, and the **Karpathy LLM Wiki (`karpathywiki`)** community plugin:

```text
<VaultRoot>/
├── GEMINI.md               # Layer 3: Vault Schema (domain conventions, tag list, workflow rules)
├── raw/                    # Layer 1: Immutable raw sources (READ-ONLY — never edit or delete)
│   └── assets/             # Local attachments/images clipped with raw notes
└── wiki/                   # Layer 2: Agent-owned compiled wiki
    ├── index.md            # Content catalog grouped by category (read FIRST on queries/ingests)
    ├── log.md              # Append-only chronological operation log
    ├── sources/            # Per-source summary + verbatim evidence quotes
    ├── entities/           # People, orgs, products, books, projects, places
    ├── concepts/           # Ideas, frameworks, patterns, habits, preferences
    └── syntheses/          # Filed-back query answers, comparisons, and decisions
```

### Page Frontmatter Standard
Every markdown file created under `wiki/sources/`, `wiki/entities/`, `wiki/concepts/`, or `wiki/syntheses/` **must** include YAML frontmatter:

```yaml
---
type: entity # entity | concept | source | synthesis
aliases:
  - Alternate Name
tags:
  - domain/subtopic
sources:
  - "[[sources/source-slug]]"
updated: YYYY-MM-DD
---
```

- **Protection rule (`reviewed: true`):** If an existing wiki page has `reviewed: true` in its frontmatter, **do not overwrite it silently**—propose updates to the user first.
- **Link rule:** Use Obsidian `[[wiki-links]]` (e.g. `[[concepts/second-brain|Second Brain]]` or `[[supervised-learning]]`) liberally across pages so Graph View edges reflect real conceptual connections.

---

## 3. Core Workflows

Always read the target vault's `GEMINI.md` before running an operation so domain-specific rules take precedence.

### A. Init / Bootstrap (`init`)
When setting up a new wiki vault:
1. Create `raw/assets/` and `wiki/{sources,entities,concepts,syntheses}/`.
2. Create `GEMINI.md` tailored to the vault's purpose, tag vocabulary, and ingestion preferences.
3. Initialize `wiki/index.md` (categorized sections) and `wiki/log.md` with an initial `## [YYYY-MM-DD] init | Initialized wiki` entry.
4. Remind the user to open the folder once in Obsidian (*Manage vaults → Open folder as vault*) if it isn't registered in `%APPDATA%\obsidian\obsidian.json` yet.

### B. Ingest (`ingest`)
When processing one or more files in `raw/` (or user-provided notes/links saved into `raw/` first):
1. **Verify immutability:** Ensure raw input lives in `raw/` (save clipped text/notes there first if needed) and never alter existing `raw/` files.
2. **Read source & media:** Read the source text. If it embeds local images (`![[img.png]]` or `![](assets/img.png)`), inspect relevant images with `view_file`.
3. **Check existing graph:** Read `wiki/index.md` to spot matching titles or `aliases` (avoid creating duplicate pages—merge into existing entity/concept pages instead).
4. **Write source page (`wiki/sources/<slug>.md`):** Summarize core claims, context, and key takeaways, plus a `## Mentions & Verbatim Quotes` section grounding key extractions.
5. **Update entities & concepts:** Create or revise affected pages in `wiki/entities/` and `wiki/concepts/`. Add bidirectional `[[wiki-links]]`. If new information contradicts an older claim, explicitly flag the tension with attribution to both `[[sources/...]]` pages rather than silently erasing history.
6. **Update `wiki/index.md` & `wiki/log.md`:** Add/update one-line catalog entries in `wiki/index.md`, and append:
   `## [YYYY-MM-DD] ingest | <Source Title> (<N> pages created, <M> updated)`

### C. Query & File-Back (`query`)
When answering questions from the wiki:
1. Read `wiki/index.md` first (plus `D:\Obsidian_Vault\Personal\wiki\index.md` if personal context applies) to select candidate pages, then read those pages.
2. Synthesize a clear answer grounded in the wiki with `[[wiki-links]]` (and `obsidian://` links for cross-vault references). Clearly distinguish wiki-backed facts from outside knowledge.
3. **Compound the exploration:** Whenever an answer produces a valuable comparison, synthesis, framework, or decision, offer to file it back into `wiki/syntheses/<slug>.md` (updating `wiki/index.md` and appending `## [YYYY-MM-DD] query | <Topic>` to `wiki/log.md`).

### D. Lint / Health Check (`lint`)
When asked to lint or audit the wiki:
1. Scan `wiki/index.md` and `wiki/**/*.md` for:
   - **Contradictions or stale claims** superseded by newer sources
   - **Dead `[[wiki-links]]`** pointing to non-existent pages
   - **Orphan pages** with zero inbound links from other wiki pages
   - **Missing `aliases` or `tags`** in YAML frontmatter
   - **Implicit concepts** mentioned across 3+ pages that deserve their own dedicated page
2. Present a concise report grouped by issue type and suggest high-value follow-up questions or gaps.
3. Upon confirmation (or if asked to auto-fix), repair issues while respecting `reviewed: true`, regenerate `wiki/index.md` if out of sync, and append `## [YYYY-MM-DD] lint | <Summary>` to `wiki/log.md`.

---

## 4. Obsidian App Integration

- **Live File Sync:** Obsidian watches the vault directory in real time—every edit to `wiki/` immediately updates Graph View, Backlinks, and Bases.
- **Open a Note in Obsidian UI:** Only when the user asks to open/view a note in Obsidian (or after bootstrapping), run in PowerShell:
  `Start-Process "obsidian://open?vault=<UriEncodedVaultName>&file=<UriEncodedRelativePath>"`
- **Obsidian Native CLI (Optional, Obsidian v1.12+):** Binary at `"$env:LOCALAPPDATA\Programs\Obsidian\Obsidian.com"`. Requires *Settings → General → Advanced → Command line interface* enabled in Obsidian. Check availability via `& "$env:LOCALAPPDATA\Programs\Obsidian\Obsidian.com" version`.
