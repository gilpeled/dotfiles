#!/usr/bin/env bash
set -euo pipefail

log_info() { echo "ℹ️  $*"; }
log_ok()   { echo "✅ $*"; }
log_warn() { echo "⚠️  $*"; }
log_skip() { echo "⏭️  $*"; }

have() { command -v "$1" >/dev/null 2>&1; }

REPOS_DIR="$HOME/repos"

# ACTIVE: cloned automatically.
ACTIVE_REPOS=(
  "joytunes/Draw"
  "joytunes/Draw_DLC"
  "joytunes/DrawARGlassesWebsite"
  "joytunes/DrawRecog"
  "joytunes/SimplyPiano"
  "joytunes/SimplyPianoAR"
  "joytunes/SimplyPianoDroid"
  "joytunes/SimplyPianoUnity"
  "joytunes/virtual-piano-research"
  "gilpeled/autotranslator"
)

clone_one() {
  local slug="$1"
  local name="${slug##*/}"
  local target="$REPOS_DIR/$name"

  if [[ -d "$target" ]]; then
    log_skip "$name already exists at $target"
    return 0
  fi

  log_info "Cloning $slug..."
  if have gh; then
    if gh repo clone "$slug" "$target"; then
      log_ok "$name cloned via gh"
      return 0
    fi
    log_warn "gh clone failed for $slug; falling back to git"
  fi
  if git clone "git@github.com:${slug}.git" "$target"; then
    log_ok "$name cloned via git"
  else
    log_warn "Failed to clone $slug"
  fi
}

main() {
  mkdir -p "$REPOS_DIR"
  log_info "Target dir: $REPOS_DIR"

  local slug
  for slug in "${ACTIVE_REPOS[@]}"; do
    clone_one "$slug"
  done

  cat <<'EOF'

============================================================
Stale / not auto-cloned. Manually clone if you want them:
  git clone git@github.com:joytunes/ninja-africa-flow.git ~/repos/ninja-africa-flow      # last commit 2024-10-20, >1y stale
  git clone git@github.com:joytunes/jtdata.git ~/repos/jtdata                            # last commit 2025-10-05
  git clone git@github.com:joytunes/sp-yt-ad-labelling.git ~/repos/sp-yt-ad-labelling    # last commit 2025-10-08
  git clone git@github.com:joytunes/asla_server.git ~/repos/asla_server                  # last commit 2025-08-18
  git clone git@github.com:joytunes/virtual-piano-logger-app.git ~/repos/virtual-piano-logger-app
  git clone git@github.com:joytunes/sp_recog_engine.git ~/repos/sp_recog_engine
  git clone https://github.com/ageron/handson-ml3.git ~/repos/handson-ml3                # textbook, public
============================================================
EOF
}

main "$@"
