---
name: context-memory
description: Shared project memory management for /context-save and /context-load slash-style commands; use when the user wants to write or read case-specific memory (spec, decisions, next steps, logs) under ~/ai-memory so multiple agents can share context.
---

# Context Memory

## Overview
Maintain a shared, case-scoped memory in `~/ai-memory` that multiple agents can read and write. Use slash-style commands to save or load project context, work logs, and next steps.

## Command Parsing
Treat the following as explicit commands, not general questions:

- `/context-save <CASE-ID> <TEXT...>`
- `/context-save <CASE-ID>` (no text provided)
- `/context-load <CASE-ID>`

Parsing rules:
- `<CASE-ID>` is the first token after the command.
- Everything after `<CASE-ID>` is `<TEXT...>` and must be saved verbatim.
- If no text is provided, generate a single-line, compact summary of the recent conversation that is easy to skim later.

## Memory Structure
Each case ID maps to a directory:

```
~/ai-memory/<CASE-ID>/
  spec.md
  decisions.md
  next.md
  log.md
```

File purposes:
- `spec.md`: project purpose, scope, constraints.
- `decisions.md`: confirmed decisions and rationale.
- `next.md`: immediate next actions.
- `log.md`: time-stamped work log (append-only).

## Save Workflow
When `/context-save` is issued:
1) Parse `<CASE-ID>` and `<TEXT...>`.
2) If no text is provided, summarize the most recent discussion into one single line.
3) Append the line to `log.md` with a timestamp.
4) Create the case directory and files if they do not exist.

Use the script:

```bash
python3 ~/.codex/skills/context-memory/scripts/context_save.py <CASE-ID> "<TEXT...>"
```

If you generated the summary yourself, pass it as `<TEXT...>`.

## Load Workflow
When `/context-load` is issued:
1) Parse `<CASE-ID>`.
2) Read `spec.md`, `decisions.md`, `next.md`, then `log.md`.
3) Present the content in a concise way so work can resume quickly.

Use the script:

```bash
python3 ~/.codex/skills/context-memory/scripts/context_load.py <CASE-ID>
```

## Resources

### scripts/
- `context_save.py`: creates case directory/files if missing and appends a timestamped log entry.
- `context_load.py`: reads the case memory files and prints them in order.
