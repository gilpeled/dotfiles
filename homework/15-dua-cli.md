# dua-cli

**Disk usage, interactively.**

`dua` (Disk Usage Analyzer) shows you what's eating disk space. Two modes: a fast `du`-like one-shot summary, and an interactive TUI (`dua i`) where you navigate directories, see sizes update live, and delete things — without leaving the terminal. It's the "Disk Inventory X" / DaisyDisk experience, but free, fast, and on the command line.

## Why you'll like it

- Parallel scan — full home dir analysis in seconds, not minutes (vs. `du -sh ~/* | sort`).
- Interactive mode: arrow keys, see size right next to each subdir, drill in, navigate up.
- Delete inside the TUI with `d`. Big "are you sure" guard.
- Reports in MB/GB/MiB/GiB depending on flags. Sensible defaults.
- Works on any path: `dua i ~/repos` to find which repo has bloated `node_modules`.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install dua-cli`.

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `dua` | One-shot scan of cwd, sizes per direct child. |
| `dua ~` | Same, but explicit path. |
| `dua i` | **Interactive TUI** of cwd. The one you'll actually use. |
| `dua i ~/Library` | TUI starting at `~/Library`. |
| `dua --threads 8 i ~` | More worker threads (default is fine on M-series Macs). |
| `dua --apparent-size` | Apparent size instead of disk-allocated size. |

Inside `dua i`:

| Key | What it does |
| --- | --- |
| `↑` / `↓` / `j` / `k` | Move. |
| `Enter` / `→` / `l` | Drill into the highlighted dir. |
| `←` / `h` / `Backspace` | Up one level. |
| `s` | Sort cycle (size, name, mtime). |
| `g` then `G` | Top of list / bottom. |
| `m` | Mark for deletion (multi-select). |
| `d` | Delete marked entries (asks for confirmation). |
| `?` | Help overlay. |
| `q` | Quit. |

## Gotchas / tips

- `dua` does **not** follow symlinks by default (good — your `~/dotfiles` symlink farm won't be double-counted).
- macOS reports a "Used" disk number that includes purgeable/local snapshots. `dua` reports actual file bytes, so the totals will differ from "About This Mac → Storage." Trust the per-directory breakdown either way.
- On the first run against `~`, `dua i` may flash huge numbers for `~/Library/Caches`, `~/Library/Developer` (Xcode DerivedData), and `~/.Trash`. These are usually safe to nuke; consult `tldr` for the safe `xcrun simctl delete unavailable` etc.
- Deletion in TUI is permanent — no Trash. The confirmation is your only seatbelt.

## Try it now

```bash
# Find the heaviest directories under your home
dua i ~

# Drill into Library (the usual offender)
dua i ~/Library

# Find the biggest repo on disk
dua i ~/repos

# One-shot, no TUI — useful in scripts or CI
dua ~/repos | head -20

# Combine with sort/grep if you want quick numbers
dua --apparent-size ~/Downloads | sort -h
```

## Further reading

- [dua-cli on GitHub](https://github.com/Byron/dua-cli) — flag reference and TUI keybindings.
