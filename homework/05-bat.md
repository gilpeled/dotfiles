# bat

**`cat` with syntax highlighting and a built-in pager.**

`bat` prints files to the terminal — same job as `cat` — but with line numbers, syntax highlighting for ~200 languages, git diff markers in the gutter, and automatic paging through `less` when the output is taller than the screen. When piped, it falls back to plain output so it doesn't break scripts.

## Why you'll like it

- Reading source files in the terminal stops being a wall of grey.
- `git diff` already pretty-prints in this dotfiles setup (see `git-delta`), but `bat <file>` is the same idea for any file you didn't just modify.
- Auto-detects language from extension and shebang. `bat install.sh` highlights bash; `bat foo.py` highlights Python.
- `bat --plain` strips formatting so it can be a drop-in `cat` replacement in pipes/scripts.
- Honors `$PAGER` settings; you can search inside it (`/foo`, `n` for next match) like normal `less`.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install bat`.

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `bat foo.py` | Print with highlighting + line numbers + paging. |
| `bat -p foo.py` (`--plain`) | No line numbers, no decorations. For piping or script use. |
| `bat -A` | Show whitespace, tabs, newlines explicitly. Debugging weird files. |
| `bat -r 50:80 foo.py` | Show only lines 50–80. |
| `bat --diff foo.py` | Highlight only lines changed since last commit. |
| `bat -l json data.txt` | Force language. Useful when extension lies. |
| `bat --list-languages` | What it can highlight. |
| `bat --list-themes` | Color schemes. Set with `BAT_THEME=` env var. |

## Gotchas / tips

- In a pipe (`cat foo | bat` or `bat foo | grep ...`) it auto-disables paging and color. Use `--paging=never` and `--color=always` to force.
- `bat -p` is what you want in scripts/Makefiles — same output as `cat` in non-pipe context.
- For `man` pages, set `MANPAGER="sh -c 'col -bx | bat -l man -p'"` for highlighted man pages. Add to `~/dotfiles/zsh/.zshrc` if you like it.
- The built-in dark themes are mostly fine; `BAT_THEME="Monokai Extended"` or `OneHalfDark` look great on iTerm's default.

## Try it now

```bash
# Read a file in your dotfiles
bat ~/dotfiles/install.sh

# Just lines 100..120
bat -r 100:120 ~/dotfiles/install.sh

# Pretty-print the gitconfig
bat ~/dotfiles/git/.gitconfig

# Use bat as a man pager once
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
man ls

# Use --plain in a pipe
bat -p ~/dotfiles/Brewfile | grep -i cask
```

## Further reading

- [bat README](https://github.com/sharkdp/bat) — full options + `bat --help`.
