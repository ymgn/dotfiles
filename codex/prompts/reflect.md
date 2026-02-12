---
description: Reflect recent conversation and store reusable cross-project knowledge
argument-hint: TEXT=<optional source text>
---
Use the knowledge-memory workflow and save insights.

Rules:
1. Use `$TEXT` as source if provided; otherwise use recent conversation.
2. Extract up to 5 practical insights.
3. Prefer categories: coding, tooling, workflow, debugging, ops, design, security, testing, product, other.
4. If none fit, use `proposed:<name>`.
5. Output JSON array objects with: `category`, `title`, `context`, `insight`, `action`, `confidence`.
6. Save by running:
   `printf '%s\n' '<JSON_ARRAY>' | python3 ~/dotfiles/codex/skills/knowledge-memory/scripts/reflect_save.py`
