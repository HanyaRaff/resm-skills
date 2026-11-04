# Wrap-Up: Synthesis & Artifacts

Load this when the user signals they're spent or the topic is mined out. `{doc_workspace}/.memlog.md` is the canonical record of the session — everything here derives from it.

## Synthesis

In Facilitator mode this is the one place your own creative contribution is welcome; in Creative Partner and Ideate-for-me you've been contributing all along, so just keep going. Run it in two moves, in order:

1. **Hand them the mirror first.** Reflect a vivid sampling of *their* ideas back — deliberately include the odd, random, or buried ones from earlier, not just the recent obvious ones (in Creative Partner mode the `(... by user)` tags tell you which were theirs). Ask what they see now: conclusions, synergies, themes, the few that actually matter. Let them connect first; their own pattern-recognition is the point.
2. **Then add the connections they would miss.** Lean in creatively — not new raw ideas, but the non-obvious links: this idea from technique one quietly solves that tension from technique four; these three are one idea wearing three hats; this wildcard is the real breakthrough.

Record the insights and chosen directions in the memlog (`- [insight] <insights + chosen directions>` appended to `{doc_workspace}/<Topic Title> - Session Log.md` in Obsidian Vault mode, or via `memlog.py append --type insight` when active). **Then mark the session log `status: complete` (and flip tag `status/in-progress` to `status/complete` in Obsidian frontmatter, or `memlog.py set --key status --value complete`)** — the session is done and must stop being offered for resume. Do this even if the user declines additional artifacts below.

## Artifacts & Obsidian Vault Note

**Always save the Obsidian Synthesis & Intent Note (`<Topic Title> - Brainstorm.md`)** in `D:\Obsidian_Vault\Brainstorm Idea\<NN - Category>\YYYY-MM-DD - <Topic Title>\<Topic Title> - Brainstorm.md` following [obsidian-vault.md](./obsidian-vault.md) — complete with Obsidian YAML Properties (`title`, `date`, `type`, `skill`, `category`, `stance`, `status`, `techniques`, `tags`, `related`), hierarchical tags, and `[[wikilinks]]` to `[[Brainstorm Hub]]`, `[[<Category Name>]]`, `[[<Topic Title> - Session Log]]`, and standout concepts — and register the session in both `<NN - Category>\<Category Name>.md` and `00 - Index\Brainstorm Hub.md`.

In **Ideate for me** (and headless), also produce the imaginative HTML keepsake automatically; in **Facilitator** and **Creative Partner**, additional artifacts beyond the Obsidian note are opt-in: ask what else they want, recommend the HTML keepsake, and generate only what they choose.

**Delegate heavy artifacts (like `brainstorm.html`) to a subagent.** By now the main context is full of the whole session — pass the subagent the spec below, the session log path (`{doc_workspace}/<Topic Title> - Session Log.md` or `{doc_workspace}/.memlog.md`), the output path inside `{doc_workspace}`, and "return ONLY the written file path."

- **Obsidian Synthesis & Intent Note (`<Topic Title> - Brainstorm.md` — always saved to vault).** Captures topic & goal, key themes/clusters, non-obvious breakthroughs, and chosen actionable directions with YAML Properties, tags, and `[[wikilinks]]` (per [obsidian-vault.md](./obsidian-vault.md)), ready for Obsidian Graph View and downstream specs.
- **Imaginative HTML keepsake (recommended companion).** A single self-contained `brainstorm.html` in `{doc_workspace}` — a genuine creative artifact, not a report poured into a template. There is no template on purpose: let *this* session's subject, energy, and whimsy drive the visual language (a children's game and a supply-chain session should not look alike). Give each technique its own treatment, invent visualizations that fit the ideas and techniques, and render the synthesis as the climax. Inline all CSS and any JS; no external dependencies. Open it once complete.
- **Offer other options they might want from it also based on context** — atomic idea notes (`[[Idea Name]]`) in the same folder, a pitch, a one-pager, or a task list — produced from the same source.

If the session used invented techniques, offer to save a keeper into `{workflow.additional_techniques}` via `bmad-customize` user preferences.

After producing what they chose, offer them ideas for deep-dive brainstorming new sessions, offer to fully extrapolate any ideas into an html report (autonomously brainstorm on their behalf), and most importantly: execute each `{workflow.external_handoffs}` instruction. Then share the artifact paths (and any handoff destinations), invoke the `bmad` skill to suggest where this leads next in the BMad ecosystem, let them know if they feel a produced intent is detailed enough they could jump right into asking Sofia (`bmad-agent-po`) to write the initiative's requirements from it, or passing it to any other analysis tool (outlined by `bmad` help) and run `{workflow.on_complete}` if non-empty.
