---
name: knowledge-memory
description: Cross-project knowledge memory for /reflect. Extract insights from recent conversation and save them by category under ~/ai-memory/knowledge.
---

# Knowledge Memory

## Overview
Maintain cross-project knowledge in `~/ai-memory/knowledge`.
Use `/reflect` to extract reusable insights from recent conversation and save them in category files.

## Commands
- `/reflect <TEXT...>`
- `/reflect` (no text provided)

## Category Policy
Preferred categories:
- `coding`
- `tooling`
- `workflow`
- `debugging`
- `ops`
- `design`
- `security`
- `testing`
- `product`
- `other`

If none fit, you may propose a new category with `proposed:<name>`.

## Save Workflow
When `/reflect` is issued:
1) Use `<TEXT...>` if provided; otherwise summarize recent conversation.
2) Extract up to 5 insights. Do not over-compress.
3) Format each insight as JSON object:
   - `category`
   - `title`
   - `context`
   - `insight`
   - `action`
   - `confidence` (`high`/`medium`/`low`)
4) Pass the JSON array to `reflect_save.py` via stdin.

Script:

```bash
printf '%s\n' '<JSON_ARRAY>' | python3 ~/dotfiles/codex/skills/knowledge-memory/scripts/reflect_save.py
```

## Auto Reference Workflow
Before substantial implementation/review/debugging tasks:
1) Summarize current user request in one line.
2) Run `knowledge_lookup.py --task "<request>"`.
3) Use returned insights to guide execution.

Script:

```bash
python3 ~/dotfiles/codex/skills/knowledge-memory/scripts/knowledge_lookup.py --task "<request>"
```
