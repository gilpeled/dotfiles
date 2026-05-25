#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"

DRY_RUN=0
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles-backup-$TIMESTAMP"

# Stow packages mirroring $HOME (top-level dirs in $SCRIPT_DIR)
STOW_PACKAGES=(zsh git tmux glow aerospace opencode iterm2 claude npm bun)

log_info() { echo "ℹ️  $*"; }
log_ok()   { echo "✅ $*"; }
log_warn() { echo "⚠️  $*"; }
log_skip() { echo "⏭️  $*"; }

have() { command -v "$1" >/dev/null 2>&1; }

usage() {
  cat <<'EOF'
Usage: ./install.sh [--dry-run]

Options:
  --dry-run   Print what would happen, don't make changes
  -h, --help  Show this help
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --dry-run) DRY_RUN=1; shift ;;
      -h|--help) usage; exit 0 ;;
      *) log_warn "Unknown argument: $1"; shift ;;
    esac
  done
}

run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

# === Stage 1: OS check ===
check_os() {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    log_warn "This installer only supports macOS. Detected: $(uname -s)"
    exit 1
  fi
  local arch
  arch="$(uname -m)"
  if [[ "$arch" != "arm64" ]]; then
    log_warn "This installer assumes Apple Silicon (arm64). Detected: $arch"
    exit 1
  fi
  log_ok "macOS / Apple Silicon detected"
}

# === Stage 2: Xcode CLI tools ===
install_xcode_clt() {
  if xcode-select -p &>/dev/null; then
    log_ok "Xcode Command Line Tools already installed"
    return 0
  fi
  log_info "Installing Xcode Command Line Tools..."
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "  [dry-run] xcode-select --install"
    return 0
  fi
  xcode-select --install || true
  log_warn "Re-run install.sh after Xcode CLT install completes"
}

# === Stage 3: Homebrew ===
install_homebrew() {
  if [[ -x /opt/homebrew/bin/brew ]]; then
    log_ok "Homebrew already installed"
  else
    log_info "Installing Homebrew..."
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  [dry-run] /usr/bin/env bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    else
      /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  fi
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
}

# === Stage 4: brew bundle ===
brew_bundle() {
  log_info "Running brew bundle..."
  run brew bundle --file="$SCRIPT_DIR/Brewfile" --verbose
}

# === Stage 5: oh-my-zsh ===
setup_ohmyzsh() {
  local OMZ="$HOME/.oh-my-zsh"
  if [[ -d "$OMZ" ]]; then
    log_ok "oh-my-zsh already present"
    return 0
  fi
  log_info "Installing oh-my-zsh (unattended)..."
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "  [dry-run] curl install.sh | sh (RUNZSH=no CHSH=no KEEP_ZSHRC=yes)"
    return 0
  fi
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  mkdir -p "$OMZ/custom"
}

# === Stage 6: powerlevel10k ===
setup_p10k() {
  local OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local P10K_DIR="$OMZ_CUSTOM/themes/powerlevel10k"
  if [[ -d "$P10K_DIR" ]]; then
    log_ok "powerlevel10k already installed"
    return 0
  fi
  log_info "Installing powerlevel10k..."
  run git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
}

# === Stage 7: zsh plugins ===
setup_zsh_plugins() {
  local OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  local plugin_dir

  plugin_dir="$OMZ_CUSTOM/plugins/zsh-syntax-highlighting"
  if [[ -d "$plugin_dir/.git" ]]; then
    log_ok "zsh-syntax-highlighting already installed"
  else
    log_info "Installing zsh-syntax-highlighting..."
    run rm -rf "$plugin_dir"
    run git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugin_dir"
  fi

  plugin_dir="$OMZ_CUSTOM/plugins/zsh-autosuggestions"
  if [[ -d "$plugin_dir/.git" ]]; then
    log_ok "zsh-autosuggestions already installed"
  else
    log_info "Installing zsh-autosuggestions..."
    run rm -rf "$plugin_dir"
    run git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plugin_dir"
  fi
}

# === Stage 8: stow packages ===
# Backup any real (non-symlink) files in $HOME that would conflict with this package.
backup_conflicts_for_pkg() {
  local pkg="$1"
  local pkg_dir="$SCRIPT_DIR/$pkg"
  [[ -d "$pkg_dir" ]] || return 0

  # Walk the package, find every file, compute its $HOME-relative target.
  local relpath target rel_dir
  while IFS= read -r -d '' src; do
    relpath="${src#$pkg_dir/}"
    target="$HOME/$relpath"
    if [[ -f "$target" && ! -L "$target" ]]; then
      rel_dir="$(dirname "$relpath")"
      log_warn "Conflict: $target is a real file; backing up"
      if [[ $DRY_RUN -eq 1 ]]; then
        echo "  [dry-run] mkdir -p \"$BACKUP_DIR/$rel_dir\" && mv \"$target\" \"$BACKUP_DIR/$relpath\""
      else
        mkdir -p "$BACKUP_DIR/$rel_dir"
        mv "$target" "$BACKUP_DIR/$relpath"
      fi
    fi
  done < <(find "$pkg_dir" -type f -print0)
}

stow_packages() {
  local pkg
  for pkg in "${STOW_PACKAGES[@]}"; do
    if [[ ! -d "$SCRIPT_DIR/$pkg" ]]; then
      log_skip "Package $pkg not found; skipping"
      continue
    fi
    log_info "Stowing $pkg..."
    backup_conflicts_for_pkg "$pkg"
    run stow --dir="$SCRIPT_DIR" --target="$HOME" --restow "$pkg"
    log_ok "$pkg stowed"
  done
}

# === Stage 8b: gitconfig.local from template ===
setup_gitconfig_local() {
  local template="$SCRIPT_DIR/git/.gitconfig.macos"
  local target="$HOME/.gitconfig.local"
  if [[ ! -f "$template" ]]; then
    log_warn "git/.gitconfig.macos missing — skipping gitconfig.local setup"
    return 0
  fi
  if [[ -f "$target" ]]; then
    log_skip "~/.gitconfig.local already exists"
    return 0
  fi
  log_info "Creating ~/.gitconfig.local from template"
  run cp "$template" "$target"
  log_ok "~/.gitconfig.local created"
}

# === Stage 9: shims ===
stow_shims() {
  if [[ ! -d "$SCRIPT_DIR/shims/macos" ]]; then
    log_skip "shims/macos not found; skipping"
    return 0
  fi
  log_info "Stowing macOS shims..."
  # Backup real-file conflicts under shims/macos
  local relpath target rel_dir
  while IFS= read -r -d '' src; do
    relpath="${src#$SCRIPT_DIR/shims/macos/}"
    target="$HOME/$relpath"
    if [[ -f "$target" && ! -L "$target" ]]; then
      rel_dir="$(dirname "$relpath")"
      log_warn "Conflict: $target is a real file; backing up"
      if [[ $DRY_RUN -eq 1 ]]; then
        echo "  [dry-run] mkdir -p \"$BACKUP_DIR/$rel_dir\" && mv \"$target\" \"$BACKUP_DIR/$relpath\""
      else
        mkdir -p "$BACKUP_DIR/$rel_dir"
        mv "$target" "$BACKUP_DIR/$relpath"
      fi
    fi
  done < <(find "$SCRIPT_DIR/shims/macos" -type f -print0)

  run stow --dir="$SCRIPT_DIR/shims" --target="$HOME" --restow macos
  log_ok "shims stowed"
}

# === Stage 10: compile winbounds ===
compile_winbounds() {
  local src="$SCRIPT_DIR/aerospace/.config/aerospace/winbounds.swift"
  local dst="$HOME/.local/bin/winbounds"

  if [[ ! -f "$src" ]]; then
    log_skip "winbounds.swift not found; skipping compile"
    return 0
  fi
  if ! have swiftc; then
    log_skip "swiftc not available; skipping winbounds compile"
    return 0
  fi
  if [[ -x "$dst" && "$dst" -nt "$src" ]]; then
    log_ok "winbounds is up-to-date"
    return 0
  fi
  log_info "Compiling winbounds..."
  run mkdir -p "$HOME/.local/bin"
  run swiftc "$src" -o "$dst"
  log_ok "winbounds compiled"
}

# === Stage 11: macOS defaults ===
apply_macos_defaults() {
  local script="$SCRIPT_DIR/scripts/macos/macos-defaults.sh"
  if [[ ! -f "$script" ]]; then
    log_skip "scripts/macos/macos-defaults.sh not found; skipping"
    return 0
  fi
  log_info "Applying macOS defaults..."
  run bash "$script"
}

# === Stage 11b: install AI CLIs that aren't on Homebrew ===
# opencode and Claude Code ship via their own installers / npm; not via brew.
install_ai_clis() {
  # opencode → ~/.opencode/bin/opencode (the .zshrc already puts that on PATH)
  if [[ -x "$HOME/.opencode/bin/opencode" ]]; then
    log_skip "opencode already installed"
  else
    log_info "Installing opencode..."
    if [[ $DRY_RUN -eq 1 ]]; then
      echo "  [dry-run] curl -fsSL https://opencode.ai/install | bash"
    else
      curl -fsSL https://opencode.ai/install | bash
    fi
    log_ok "opencode installed"
  fi

  # opencode plugins (oh-my-openagent etc.) listed in ~/.config/opencode/package.json
  if [[ -f "$HOME/.config/opencode/package.json" ]] && have bun; then
    if [[ -d "$HOME/.config/opencode/node_modules" ]]; then
      log_skip "opencode plugins already installed"
    else
      log_info "Installing opencode plugins..."
      run bash -c "cd \"$HOME/.config/opencode\" && bun install"
      log_ok "opencode plugins installed"
    fi
  fi

  # Claude Code → npm global (provides the `claude` command)
  if have claude; then
    log_skip "Claude Code already installed"
  elif have npm; then
    log_info "Installing Claude Code (@anthropic-ai/claude-code)..."
    run npm install -g @anthropic-ai/claude-code
    log_ok "Claude Code installed"
  else
    log_warn "npm not found — skipping Claude Code install"
  fi
}

# === Stage 12: rtk init ===
setup_rtk() {
  if ! have rtk; then
    log_skip "rtk not installed; skipping"
    return 0
  fi
  log_info "Configuring rtk (telemetry off, opencode plugin)..."
  run rtk telemetry disable
  if [[ $DRY_RUN -eq 1 ]]; then
    echo "  [dry-run] rtk init -g --opencode"
  else
    rtk init -g --opencode 2>/dev/null || true
  fi
  log_ok "rtk configured"
}

# === Stage 12b: modern CLI aliases ===
# The modern-CLI block (eza/bat/fzf aliases + env vars) lives in zsh/.zshrc and
# is propagated to ~/.zshrc by stow. We re-list the sequence here so the
# bootstrap script is the authoritative record of what a fresh machine gets,
# and we verify the marker survived stow — losing it silently would degrade
# the shell ergonomics for every subsequent session.
verify_modern_cli_aliases() {
  local zshrc="$HOME/.zshrc"
  local marker="# === Modern CLI tooling ==="
  # Canonical sequence (kept in sync with zsh/.zshrc):
  #   alias ls='eza --group-directories-first'
  #   alias ll='eza -la --git --icons --group-directories-first'
  #   alias lt='eza --tree --level=2 --git-ignore'
  #   export MANPAGER="sh -c 'col -bx | bat -l man -p'"
  #   export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  #   export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  #   export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  #   export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"
  if [[ ! -f "$zshrc" ]]; then
    log_warn "~/.zshrc missing; modern CLI aliases not verified"
    return 0
  fi
  if grep -qF "$marker" "$zshrc"; then
    log_ok "Modern CLI aliases present in ~/.zshrc"
  else
    log_warn "Modern CLI aliases marker missing from ~/.zshrc — re-run with stow re-stowing zsh"
  fi
}

# === Stage 13: verify a fresh login shell loads cleanly ===
# Catches drift like a `.zshrc` referencing a tool that isn't in Brewfile.
# Prints the offending stderr so the user can fix it before declaring the
# bootstrap done. Skipped on --dry-run and on non-TTY runs (e.g. CI), since
# `zsh -i` can emit harmless option-set warnings without a real terminal.
verify_shell_clean() {
  [[ $DRY_RUN -eq 1 ]] && return 0
  [[ -t 0 && -t 1 ]] || { log_skip "Not a TTY; skipping shell verification"; return 0; }

  log_info "Verifying a fresh login shell loads cleanly..."
  local errors
  errors="$(zsh -l -i -c exit 2>&1 1>/dev/null || true)"
  if [[ -z "$errors" ]]; then
    log_ok "Fresh shell loads cleanly"
    return 0
  fi
  log_warn "Fresh shell emitted errors — fix before considering bootstrap done:"
  echo "$errors" | sed 's/^/    /'
  log_warn "Common cause: a tool referenced in .zshrc is missing from Brewfile."
}

# === Stage 14: final summary ===
print_summary() {
  cat <<'EOF'

============================================================
✅ Bootstrap complete!

⚠️  IMPORTANT — DO THIS FIRST:

   Your CURRENT shell still has the old PATH. Tools installed by
   this run (gh, brew, mas, eza, bat, etc.) are NOT available in
   this terminal until you start a fresh shell. This is the most
   common gotcha — without it, the manual TODOs below will hit
   "command not found".

   Run this NOW to reload in place:

       exec zsh -l

   Or: quit and reopen your terminal app.

------------------------------------------------------------

Then, in the fresh shell, do the manual TODOs:

  1. Sign into the Mac App Store (so `mas` can install Xcode etc.).
  2. Run `gh auth login` then `gh auth setup-git` (so plain `git push` over HTTPS works).
     Or: switch your remotes to SSH (`git remote set-url origin git@github.com:OWNER/REPO.git`).
  3. Run `./scripts/clone-repos.sh` to clone work repos into ~/repos.
  4. System Settings → Privacy & Security — grant permissions:
       - Aerospace      (Accessibility)
       - Tailscale      (Network Extensions)
       - Amphetamine    (Accessibility)
       - Mounty         (Disk / Full Disk Access)
       - 1Password      (Auto-fill)
  5. Launch `aerospace` once manually so it requests permissions.
  6. Install Google Calendar as a Chrome PWA: open calendar.google.com in
     Chrome → menu → Cast/Save/Share → "Install page as app". Chrome doesn't
     expose a non-interactive install flag, so this step is manual.
  7. Log out and back in (or reboot). Some macOS defaults written by
     this run (keyboard repeat rate, etc.) are only loaded by the
     HID/WindowServer layer at login — they won't take effect until
     the session is rebuilt.
  8. (Optional) Run `p10k configure` to re-customize the prompt.
     The `.p10k.zsh` file is checked in; this is only if you want to change it.
============================================================
EOF
}

main() {
  parse_args "$@"
  if [[ $DRY_RUN -eq 1 ]]; then
    log_info "DRY-RUN mode: no changes will be made"
  fi

  check_os
  install_xcode_clt
  install_homebrew
  brew_bundle
  setup_ohmyzsh
  setup_p10k
  setup_zsh_plugins
  stow_packages
  setup_gitconfig_local
  stow_shims
  compile_winbounds
  apply_macos_defaults
  install_ai_clis
  setup_rtk
  verify_modern_cli_aliases
  verify_shell_clean
  print_summary
  maybe_reload_shell
}

# Offer to reload the shell so the user doesn't hit "command not found"
# on the manual TODOs that just got installed (gh, mas, etc.).
# Skipped on --dry-run, on non-interactive runs (CI / piped input), and
# on any answer other than Y/y/yes/<empty>.
maybe_reload_shell() {
  [[ $DRY_RUN -eq 1 ]] && return 0
  [[ -t 0 && -t 1 ]] || return 0
  echo
  read -r -p "Reload your shell now (recommended)? [Y/n] " reply
  case "${reply:-y}" in
    y|Y|yes|YES)
      log_info "exec \"\$SHELL\" -l"
      exec "${SHELL:-zsh}" -l
      ;;
    *)
      log_skip "Skipping reload. Run 'exec \$SHELL -l' yourself when you're ready."
      ;;
  esac
}

main "$@"
