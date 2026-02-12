---
description: Save shared context memory
argument-hint: TEXT=<optional source text>
---
Use the context-memory workflow to save memory.

Rules:
1. Prefer zero-arg usage. Infer KEYWORD automatically:
   - first: current git branch `feature/<KEYWORD>`
   - fallback: most recently updated `~/ai-memory/*.md`
2. If `$TEXT` is provided, use it; otherwise summarize recent conversation with enough detail.
3. If memory file exists, load and show it before appending.
4. If memory file does not exist, create it and auto-generate overview from the first meaningful line.

Run:
- with text:
  `printf '%s\n' "$TEXT" | python3 ~/dotfiles/codex/skills/context-memory/scripts/context_save.py`
- without text:
  summarize recent conversation, then
  `printf '%s\n' "<SUMMARY>" | python3 ~/dotfiles/codex/skills/context-memory/scripts/context_save.py`
