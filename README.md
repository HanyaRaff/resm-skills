# resm-skills — Antigravity & AI Agent Skills Collection

Personal collection of modular **AI Agent Skills** (`SKILL.md` progressive-disclosure packages) and global bridge rules built for **Google Antigravity**, **Obsidian**, and modern full-stack engineering workflows.

---

## Repository Structure

```text
resm-skills/
├── skills/                   # Modular agent skills (<skill-name>/SKILL.md)
│   ├── llm-wiki/             # Karpathy LLM Wiki + Obsidian Personal Vault Bridge
│   ├── brainstorming/        # Socratic pre-build alignment & design specs (obra/superpowers)
│   ├── bmad-brainstorming/   # Multi-technique creative ideation & composer (BMAD-METHOD)
│   ├── obsidian-memory/      # Developer project memory & daily dev logs in Obsidian
│   ├── accessibility/        # WCAG 2.1/2.2 & accessible UI patterns
│   ├── best-practices/       # Clean architecture & security fundamentals
│   ├── guidelines-code/      # Code clarity & implementation standards
│   ├── performance/          # Core Web Vitals, RUM & runtime optimization
│   ├── seo/                  # Technical SEO & structured data
│   ├── universal-guidelines/ # Cross-stack engineering rules
│   └── web-quality-audit/    # Automated multi-axis web quality audit + scripts
├── rules/
│   └── AGENTS.md             # Global rule bridging Obsidian Personal Hub Vault across workspaces
├── prompts/
│   └── commit-message.md     # Conventional commit message prompt template
└── install.ps1               # One-command installer for ~/.gemini/config/
```

---

## Featured Workflows: Ideation & Second Brain

| Skill | Purpose | Trigger / When to Use |
| :--- | :--- | :--- |
| **[`llm-wiki`](./skills/llm-wiki/SKILL.md)** | Adapted from [Andrej Karpathy's LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) & connected to **Obsidian**. Maintains immutable `raw/` sources, compiled `wiki/` graphs (`index.md`, `log.md`, `sources/`, `entities/`, `concepts/`, `syntheses/`), and cross-vault `Personal` profile lookup via `obsidian://` deep links. | Ingesting notes/PDFs/articles, querying your wiki with file-back synthesis, linting contradictions/orphans, or updating your Personal profile vault. |
| **[`brainstorming`](./skills/brainstorming/SKILL.md)** | Upstream skill from [`obra/superpowers`](https://github.com/obra/superpowers). Drives one-question-at-a-time Socratic discovery, concrete architectural trade-offs, optional browser visual mockups, and approved design docs before any code gets written. | Before creating features, designing architectures, or planning non-trivial changes. |
| **[`bmad-brainstorming`](./skills/bmad-brainstorming/SKILL.md)** | Upstream skill from [`bmad-code-org/BMAD-METHOD`](https://github.com/bmad-code-org/BMAD-METHOD). Facilitates high-volume divergent ideation across structured creative lenses in **Facilitator**, **Creative Partner**, or **Autonomous** stances, complete with an interactive HTML session composer (`assets/brain-selector.html`). | When you say *"help me brainstorm"* or *"help me ideate"* to push well past obvious ideas. |
| **[`obsidian-memory`](./skills/obsidian-memory/SKILL.md)** | Per-project developer memory inside Obsidian (`10_Inbox` → `50_Projects`), logging engineering decisions, snippets, and troubleshooting fixes. | Saving project decisions, fixes, snippets, or daily engineering progress. |

---

## Engineering & Web Quality Skills

| Skill | Focus |
| :--- | :--- |
| **[`accessibility`](./skills/accessibility/SKILL.md)** | WCAG compliance, keyboard navigation, ARIA patterns (`references/WCAG.md`, `A11Y-PATTERNS.md`). |
| **[`best-practices`](./skills/best-practices/SKILL.md)** | Secure, maintainable engineering standards (`references/SECURITY.md`). |
| **[`performance`](./skills/performance/SKILL.md)** | Frontend/web performance measurement & Real User Monitoring (`MEASUREMENT.md`, `RUM.md`). |
| **[`seo`](./skills/seo/SKILL.md)** | Technical SEO, metadata, and JSON-LD structured data (`STRUCTURED-DATA.md`). |
| **[`web-quality-audit`](./skills/web-quality-audit/SKILL.md)** | End-to-end web quality audit workflow with helper analysis script (`scripts/analyze.sh`). |
| **[`guidelines-code`](./skills/guidelines-code/SKILL.md)** & **[`universal-guidelines`](./skills/universal-guidelines/SKILL.md)** | Concise, cross-project coding conventions. |

---

## Quick Installation (Google Antigravity)

### Option 1: PowerShell Installer (Windows)
Clone the repo and install all skills (plus the optional Obsidian Personal Vault global bridge rule) into `~/.gemini/config/`:

```powershell
git clone https://github.com/HanyaRaff/resm-skills.git
.\resm-skills\install.ps1 -IncludeRules
```

Install only specific skills:

```powershell
.\resm-skills\install.ps1 -Skills llm-wiki, brainstorming, bmad-brainstorming
```

### Option 2: Reference Directly via `skills.json`
Point `.agents/skills.json` (workspace) or `~/.gemini/config/skills.json` (global) at your local clone so updates via `git pull` take effect immediately:

```json
{
  "entries": [
    { "path": "~/resm-skills/skills" }
  ]
}
```

---

## Credits & Upstream Sources
- **`llm-wiki`**: Operationalized from [Andrej Karpathy's `llm-wiki.md` gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) (original preserved in [`skills/llm-wiki/references/karpathy-llm-wiki.md`](./skills/llm-wiki/references/karpathy-llm-wiki.md)), designed to pair seamlessly with Obsidian Graph View, Bases, and [`GD4AI/obsidian-llm-wiki`](https://github.com/GD4AI/obsidian-llm-wiki).
- **`brainstorming`**: [`obra/superpowers`](https://github.com/obra/superpowers/tree/main/skills/brainstorming).
- **`bmad-brainstorming`**: [`bmad-code-org/BMAD-METHOD`](https://github.com/bmad-code-org/BMAD-METHOD/tree/main/skills/bmad-brainstorming).