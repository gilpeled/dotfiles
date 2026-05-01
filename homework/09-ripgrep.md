# ripgrep

**`grep -r`, but fast and with sane defaults.**

`rg` (ripgrep) recursively searches the current directory for a regex. It's the fastest of the modern grep replacements — written in Rust, parallel by default, and it skips `.gitignore`d files automatically. The killer ergonomic difference vs `grep -r`: you almost never need flags. `rg foo` does what you want.

## Why you'll like it

- Walks directories in parallel; on a big repo it's 5–20× faster than `grep -r`.
- Respects `.gitignore`, `.rgignore`, and binary-file detection by default — no `node_modules` noise.
- Smart-case: pattern is case-insensitive if all-lowercase, case-sensitive otherwise.
- File-type filtering: `rg foo -t py` only searches Python.
- Output already grouped by file with line numbers and color.
- One binary, no dependencies, works as `xargs` input.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install ripgrep`.

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `rg foo` | Recursively search for `foo` from cwd. |
| `rg 'def\s+foo'` | Pattern is a Rust regex. Quote it. |
| `rg -t py foo` | Only Python files. Use `--type-list` to see all types. |
| `rg -T js foo` | Exclude a type (capital `T`). |
| `rg -g '*.toml' foo` | Glob filter. |
| `rg -F 'foo.bar' ` | Fixed-string (no regex). |
| `rg -i foo` / `rg -S foo` | Force case-insensitive / smart-case. |
| `rg -l foo` | List file names only, one per match. |
| `rg -c foo` | Count matches per file. |
| `rg -A 2 -B 2 foo` | Show 2 lines after / before each match. `-C 2` does both. |
| `rg --files` | Print every file rg WOULD search (great as input to other commands). |
| `rg foo --hidden --no-ignore` | Don't skip hidden / gitignored files. |

## Gotchas / tips

- The pattern is a regex by default. Special characters (`.`, `(`, `?`) need escaping or `-F` (fixed-string) mode.
- Smart-case sometimes surprises: `rg API` is case-sensitive (mixed case), `rg api` matches `API` too.
- `rg --files` is the right input for `fzf`. `fzf --preview 'bat --color=always {}' < <(rg --files)` is a great file picker that respects `.gitignore`.
- For Xcode projects, by default `rg` skips files in `Pods/`, `.build/`, `DerivedData/` if they're in your gitignore — usually right. Use `--no-ignore` for the rare time you want to see them.

## Try it now

```bash
# Find every TODO in your iOS repo
rg TODO ~/repos/SimplyPiano

# Only Swift files mentioning 'AVAudioEngine'
rg -t swift AVAudioEngine ~/repos/SimplyPiano

# Files referencing a string but not the count
rg -l 'NSLocalizedString' ~/repos/SimplyPiano | head

# Count usages of `print(` in your Python projects
rg -c 'print\(' --type py ~/repos | head

# Pipe into fzf for interactive grep
rg --line-number --no-heading --color=always foo \
  | fzf --ansi --delimiter=: --preview 'bat --color=always {1} --highlight-line {2}'
```

## Further reading

- [ripgrep User Guide](https://github.com/BurntSushi/ripgrep/blob/master/GUIDE.md) — covers the gotchas and the regex flavor.
- [`man rg`](https://github.com/BurntSushi/ripgrep/blob/master/doc/rg.1) — terse but complete.
