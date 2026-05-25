# AGENTS.md - AI Agent Instructions for dotfiles

Personal dotfiles for macOS using GNU Stow for symlink management. Apple Silicon assumed.

## Quick Reference

```bash
# Bootstrap
./install.sh                            # Full setup: brew + stow + macOS defaults
./install.sh --dry-run                  # Print what would happen, don't act

# Verification (no automated tests)
bash -n install.sh                      # Syntax check bash
shellcheck install.sh                   # Lint bash (if installed)
zsh -n ~/.zshrc                         # Syntax check zsh after stow
stow -n -t ~ <pkg>                      # Dry-run a stow package
```

## Project Structure

```
dotfiles/
├── install.sh             # Entry point: brew bundle + oh-my-zsh + stow + defaults
├── Brewfile               # Homebrew formulas, casks, mas apps
├── scripts/
│   ├── macos/             # Run by install.sh (macos-defaults.sh, ...)
│   └── clone-repos.sh     # Clone work repos into ~/repos
├── shims/macos/           # OS-specific binary wrappers (~/.local/bin)
├── homework/              # Reference reading (not stowed)
├── zsh/                   # .zshrc, .p10k.zsh
├── git/                   # .gitconfig
├── tmux/                  # .tmux.conf
├── glow/                  # ~/.config/glow
├── aerospace/             # ~/.config/aerospace (incl. winbounds.swift)
├── opencode/              # ~/.config/opencode
├── iterm2/                # iTerm2 preferences
└── claude/                # ~/.claude
```

## Stow workflow

Packages mirror `$HOME` structure:

```
zsh/.zshrc                       →  ~/.zshrc
aerospace/.config/aerospace/...  →  ~/.config/aerospace/...
shims/macos/.local/bin/foo       →  ~/.local/bin/foo  (via `stow -d shims macos`)
```

**Edit in repo, NEVER in `$HOME`** — `~/.zshrc` is a symlink back into the repo. Editing it directly works (same file) but breaks the mental model. Always `cd ~/dotfiles` and edit there.

**Never use `stow --adopt`** — it moves the target file into the repo, overwriting the canonical version.

`install.sh` uses `stow --restow` which removes existing links and re-links — idempotent.

## install.sh stages

1. OS check — bail unless macOS.
2. Xcode CLI tools — `xcode-select --install` if missing.
3. Homebrew — install if missing; `eval "$(/opt/homebrew/bin/brew shellenv)"`.
4. `brew bundle --file=Brewfile`.
5. oh-my-zsh — install if `~/.oh-my-zsh` missing.
6. powerlevel10k theme — clone into `$ZSH_CUSTOM/themes/powerlevel10k`.
7. zsh plugins — `zsh-syntax-highlighting`, `zsh-autosuggestions`.
8. Backup conflicting files in `$HOME` to `~/.dotfiles-backup-<timestamp>/`, then stow each package.
9. Stow `shims/macos/` separately via `stow -d shims macos`.
10. Compile `~/.local/bin/winbounds` from `aerospace/.config/aerospace/winbounds.swift` if `swiftc` exists.
11. `bash scripts/macos/macos-defaults.sh`.
12. `rtk telemetry disable; rtk init -g --opencode` if `rtk` installed.
13. Print manual-TODOs checklist.

## Idempotency contract

Every install function MUST be safe to run multiple times:

- Check before installing (`have foo && return`, `[[ -d $dir ]] && return`).
- Use `stow --restow` (idempotent), never plain `stow` after first run.
- Backup-before-overwrite only if the target is a real file (not a symlink we already created).
- A second run on a fully-installed system should print only `log_ok` / `log_skip` lines.

## Shell script style

```bash
#!/usr/bin/env bash
set -euo pipefail                       # ALWAYS at top

log_info() { echo "ℹ️  $*"; }
log_ok()   { echo "✅ $*"; }
log_warn() { echo "⚠️  $*"; }
log_skip() { echo "⏭️  $*"; }

have() { command -v "$1" >/dev/null 2>&1; }

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Idempotent install pattern
install_foo() {
  have foo && { log_skip "foo installed"; return 0; }
  log_info "Installing foo..."
  brew install foo
  log_ok "foo installed"
}
```

**Quoting:** always `"$var"`, `"$@"`. Use `${var:-default}` for defaults. Prefer `[[ ... ]]` over `[ ... ]`.

## Agent rules

1. **No automated tests** — verify with `bash -n` and a dry run.
2. **Edit in repo** — never in `$HOME`.
3. **Idempotent** — every install step checks before doing.
4. **Don't over-engineer** — no Linux/container branches; this repo is mac-only.
5. **Match log-helper style** — emoji-prefixed `log_info`/`log_ok`/`log_warn`/`log_skip`.
6. **Don't bypass supply-chain guards** — see next section.

## Supply-chain guards (DO NOT bypass)

`~/.npmrc` (`min-release-age=7`) and `~/.bunfig.toml` (`minimumReleaseAge = 604800`) make npm/bun refuse to install package versions younger than 7 days. This is a deliberate quarantine against acute npm/bun supply-chain attacks (Shai-Hulud, chalk/debug, etc.) — most malicious releases get unpublished within 24–72h, so the wait catches them before they land on this machine. Layered on top of `safe-chain` (`~/.safe-chain/`), which blocks known-bad packages reactively.

**Hard rules for agents working in this repo or any project on this machine:**

- **NEVER pass any of these flags** without the human explicitly typing the override themselves in the same session:
  - `--min-release-age=0` (or any value lower than the configured default), `--before=<date>` on `npm`
  - `--minimum-release-age=0` (or any value lower than the configured default) on `bun`
  - `--config=minimumReleaseAge=0` or `--config minimum-release-age=...` on `pnpm`
  - `UV_EXCLUDE_NEWER` or `--exclude-newer` set forward of today on `uv`
- **NEVER edit `npm/.npmrc`, `bun/.bunfig.toml`, or any project-level `.npmrc` / `bunfig.toml`** to lower the age. The 7-day value is the policy; raising it is fine, lowering it requires the human.
- **NEVER suggest "just delete `~/.npmrc`" or "skip the guard for this one install"** as a workaround when an install fails because no version passes the filter. The correct response is: stop, report the package and version that's blocked, and let the human decide.
- **NEVER set `NPM_CONFIG_*` / `BUN_CONFIG_*` env vars** that would weaken the guard in a script, hook, or installer this repo produces.

**If a guard blocks legitimate work** (e.g., a CVE patch released 2 days ago that you genuinely need): surface the situation to the human. Show the blocked version, the published date, and why the wait is the problem. Let them make the call — and if they say "go", let *them* type the override flag. Do not type it for them.

The rationale: a previous wave of supply-chain incidents involved coding agents that, eager to finish a task, ran installs with override flags and dragged compromised packages onto developer machines before the human noticed. This rule exists to make sure that can't happen here.

## Common patterns

### Adding a new tool

1. Add to `Brewfile` (formula or cask).
2. Re-run `./install.sh` (or `brew bundle`).
3. If the tool has dotfiles, add them to an existing package or create a new one mirroring `$HOME`.
4. Add `stow <pkg>` to `install.sh` if it's a new package.

### Adding new dotfiles to an existing package

1. Drop the file into the package, mirroring its `$HOME` location.
2. `stow -n -t ~ <pkg>` to dry-run.
3. Re-run `./install.sh` to restow.
