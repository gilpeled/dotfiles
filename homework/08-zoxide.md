# zoxide

**`cd`, but it learns where you actually go.**

`zoxide` tracks every directory you `cd` into and ranks them by **frecency** (frequency × recency). Then `cd foo` jumps to the highest-ranked directory whose path matches `foo`. After a week of normal use, you stop typing full paths.

This repo's `.zshrc` already initializes zoxide with `eval "$(zoxide init zsh --cmd cd)"` — so plain `cd` is the smart command. There's no separate `z` binary to remember.

## Why you'll like it

- `cd simp` jumps to `~/repos/SimplyPiano` because that's where you actually live.
- Falls back to normal `cd` for anything that's a real path. Never breaks.
- `cd -` still goes to the previous directory. `cd ..` still goes up.
- `zi` opens an `fzf`-style interactive picker over your history.
- Cross-shell: same database works in zsh, bash, fish.

## Install

If installed via the dotfiles Brewfile, no action — `.zshrc` already runs `zoxide init zsh --cmd cd`. Otherwise:

```bash
brew install zoxide
# add to ~/.zshrc:
eval "$(zoxide init zsh --cmd cd)"
```

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `cd foo` | Jump to the most-frecent directory matching `foo`. |
| `cd foo bar` | Match must contain both `foo` AND `bar` (in path order). |
| `cd ~/somewhere/real` | Real paths still work normally. |
| `cd -` | Previous directory (zsh built-in, unchanged). |
| `zi` | Interactive `fzf`-style picker over your history. |
| `zoxide query foo` | Print where `cd foo` would go. (Useful for debugging matches.) |
| `zoxide query -l` | List the whole frecency database. |
| `zoxide add /some/path` | Manually add a directory. |
| `zoxide remove /some/path` | Forget a directory. |

## Gotchas / tips

- It only learns about directories you actually `cd` into. If you `pushd` or use absolute paths in scripts, those count too.
- The match is a substring on the path, ranked by frecency. So `cd dot` matches `~/dotfiles` after you've been there a few times. Disambiguate with extra terms (`cd dot home`) if needed.
- It does NOT auto-cd to a path you've never visited — you still need to walk there once.
- The database lives at `~/.local/share/zoxide/db.zo`. Tiny, but if you nuke it you start over.
- `zi` requires `fzf` to be installed (it is, in this dotfiles setup).

## Try it now

```bash
# Walk into a few directories so zoxide learns them
cd ~/dotfiles && cd ~/repos/SimplyPiano && cd ~

# Now jump
cd dot         # → ~/dotfiles
cd simp        # → ~/repos/SimplyPiano
cd home        # back to ~

# Inspect the database
zoxide query -l | head -20

# Open the interactive picker
zi             # type, arrow, enter — instant cd

# What would 'cd foo' actually do?
zoxide query simp
```

## Further reading

- [zoxide on GitHub](https://github.com/ajeetdsouza/zoxide) — full flag reference and shell-specific notes.
