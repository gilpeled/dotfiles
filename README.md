# dotfiles

Personal dotfiles for macOS, managed with [GNU Stow](https://www.gnu.org/software/stow/).

## What this is

Personal macOS dotfiles, Stow-managed. Each top-level directory is a "stow package" that mirrors `$HOME`. Running `./install.sh` installs Homebrew packages, sets up zsh (oh-my-zsh + p10k + plugins), and symlinks every package into `$HOME`.

## Bootstrapping a new Mac

Prerequisites (install manually first):

- iTerm2
- Google Chrome
- 1Password (sign in)

Then:

```bash
git clone git@github.com:gilpeled/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

After `install.sh` completes:

1. Sign in to the Mac App Store (so `mas` can install Xcode etc.).
2. `gh auth login` — authenticate with GitHub.
3. `./scripts/clone-repos.sh` — clone work repos into `~/gitRepos/`.
4. Open **System Settings → Privacy & Security** and grant permissions for Aerospace (Accessibility), Tailscale (Network Extensions), Amphetamine (Accessibility), Mounty (Disk), 1Password (auto-fill).

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
