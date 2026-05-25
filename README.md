# dotfiles

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What this is

Personal macOS dotfiles, Stow-managed. Each top-level directory is a "stow package" that mirrors `$HOME`. Running `./install.sh` installs Homebrew packages, sets up zsh (oh-my-zsh + p10k + plugins), and symlinks every package into `$HOME`.

## Bootstrapping a new Mac

Prerequisites (install manually first):

- iTerm2
- Google Chrome
- 1Password (sign in)

A fresh Mac has neither `git`, `brew`, nor `gh` available — those are installed *by* `install.sh`. So the bootstrap has a chicken-and-egg phase before the clone:

```bash
# 1. Trigger Xcode Command Line Tools install (provides git, swiftc, etc.)
xcode-select --install
# Accept the dialog. Wait ~10 min.

# 2. Generate an SSH key for GitHub
ssh-keygen -t ed25519 -C "your@email"
# Accept defaults. Passphrase optional (store in 1Password if set).

# 3. Add the public key to GitHub via the web UI
pbcopy < ~/.ssh/id_ed25519.pub
# Open https://github.com/settings/ssh/new — paste — save.

# 4. Verify SSH works
ssh -T git@github.com
# Expected: "Hi <username>! You've successfully authenticated…"

# 5. Clone dotfiles + run installer
mkdir -p ~/repos
git clone git@github.com:gilpeled/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles
./install.sh
# Long step (~30 min). Brew bundle does the heavy lifting.
```

After `install.sh` completes:

1. Sign in to the Mac App Store (so `mas` can install Xcode and other App Store apps; brew bundle will retry on next run, or use `mas install <id>` manually).
2. `gh auth login` and then `gh auth setup-git`.
3. `./scripts/clone-repos.sh` — clones work repos into `~/repos/`.
4. Open **System Settings → Privacy & Security** and grant permissions for Aerospace (Accessibility), Tailscale (Network Extensions), Amphetamine (Accessibility), Mounty (Disk), 1Password (auto-fill).
5. Launch `aerospace` once manually so it requests its permissions.

## Structure

Each top-level directory is a stow package — its contents mirror `$HOME`.

| Package        | Target                         |
| -------------- | ------------------------------ |
| `zsh/`         | `~/.zshrc`, `~/.p10k.zsh`, ... |
| `git/`         | `~/.gitconfig`                 |
| `tmux/`        | `~/.tmux.conf`                 |
| `glow/`        | `~/.config/glow/`              |
| `aerospace/`   | `~/.config/aerospace/`         |
| `opencode/`    | `~/.config/opencode/`          |
| `iterm2/`      | iTerm2 prefs                   |
| `claude/`      | `~/.claude/`                   |
| `npm/`         | `~/.npmrc` (supply-chain guard)|
| `bun/`         | `~/.bunfig.toml` (supply-chain guard)|
| `shims/macos/` | `~/.local/bin/` shims          |

Support directories (not stowed):

- `scripts/macos/` — run by `install.sh` (e.g. `macos-defaults.sh`).
- `scripts/clone-repos.sh` — work repo cloner.
- `homework/` — reference reading.

## How to add a tool

1. Add the formula or cask to `Brewfile`.
2. Run `brew bundle install` (or just re-run `./install.sh`).

If the tool ships a config file:

- Add it to an existing package (e.g. drop a new `~/.config/foo/foo.toml` into `glow/.config/foo/foo.toml`).
- Or create a new package directory mirroring `$HOME`, then `stow <pkg>`.

## How to update Brewfile

```bash
brew bundle dump --describe --mas --force --file=Brewfile
```

Review the diff, then commit.

## Idempotency

`./install.sh` is safe to re-run. On the first run, any pre-existing real files in `$HOME` that would conflict with a stow symlink get backed up to `~/.dotfiles-backup-<timestamp>/` before stow runs. Subsequent runs use `stow --restow`, which is a no-op if everything is already linked.
