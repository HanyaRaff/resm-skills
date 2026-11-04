# Obsidian LLM Wiki & Personal Vault Bridge

- **Obsidian Vaults Root:** `D:\Obsidian_Vault\`
- **Personal Hub Vault:** `D:\Obsidian_Vault\Personal` holds the user's durable profile, behavior, thinking style, communication preferences, and goals.
  - Whenever brainstorming, making open-ended design/workflow calls, or personalizing outputs in *any* vault (such as `D:\Obsidian_Vault\Brainstorm Idea`) or workspace, check `D:\Obsidian_Vault\Personal\wiki\index.md` first and read only the specific `wiki/` pages relevant to the current task.
  - Never inline the entire wiki into context—use progressive disclosure via `wiki/index.md`.
  - When the user shares durable personal traits, workflows, or preferences they want remembered across vaults, activate the `llm-wiki` skill to record/update them in `D:\Obsidian_Vault\Personal`.
- **Vault Isolation:** Keep Obsidian vaults separate on disk (never create filesystem junctions or symlinks between vaults). For cross-vault references in markdown notes, use Obsidian URI links (`[Label](obsidian://open?vault=Personal&file=wiki%2F...)`).
