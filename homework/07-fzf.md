# fzf

**Fuzzy-find anything in your terminal.**

`fzf` is a general-purpose interactive filter. Pipe any list of lines into it (files, processes, branches, history, anything) and it gives you a fast, fuzzy, scrollable picker. The killer feature on day one is `Ctrl-R` — fuzzy history search that replaces the dim, walking-backwards `Ctrl-R` you've used in bash for years.

This repo's `.zshrc` already loads `fzf`'s zsh integration via `source <(fzf --zsh)`, so the keybindings below work out of the box.

## Why you'll like it

- `Ctrl-R` reverse history search becomes instant + fuzzy. You'll never want to live without it.
- `Ctrl-T` inserts a fuzzy-picked filename into the current command line. (`vim <Ctrl-T>` → pick a file → enter.)
- `Alt-C` cd's into a fuzzy-picked subdirectory.
- The standalone `fzf` command is a Lego brick — pipe anything in, get an interactive picker, get the chosen line out.
- Multi-select with `Tab` (when `-m` is on).

## Install

If installed via the dotfiles Brewfile, no action. The dotfiles `.zshrc` already wires up keybindings via `source <(fzf --zsh)`.

Otherwise: `brew install fzf`.

## The 80% you'll actually use

| Keybinding / command | What it does |
| --- | --- |
| `Ctrl-R` | Fuzzy search shell history. Press it. Type. Enter. |
| `Ctrl-T` | Fuzzy-pick a file path and insert it onto the current command line. |
| `Alt-C` | Fuzzy-pick a subdirectory and cd into it. |
| `**<Tab>` | Tab-completion-driven picker. `vim **<Tab>` opens a file picker. `cd **<Tab>` opens a dir picker. |
| `command \| fzf` | Pipe in any list, fuzzy-select one line. |
| `fzf -m` | Multi-select mode (Tab to mark). |
| `fzf --preview 'bat --color=always {}'` | Live preview pane while picking. Beautiful with `bat`. |

Searching syntax inside the picker (works in `Ctrl-R` too):

- `foo bar` — must contain both terms (AND).
- `'exact` — exact substring (single-quote prefix).
- `^foo` — starts with `foo`.
- `foo$` — ends with `foo`.
- `!foo` — must NOT contain `foo`.

## Gotchas / tips

- The `**<Tab>` trigger is great but easy to forget. `Ctrl-T` is usually faster.
- `fzf` integrates with `fd`/`ripgrep` if you set `FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'` — picks become much faster in big repos. Worth adding to `~/dotfiles/zsh/.zshrc`.
- The default preview command is empty. Setting `--preview 'bat --color=always --line-range :200 {}'` is a huge upgrade and you can put it in `FZF_CTRL_T_OPTS`.
- `Ctrl-R` shows the most-recent commands first. Sort by frequency by passing `--scheme=history` to FZF (already the default in recent fzf).

## Try it now

```bash
# In any shell, type Ctrl-R and start typing 'git' — fuzzy history search.

# Pick a file from your iOS repo and open it
vim $(fzf --preview 'bat --color=always --line-range :200 {}' < <(fd -t f . ~/gitRepos/SimplyPiano))

# Multi-select branches and check one out
git branch | fzf -m

# Kill a process by fuzzy-picking it
ps -ef | fzf | awk '{print $2}' | xargs kill

# Add a saner default command (paste into ~/dotfiles/zsh/.zshrc)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :200 {}'"
```

## Further reading

- [fzf README](https://github.com/junegunn/fzf) — complete keybindings + `--preview` examples.
- [fzf wiki: Examples](https://github.com/junegunn/fzf/wiki/Examples) — recipes for git, kubectl, processes, etc.
