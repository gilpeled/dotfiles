# glow

**Render markdown in the terminal, pretty.**

`glow` reads a Markdown file and prints it to your terminal with headings, bold, code blocks, lists, links — all rendered. It's the easiest way to read a project's README, ADRs, or your own notes without leaving the shell.

## Why you'll like it

- `glow README.md` is faster than opening GitHub in a browser.
- Auto-pages long docs (similar to `bat`).
- Has a TUI mode (`glow` with no args) that browses Markdown files in cwd recursively, including a search.
- Theming — defaults look great on dark iTerm; `glow -s dark` / `-s light` / custom JSON for tweaks.
- Reads from stdin, so `curl -s URL | glow -` works for online READMEs.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install glow`.

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `glow README.md` | Render a single file. |
| `glow .` | TUI: browse all `.md` files under cwd. Arrow keys to navigate, `enter` to read, `q` to back out. |
| `glow` | TUI from cwd. Tabs for "Local," "Stashed," etc. |
| `glow -p README.md` | Force pager. (Default already pages if tall.) |
| `glow -s dark` / `-s light` | Force a built-in theme. |
| `glow -w 100 README.md` | Wrap to 100 columns. |
| `curl -s https://raw.githubusercontent.com/.../README.md \| glow -` | Read from stdin. |

## Gotchas / tips

- The TUI is nice but not magic — it walks recursively and can be slow in big monorepos. Use `glow path/to/specific/dir` or pass a single file.
- It only renders **CommonMark + GFM-ish** Markdown. Custom HTML embedded in markdown shows as raw HTML.
- Code blocks are syntax-highlighted via Chroma. Most languages work; obscure ones fall back to plain.
- This dotfiles repo has a `glow/.config/glow/` package — that's where you'd drop a custom style. Default is fine.

## Try it now

```bash
# Read this very repo's README
glow ~/dotfiles/README.md

# Browse the homework directory in TUI mode
glow ~/dotfiles/homework

# Read SimplyPiano's README without leaving the terminal
glow ~/gitRepos/SimplyPiano/README.md

# Pull a remote README and render it
curl -s https://raw.githubusercontent.com/charmbracelet/glow/master/README.md | glow -
```

## Further reading

- [glow on GitHub](https://github.com/charmbracelet/glow) — themes, config, and stash notes.
