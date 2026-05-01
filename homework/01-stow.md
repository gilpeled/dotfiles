# GNU Stow

**Symlink farms for your dotfiles, with one command.**

Stow takes a directory like `~/dotfiles/zsh/` and symlinks every file inside it into your `$HOME` at the matching relative path. So `~/dotfiles/zsh/.zshrc` becomes `~/.zshrc` (a symlink). That's the whole trick. It's the mechanism that makes this `~/dotfiles` repo possible: the repo is the source of truth, your `$HOME` just has links pointing back.

It replaces the more painful options: a custom install script that `cp`s files (drifts immediately), bare-git tricks (confusing), or hand-symlinking (tedious and error-prone).

## Why you'll like it

- One mental model: each top-level directory in `~/dotfiles` is a "package" whose contents mirror `$HOME`.
- Editing `~/.zshrc` is editing the file in the repo — they're the same inode. `git status` just works.
- Adding a new tool's config is "drop the file in the right package, re-run install."
- Idempotent. `stow --restow` removes old links and re-creates them. Safe to run repeatedly.
- No DSL, no daemon, no magic. Just symlinks.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install stow`.

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `stow -n -t ~ zsh` | **Dry run.** Print what would be linked, don't touch anything. Always do this first. |
| `stow -t ~ zsh` | Link `~/dotfiles/zsh/*` into `~/`. |
| `stow --restow -t ~ zsh` | Unlink, then re-link. The idempotent default. This repo's `install.sh` uses this. |
| `stow -D -t ~ zsh` | **Unlink.** Removes the symlinks `stow` made for the `zsh` package. |
| `stow -d shims -t ~ macos` | Use a non-default stow dir. `--dir`/`-d` says "the package lives under `shims/`, not `./`". |

The `-t` (target) flag defaults to the parent of the stow dir. It's clearer to always pass it.

## Gotchas / tips

- **Edit in the repo, never in `$HOME`.** Yes, editing `~/.zshrc` works because it's a symlink — but the mental model breaks down the moment you wonder "where's the real file?" Always `cd ~/dotfiles && $EDITOR zsh/.zshrc`.
- **Never use `stow --adopt`.** It moves the file from `$HOME` *into* the repo, overwriting whatever was there. The dotfiles repo's `install.sh` instead backs up conflicting real files into `~/.dotfiles-backup-<timestamp>/` before stowing. Use that flow.
- A "package" is just a directory whose internal layout mirrors `$HOME`. So `aerospace/.config/aerospace/aerospace.toml` becomes `~/.config/aerospace/aerospace.toml`. Folder structure is the API.
- If `stow` complains about an existing file, it means a real (non-symlink) file is in the way. Move it aside, then re-stow.

## Try it now

```bash
# See what packages are present
ls ~/dotfiles

# See where one of your existing symlinks points
ls -la ~/.zshrc
# Should print something like: ~/.zshrc -> /Users/gilpeled/dotfiles/zsh/.zshrc

# Dry-run the zsh package — should report no changes since it's already stowed
stow -n -v --restow --dir=$HOME/dotfiles --target=$HOME zsh

# Add a throwaway file to the zsh package, then restow to see it appear
echo '# hello stow' > ~/dotfiles/zsh/.stow-test
stow --restow --dir=$HOME/dotfiles --target=$HOME zsh
ls -la ~/.stow-test    # symlink into the repo
rm ~/dotfiles/zsh/.stow-test
stow --restow --dir=$HOME/dotfiles --target=$HOME zsh   # the dangling link disappears
```

## Further reading

- [Official manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Using GNU Stow to manage your dotfiles](https://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) — the classic tutorial that popularized this pattern.
