---
description: Save shared context memory
argument-hint: KEYWORD=<keyword optional> TEXT=<log text optional> OVERVIEW=<overview for first save optional>
---
Use the context-memory workflow to save memory.

Rules:
1. Resolve KEYWORD from `$KEYWORD` if provided.
2. If KEYWORD is missing, use current git branch `feature/<KEYWORD>`.
3. If TEXT is missing, summarize recent conversation with enough detail.
4. If memory file does not exist, ask for overview and use it.
5. If memory file exists, load and show it before appending.

Run:
- `python3 ~/.codex/skills/context-memory/scripts/context_save.py "$KEYWORD" "$TEXT" --overview "$OVERVIEW"` when KEYWORD is provided.
- `printf '%s\n' "$TEXT" | python3 ~/.codex/skills/context-memory/scripts/context_save.py --overview "$OVERVIEW"` when KEYWORD is omitted.
