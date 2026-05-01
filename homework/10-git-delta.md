# git-delta

**Pretty git diffs. Side-by-side, syntax-highlighted, line-numbered.**

`delta` is a pager for git's diff output. It replaces the default `less`-style red/green text wall with a syntax-highlighted, optionally side-by-side view. It's a drop-in: configured via `~/.gitconfig`, no new commands to learn — `git diff`, `git log -p`, `git show`, and `git stash show -p` all flow through it.

This repo's `~/dotfiles/git/.gitconfig` already configures delta (`pager = delta`, `side-by-side = true`, `navigate = true`, `line-numbers = true`).

## Why you'll like it

- Side-by-side mode shows old and new in two columns, like a GitHub PR view.
- Each line is syntax-highlighted by language (Swift, Python, TS, etc.).
- `n` / `N` jump to next/previous file in the diff (the `navigate = true` setting).
- Works for every git command that emits a diff. No special invocation.
- Plays well with `git add -p` interactive staging — diffs stay readable.

## Install

If installed via the dotfiles Brewfile, no action — and the gitconfig already wires it up. Otherwise:

```bash
brew install git-delta
```

Then in `~/.gitconfig`:

```ini
[core]
    pager = delta
[interactive]
    diffFilter = delta --color-only
[delta]
    navigate = true
    side-by-side = true
    line-numbers = true
[merge]
    conflictstyle = zdiff3
```

## The 80% you'll actually use

| Command | What it does (with delta wired in) |
| --- | --- |
| `git diff` | Pretty diff of unstaged changes. |
| `git diff --staged` | Same for staged changes. |
| `git log -p` | Commit history with the patch for each commit. |
| `git show HEAD` | The diff of one commit. |
| `git stash show -p` | Diff of a stash entry. |
| Inside the pager: `n` | Next file in the diff (because `navigate = true`). |
| Inside the pager: `N` | Previous file. |
| Inside the pager: `q` | Quit. |
| `delta old.txt new.txt` | Diff two files outside git. |

To toggle side-by-side off for one command:

```bash
git -c delta.side-by-side=false diff
```

To strip color when piping to a file:

```bash
git diff | delta --no-gitconfig --color-only=false > diff.txt
```

## Gotchas / tips

- Side-by-side breaks down on very long lines; you'll see truncation. Press `-` to toggle line wrapping in the pager (`less` keybind).
- `delta` requires `less` (which ships with macOS) — it pages through it. If `LESS` is set funny in your env, output may behave oddly. Default is fine.
- The `merge.conflictstyle = zdiff3` setting (in this repo's gitconfig) gives you 3-way conflict markers that delta renders nicely. Keep it.
- For commit-message editor diffs (when you set `commit.verbose = true` like this repo does), the diff in the editor is a plain patch — delta only kicks in for terminal output.

## Try it now

```bash
# In any repo, make a small change and view the diff
cd ~/gitRepos/SimplyPiano
git status
git diff                    # side-by-side syntax-highlighted

# Pretty per-commit history
git log -p -3

# Inside the pager: press `n` to jump to the next file, `q` to quit.

# Compare two arbitrary files
delta ~/dotfiles/install.sh /tmp/old-install.sh

# Toggle side-by-side off temporarily
git -c delta.side-by-side=false diff
```

## Further reading

- [delta on GitHub](https://github.com/dandavison/delta) — feature tour and config reference.
