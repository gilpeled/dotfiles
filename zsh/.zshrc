# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# zsh-syntax-highlighting: render valid commands in white (default is green)
ZSH_HIGHLIGHT_STYLES[command]='fg=white'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white'
ZSH_HIGHLIGHT_STYLES[function]='fg=white'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=white'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=white'

# Alt+Left / Alt+Right: jump word-by-word (covers iTerm2's two common modes)
bindkey "^[[1;3D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[b"     backward-word
bindkey "^[f"     forward-word

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Force English for messages/dates while keeping Israeli region defaults
export LANG=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# === Modern CLI tooling ===
# Aliases and integrations for the modern replacements installed via Brewfile.
# Only `ls` is aliased — `cat`/`grep`/`find`/`du`/`top` keep POSIX semantics so
# scripts and pipes don't surprise. Use `bat`/`rg`/`fd`/`dua`/`btop` explicitly.

# eza → modern ls
alias ls='eza --group-directories-first'
alias ll='eza -la --git --icons --group-directories-first'
alias lt='eza --tree --level=2 --git-ignore'

# bat → syntax-highlighted man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# fzf → drive Ctrl-T / Alt-C off fd (faster, respects .gitignore) with bat preview
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"

# opencode
export PATH=$HOME/.opencode/bin:$PATH
alias omo="opencode"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# === Deliberate npm-global updates past the supply-chain guard ===
# `~/.npmrc` sets `min-release-age=7` (see npm/.npmrc), so npm silently resolves
# `@latest` down to the newest version that's ≥7 days old — which makes Claude
# Code's auto-updater (and a plain `npm i -g`) appear to do nothing when the real
# latest is younger than the guard window. This helper is the sanctioned escape
# hatch for a *deliberate, human-confirmed* update: it shows the latest version's
# age and, only if it's inside the guard window, asks before passing
# `--min-release-age=0` for that one install. Every other package and the default
# guard stay fully protected, and nothing here bypasses anything silently.
npm-update() {
  emulate -L zsh
  setopt local_options pipefail
  local pkg="$1"
  if [[ -z "$pkg" ]]; then
    print -u2 "usage: npm-update <npm-package> [extra npm install args...]"
    return 2
  fi
  shift

  local guard ver info age verdict
  guard=$(grep -iE '^[[:space:]]*min-release-age[[:space:]]*=' "${NPM_CONFIG_USERCONFIG:-$HOME/.npmrc}" 2>/dev/null \
            | tail -1 | sed -E 's/.*=[[:space:]]*//; s/[[:space:]]*$//')
  [[ -z "$guard" ]] && guard=0

  ver=$(npm view "$pkg" version 2>/dev/null)
  if [[ -z "$ver" ]]; then
    print -u2 "✗ couldn't fetch latest version for $pkg (no such package, or npm unreachable)"
    return 1
  fi

  # Decide whether the latest release is still inside the guard window. JSON comes
  # in on stdin (a pipe, NOT a heredoc) so json.load(sys.stdin) reads npm's output;
  # the script is single-quoted, so it must contain no single quotes.
  info=$(npm view "$pkg@$ver" time --json 2>/dev/null | python3 -c '
import sys, json, datetime
ver, guard = sys.argv[1], float(sys.argv[2])
t = json.load(sys.stdin)[ver]
pub = datetime.datetime.fromisoformat(t.replace("Z", "+00:00"))
age = (datetime.datetime.now(datetime.timezone.utc) - pub).total_seconds() / 86400
verdict = "YOUNG" if age < guard else "OK"
print(f"{int(age)} {verdict}")
' "$ver" "$guard") || { print -u2 "✗ couldn't determine release age for $pkg@$ver"; return 1; }
  age=${info%% *}
  verdict=${info##* }

  if [[ "$verdict" == OK ]]; then
    print "ℹ️  $pkg $ver is ${age}d old (≥ ${guard}d guard) — installing"
    npm install -g "$pkg@latest" "$@"
    return
  fi

  print "⚠️  $pkg $ver was published ${age}d ago — younger than your ${guard}d supply-chain guard."
  print -n "    Update anyway? This bypasses the guard for this one install [y/N] "
  local reply
  read -r reply
  if [[ "$reply" == (y|Y|yes|YES) ]]; then
    print "ℹ️  installing $pkg@$ver with --min-release-age=0 …"
    npm install -g "$pkg@latest" --min-release-age=0 "$@"
  else
    print "⏭️  skipped — staying on the currently-installed version"
  fi
}

# Convenience wrapper for the CLI I update most by hand (package name ≠ binary).
claude-update() { npm-update @anthropic-ai/claude-code "$@"; }

# Shadow `claude` so the built-in `claude update` (which shells out to npm without
# the override and therefore always fails against the guard) is rerouted through
# the confirm-prompt flow above. Every other invocation hits the real binary via
# `command`. Interactive shells only — scripts don't source this, so they get the
# binary untouched.
claude() {
  if [[ "$1" == update ]]; then
    shift
    claude-update "$@"
  else
    command claude "$@"
  fi
}

# If Enter is pressed on a single bare word that isn't a known
# command/alias/function/builtin, rewrite it to `cd <word>` so zoxide gets a
# shot. Lets bare `dotfiles` / `simp` jump like `cd dotfiles` / `cd simp`.
# (zsh's command_not_found_handler runs in a forked child, so a `cd` inside
# it can't persist — has to happen at the ZLE layer instead.)
__autocd_accept_line() {
  emulate -L zsh
  local words=(${(z)BUFFER})
  if (( ${#words} == 1 )) \
    && [[ ${words[1]} != -* && ${words[1]} != */* ]] \
    && ! command -v -- "${words[1]}" >/dev/null 2>&1; then
    BUFFER="cd ${words[1]}"
  fi
  zle .accept-line
}
zle -N accept-line __autocd_accept_line

eval $(thefuck --alias)

# safe-chain wraps npm/bun/pip/uv/etc. to block installs of known-malicious
# packages — the reactive layer beneath the min-release-age quarantine (see
# npm/.npmrc). Guarded with -r so a missing ~/.safe-chain (e.g. a fresh machine
# before install.sh has reinstalled it) can't break shell init.
[ -r "$HOME/.safe-chain/scripts/init-posix.sh" ] && source "$HOME/.safe-chain/scripts/init-posix.sh"

# zoxide must be initialized last — it overrides `cd`, and any later PATH
# manipulation can shadow it. _ZO_DOCTOR will warn if anything follows.
eval "$(zoxide init zsh --cmd cd)"
