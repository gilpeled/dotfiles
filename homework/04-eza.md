# eza

**`ls`, but it's 2025.**

`eza` is a modern replacement for `ls` (the successor to the now-unmaintained `exa`). Same idea — list files — but with colors that mean something, git status integration, tree mode, sane defaults, and icons if your font supports them.

## Why you'll like it

- Colors files by type, owner, age — not just executable-vs-not.
- `--git` shows per-file git status next to each entry. No more `git status` after `ls`.
- `--tree` is `tree(1)` built in. `--git-ignore` skips ignored files.
- `-l` columns are smarter: human-readable sizes by default, ISO dates by request.
- Icons via `--icons` — actually useful for scanning a directory at a glance.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install eza`.

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `eza` | Like `ls`, with color. |
| `eza -la --icons --group-directories-first` | The "long listing I'll actually use." Hidden files, dirs first, icons. |
| `eza -la --git` | Long listing with a git status column per file (M, +, !, etc.). |
| `eza --tree --level=2` | Tree view, depth 2. Replace `tree`. |
| `eza --tree --git-ignore` | Tree, but skip anything in `.gitignore`. Great for repo overviews. |
| `eza -lS` | Sort by size. `-Snew` / `-Sold` / `-Smodified` for time. |
| `eza --time-style=long-iso` | Show full ISO timestamps. |

Worth aliasing in `~/dotfiles/zsh/.zshrc`:

```zsh
alias ls='eza --group-directories-first'
alias ll='eza -la --git --icons --group-directories-first'
alias lt='eza --tree --level=2 --git-ignore'
```

## Gotchas / tips

- `eza` does not replace `ls` automatically. Either alias it (above) or type `eza` explicitly. Some scripts call `ls` and expect POSIX output — don't alias `ls` system-wide if you write a lot of bash.
- `--icons` requires a Nerd Font (this repo installs `font-meslo-lg-nerd-font` and iTerm2 should be set to use it).
- `eza` does NOT auto-paginate. Pipe to `less -R` (or `bat`) for huge dirs. Or `eza -1` for one-per-line.
- `--git` reads `.git/index` per call — fast, but if it's slow on a giant repo, omit it.

## Try it now

```bash
# A directory you actually have
eza -la --git --icons --group-directories-first ~/repos/SimplyPiano

# Tree view of the dotfiles repo, ignoring .gitignored stuff
eza --tree --level=3 --git-ignore ~/dotfiles

# Largest files in your downloads
eza -lS ~/Downloads | head -20

# Add the aliases above and reload
$EDITOR ~/dotfiles/zsh/.zshrc
exec zsh
```

## Further reading

- [eza on GitHub](https://github.com/eza-community/eza) — full flag reference.
- [eza website](https://eza.rocks/) — short tour with screenshots.
