---
name: new-python-project
description: Scaffold a new Python project the user's way — uv-first, ruff, optional ty + pre-commit + AGENTS.md. Use whenever the user says "start a new python project / tool / script", "scaffold a uv project", "new repo in python", or similar. ALWAYS ask Minimal vs Full before doing anything.
---

# new-python-project

This skill scaffolds Python projects for the user. It has two branches:

- **Minimal** — throwaway script, prototype, one-off exploration. Just enough to be uv- and ruff-clean.
- **Full** — real project, will outlive the week, may have collaborators. Adds commit-time gates, agent docs, optional CI.

**Always ask the user "Minimal or Full?" before scaffolding.** Do not assume.

The two user-level Claude Code hooks (`enforce-uv`, `ruff-after-edit`) kick in automatically for any project produced by either branch — they detect `uv.lock` + `[tool.ruff]`. No wiring needed here.

---

## Inputs to collect

Ask the user (one short message, batch the questions):

1. Project name (kebab-case dir name, snake_case package name).
2. Branch: Minimal or Full.
3. Python version (default: 3.13).
4. For Full only: Use `ty` for typecheck? (default: yes — but warn it's pre-1.0).
5. For Full only: Add GitHub Actions CI? (default: no — opt in).

---

## Minimal branch

```bash
uv init "$NAME" --package   # src/ layout, suitable for tools/libraries
# (or `uv init "$NAME"` for a single-file app)
cd "$NAME"
```

Append to `pyproject.toml`:

```toml
[tool.ruff]
target-version = "py313"   # adjust to user's choice

[tool.ruff.lint]
extend-select = ["B", "I", "UP"]
```

That's it. The user-level hooks now cover:
- `enforce-uv` — guard fires (`uv.lock` exists)
- `ruff-after-edit` — guard fires (`[tool.ruff]` in pyproject)

No pre-commit, no AGENTS.md, no githooks. Done.

---

## Full branch

Everything in Minimal, plus the four files below.

### 1. `.githooks/pre-commit`

```bash
#!/usr/bin/env bash
# Delegates to the pre-commit framework via uvx (no global install needed).
# Activated by .githooks/install.sh setting core.hooksPath.
exec uvx pre-commit run --hook-stage pre-commit --color=auto
```

Make it executable: `chmod +x .githooks/pre-commit`.

### 2. Activate the githooks path

Run once, locally:

```bash
git config --local core.hooksPath .githooks
```

Anyone who clones the repo gets the pre-commit gate automatically after running this one command. No `pre-commit install` needed.

Document this in `AGENTS.md` and `README.md` as a one-time setup step (`git config --local core.hooksPath .githooks` after clone). It cannot be checked in directly — git config is local.

### 3. `.pre-commit-config.yaml`

```yaml
repos:
  - repo: local
    hooks:
      - id: uv-lock-check
        name: uv lock --check
        entry: uv lock --check
        language: system
        pass_filenames: false
        files: ^(pyproject\.toml|uv\.lock)$

      - id: ruff-check
        name: Ruff Check
        entry: uvx ruff check --no-fix .
        language: system
        types: [python]
        pass_filenames: false

      - id: ruff-format-check
        name: Ruff Format Check
        entry: uvx ruff format --check .
        language: system
        types: [python]
        pass_filenames: false

      # OMIT this block if the user said no to ty:
      - id: ty-check
        name: ty typecheck
        entry: uvx ty check .
        language: system
        types: [python]
        pass_filenames: false
```

Note: pre-commit hooks here are all `--check` / `--no-fix` mode. Mutating happens in the Claude Code hook layer (on Write/Edit) or by hand. Pre-commit is a *gate*, not an *editor*.

### 4. `AGENTS.md` skeleton

```markdown
# AGENTS.md — AI Agent Instructions for <project-name>

<one-paragraph project overview>

## Structure

\`\`\`
<tree>
\`\`\`

## Commands

### Package management
\`\`\`bash
uv add <pkg>         # add a runtime dep
uv add --dev <pkg>   # add a dev dep
uv sync --frozen     # install from lockfile (no resolve)
\`\`\`

### Lint / format / typecheck
\`\`\`bash
uvx ruff check .          # lint
uvx ruff check . --fix    # lint + autofix
uvx ruff format .         # format
uvx ty check .            # typecheck   # omit if no ty
\`\`\`

### Tests
\`\`\`bash
uv run pytest                       # all tests
uv run pytest tests/foo_test.py -v  # one file
uv run pytest -k "name_substring"   # filter
\`\`\`

### Local setup after clone
\`\`\`bash
git config --local core.hooksPath .githooks   # activates pre-commit gate
uv sync --frozen
\`\`\`

## Code style

- Python 3.13+; built-in generics (`list`, `dict`) not `typing.List`/`Dict`
- `Type | None` not `Optional[Type]`
- `type Foo = X | Y` (PEP 695) not `TypeAlias`
- ruff handles formatting — don't hand-format
- Comments only for non-obvious *why*; never for *what*

## Anti-patterns

- DO NOT `pip install` — use `uv add`
- DO NOT bypass pre-commit with `--no-verify` unless explicitly justified
- DO NOT commit secrets / .env files / large binaries
- <add project-specific entries as patterns emerge>

## Where to look

| Task | Location |
|------|----------|
| <fill in as the project grows> | |
```

Tell the user this is a skeleton — the *Anti-patterns* and *Where to look* sections only become valuable once the project has real patterns. Encourage filling in as conventions emerge, not upfront.

### 5. (Optional) `.github/workflows/ci.yaml`

Only create if the user opted in.

```yaml
name: CI
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v3
        with:
          enable-cache: true
      - run: uv sync --frozen
      - run: uvx ruff check --no-fix .
      - run: uvx ruff format --check .
      - run: uvx ty check .   # omit if no ty
      - run: uv run pytest    # remove if no tests yet
```

---

## Reporting back

When done, tell the user concretely:
- What was created (file list).
- What still needs them to do manually (e.g., `git init`, first commit, remote push, GitHub Actions toggle).
- Reminder that the Claude Code hooks are already active because the markers exist.

Do NOT install deps the user didn't ask for. Do NOT `git init` or commit on their behalf unless they asked.
