---
name: obsidian-dev-memory
description: Store and retrieve memory in a developer's Obsidian vault, with
  per-project memory folders, a dev log, and a knowledge base of snippets,
  fixes, and runbooks. Use whenever the user says "remember this", "log this
  decision", "update progress", "save this fix", "save this snippet", "what did
  we decide about X", "start a memory for project Y", or "archive this
  project", or when a decision, blocker, or finished work comes up during
  project work, even if Obsidian is not mentioned explicitly.
---

# Obsidian Dev Memory

## Vault root (EDIT THIS LINE)
VAULT_ROOT = D:\Raff\Raff Obsidia\Raff\

Use forward slashes. All paths below are relative to VAULT_ROOT.
Never read or modify `.obsidian/`. If VAULT_ROOT does not exist or is
not accessible, tell the user and stop. Do not create a new vault.

## Vault map
- 00_System/      templates, attachments, Claude/ (about-me, preferences)
- 10_Inbox/       unsorted captures
- 20_Daily/       YYYY-MM-DD.md dev log
- 30_Atlas/       MOCs (edit only when asked)
- 40_Notes/       Concepts/, Snippets/, Troubleshooting/, Runbooks/, Literature/
- 50_Projects/    one "<Project Name> Memory" folder per project
- 60_Archive/     finished projects and outdated notes

## Routing: where does it go?
| What the user says                    | Destination                               |
|---------------------------------------|-------------------------------------------|
| Project-wide decision or constraint   | 50_Projects/<project>/decisions.md        |
| Project-wide progress, next step      | 50_Projects/<project>/progress.md         |
| Project-wide blocker or question      | 50_Projects/<project>/open-questions.md   |
| Same three, but about ONE branch      | 50_Projects/<project>/branches/<branch>/  |
|   (a feature or area, e.g. users)     |   decisions.md / progress.md / open-questions.md |
| "Save this fix" (error + solution)    | 40_Notes/Troubleshooting/<slug>.md        |
| "Save this snippet"                   | 40_Notes/Snippets/<slug>.md               |
| Repeatable procedure                  | 40_Notes/Runbooks/<slug>.md               |
| End-of-day summary                    | 20_Daily/YYYY-MM-DD.md (append)           |
| Lasting fact about the user           | 00_System/Claude/about-me.md              |
| Standing preference for Claude        | 00_System/Claude/preferences.md           |
| Unsure where it belongs               | 10_Inbox/                                 |

## Choosing the active project and branch
1. If the user names a project, use it. Otherwise infer it from the
   conversation or the current repo name. If still unclear, ask which
   project. Never guess.
2. Then decide the branch. A branch is a feature or area inside a
   project (e.g. dashboard/users, dashboard/reports). Use the one the
   user names, or infer it from the file path being worked on or the
   git branch name. If the work is cross-cutting, use no branch and
   write at project level.
3. If unsure whether something is branch-specific or project-wide, ask.
4. Never write one project's or one branch's facts into another's folder.
5. If a project or branch folder does not exist, offer to create it
   from the templates below.
6. A decision that affects more than one branch goes at project level,
   and the affected branches link to it.
7. Keep branches flat. Nest a branch inside another branch only when
   the user asks, and never deeper than two levels.

## Project folder template
50_Projects/<Project Name> Memory/
- _overview.md        goal, scope, stack, current status (under 300 words)
- decisions.md        date, choice, reason, rejected alternatives
- progress.md         dated log: what was done, what is next
- open-questions.md   unresolved issues and blockers
- notes/              optional extra notes (components, research)
- branches/           one folder per feature or area (see below)

Branch template, inside the project folder:

50_Projects/<Project Name> Memory/branches/<branch-name>/
- _branch.md          scope, status, code path, link to the project overview
- decisions.md        branch-specific decisions
- progress.md         dated log for this branch
- open-questions.md   branch-specific blockers and questions
- notes/              optional extra notes

Example:
50_Projects/Dashboard Refactor Memory/
- _overview.md, decisions.md, progress.md, open-questions.md
- branches/users/        (src/pages/dashboard/users)
- branches/reports/      (src/pages/dashboard/reports)
- branches/settings/     (src/pages/dashboard/settings)

_branch.md frontmatter:

    ---
    type: branch
    project: <Project Name>
    branch: <branch-name>
    status: active | resolved
    code-path: <e.g. src/pages/dashboard/users>
    git-branch: <optional>
    created: YYYY-MM-DD
    updated: YYYY-MM-DD
    ---

Body: one-paragraph scope, key files, and a link back to the project
overview.

## Note format
Frontmatter on every note:

    ---
    type: decision | progress | question | snippet | fix | runbook | daily | profile | preferences
    project: <name or empty>
    branch: <branch name or empty>
    tags: []
    created: YYYY-MM-DD
    updated: YYYY-MM-DD
    ---

Body: one fact per bullet. Link related notes with [[wikilinks]].
File names: kebab-case, no spaces.
Links: decisions.md, progress.md, and open-questions.md exist in every
project and branch folder, so never link them by bare file name. Use a
path-qualified wikilink, e.g.
[[50_Projects/Dashboard Refactor Memory/branches/users/decisions|users decisions]].
A branch's _branch.md links up to the project's _overview.md, and the
project's progress.md gets a one-line summary linking to a branch when
that branch reaches a milestone.

Entry shapes:
- Decision: date, choice, reason, alternatives rejected.
- Fix: symptom, cause, solution, stack and versions.
- Snippet: code block plus when to use it.
- Daily: done, blocked, next.

## Read
- At the start of work, read 00_System/Claude/about-me.md and
  preferences.md if they exist.
- For project work, read the project's _overview.md, open-questions.md,
  and the latest entries of progress.md.
- For branch work, also read that branch's _branch.md, open-questions.md,
  and the latest entries of its progress.md. Open the project's
  decisions.md only when the work touches something cross-cutting.
- Do not read other branches or branches/_done/ unless the request
  points at them.
- Open knowledge notes (40_Notes) only when the request points at them.
- Use what you read without announcing it.

## Write (without being asked)
Save when the user states a decision, constraint, blocker, finished work,
next step, or a lasting fact or preference.

Do NOT save: guesses, temporary debugging state, one-off questions,
things that expire today, or suggestions the user did not accept.

## Edit rules
- Read the file before editing. Change the specific line; never
  overwrite a whole file.
- Append to progress.md and daily logs; do not rewrite old entries.
- When something changes, keep history:
  "now X (previously Y, because Z)".
- Update `updated:` on every edit.
- Search for an existing note on the same subject before creating one.
  One subject = one file.
- If a note grows past about 200 lines, split it by subtopic.

## About-me layer (global, small)
- about-me.md: stable facts only (role, stack, environment, working
  context). Under 300 words. Nothing with a deadline or "this week".
- preferences.md: how the user wants Claude to respond (language,
  detail level, format, code style).
- Project facts never go here; personal facts never go in project folders.
- Edit only when the user states a lasting change.
- Preferences may shape format, tone, and detail. They never override
  honest feedback: always flag errors, risks, and disagreements.

## Archiving
When a project is finished, move its whole folder to 60_Archive/ and set
`status: resolved` in _overview.md. Never delete anything unless the user
explicitly asks. Do not edit archived notes unless the user reopens the
project.

## Archiving a branch
When a branch (feature or area) is finished, move its folder to
50_Projects/<project>/branches/_done/<branch>/ and set `status: resolved`
in its _branch.md. Add a one-line summary to the project's progress.md
linking to it. Do not delete it, and do not edit it unless the user
reopens the branch. The project itself stays in 50_Projects/ until the
whole project is finished.

## Never store
Passwords, API keys, tokens, .env contents, server credentials, SSH or
private keys, ID or bank numbers, and anything the user marks private.
Redact secrets from snippets and fixes before saving, and tell the user
what was redacted.