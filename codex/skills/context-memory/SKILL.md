---
name: context-memory
description: Shared project memory management for /context-save and /context-load slash-style commands; use when the user wants to write or read case-specific memory under ~/ai-memory so multiple agents can share context.
---

# Context Memory

## Overview
Maintain shared, keyword-scoped memory in `~/ai-memory` that multiple agents can read and write.
Use slash-style commands to save or load project context and work logs.

## Command Parsing
Treat the following as explicit commands, not general questions:

- `/context-save <KEYWORD> <TEXT...>`
- `/context-save <KEYWORD>` (no text provided)
- `/context-save` (if current branch is `feature/<KEYWORD>`)
- `/context-load <KEYWORD>`

Parsing rules:
- `<KEYWORD>` is the first token after the command.
- Everything after `<KEYWORD>` is `<TEXT...>` and must be saved as source text.
- If no text is provided, generate a summary from recent conversation logs with enough detail.
- `<KEYWORD>` can be Japanese. Reject `/` and empty values.
- If `<KEYWORD>` is omitted, resolve it in order:
  1) current git branch name `feature/<KEYWORD>`
  2) most recently updated file in `~/ai-memory/*.md`

## Memory Structure
Each keyword maps to a single Markdown file:

```text
~/ai-memory/<KEYWORD>.md
```

File format:

```markdown
# <KEYWORD>

## 概要
<initial overview from user>

## ログ
### YYYY-MM-DD HH:MM
- 実施内容:
  - ...
```

## Save Workflow
When `/context-save` is issued:
1) Parse `<KEYWORD>` and `<TEXT...>`.
2) If `<KEYWORD>` is missing, infer it from branch or latest memory file.
3) If target file exists, read and present the existing memory first.
4) If no text is provided, summarize recent work with sufficient detail (do not over-compress).
5) If target file does not exist, create it and auto-generate `## 概要` from the first meaningful line.
6) Append a timestamped log entry.

Use the script:

```bash
python3 ~/dotfiles/codex/skills/context-memory/scripts/context_save.py <KEYWORD> "<TEXT...>"
```

Notes:
- `--overview` is optional; if omitted on first save, it is auto-generated from text.
- Existing files append logs without rewriting `## 概要`.
- You can omit `<KEYWORD>` in zero-arg mode; branch and recent memory are used for inference.

## Load Workflow
When `/context-load` is issued:
1) Parse `<KEYWORD>`.
2) Read `~/ai-memory/<KEYWORD>.md`.
3) Present the content concisely so work can resume quickly.

Use the script:

```bash
python3 ~/.codex/skills/context-memory/scripts/context_load.py <KEYWORD>
```

Compatibility:
- Loader still reads legacy directory format (`~/ai-memory/<KEYWORD>/{spec,decisions,next,log}.md`) if present.

## Resources

### scripts/
- `context_save.py`: creates `~/ai-memory/<KEYWORD>.md` on first save and appends timestamped logs.
- `context_load.py`: reads new single-file memory first, then falls back to legacy directory format.
