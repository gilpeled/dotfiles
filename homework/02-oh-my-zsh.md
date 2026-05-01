# oh-my-zsh

**A plugin/theme framework for zsh that turns a stock shell into a useful one.**

Zsh ships with macOS but is barebones out of the box. oh-my-zsh (OMZ) is a community-maintained collection of plugins, themes, and helpers that loads from a single `source` line in `~/.zshrc`. It gives you tab completion for hundreds of tools, a decent default keymap, git aliases, and a plugin system that nearly every other zsh enhancement targets.

Alternatives exist (prezto, zinit, zim, plain zsh) — but OMZ is the lowest-friction default and what the rest of this dotfiles setup builds on.

## Why you'll like it

- One-line opt-in for hundreds of completions and aliases (`plugins=(git docker brew ...)` in `.zshrc`).
- Theming via `ZSH_THEME=` — this repo uses `powerlevel10k/powerlevel10k`.
- Plays well with Homebrew-installed plugins like `zsh-autosuggestions` and `zsh-syntax-highlighting`.
- `omz update` handles upgrades. No package manager needed for the framework itself.
- Huge community — when you Google "zsh do X", the answer usually assumes OMZ.

## Install

If installed via the dotfiles `install.sh`, no action — it clones OMZ to `~/.oh-my-zsh` if missing. Otherwise:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## The 80% you'll actually use

| Command / setting | What it does |
| --- | --- |
| `plugins=(git brew docker)` in `~/.zshrc` | Activate plugins. Each adds aliases/completions. Restart shell after changing. |
| `ZSH_THEME="powerlevel10k/powerlevel10k"` | Theme. Set in `~/.zshrc`. |
| `omz update` | Pull the latest OMZ. Run occasionally. |
| `omz reload` | Re-source `~/.zshrc` without opening a new shell. |
| `omz plugin list` | List available plugins. |
| `alias` | Print all active aliases (OMZ's git plugin alone defines ~150). |

Useful built-in plugins to consider adding to `plugins=(...)`:

- `git` — already on. `gst`, `gco`, `gp`, etc. Run `alias | grep '=git '` to see them all.
- `brew` — completion + a few aliases.
- `docker` / `podman` — container completions.
- `macos` — `cdf` (cd to current Finder dir), `quick-look`, `tab` (open new tab).
- `zsh-autosuggestions` — ghost-text suggestion of your last matching command. Press `→` to accept. Already installed by `install.sh`.
- `zsh-syntax-highlighting` — colors commands red until they're valid. Already installed.

To activate the two installed-but-not-yet-listed plugins, edit `~/dotfiles/zsh/.zshrc`:

```zsh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

`zsh-syntax-highlighting` must be **last** in the list.

## Gotchas / tips

- **Don't add 30 plugins.** Each one runs at shell start; startup time balloons. The instant prompt cache (see powerlevel10k) hides this, but `time zsh -i -c exit` will tell the truth.
- The `git` plugin's aliases conflict with anything else named `gst`, `gco`, etc. Worth knowing before you go looking for the `gst` Gemfile tool.
- `~/.zshrc` is a symlink into the dotfiles repo. Edit it at `~/dotfiles/zsh/.zshrc` per the stow guide.
- After editing `.zshrc`, `omz reload` (alias for `exec zsh`) is faster than closing iTerm.

## Try it now

```bash
# What plugins are loaded right now?
echo $plugins

# Sample what the git plugin gave you
alias | grep '=git ' | head -20

# Browse the plugin catalogue
ls ~/.oh-my-zsh/plugins | head -30

# Read what a plugin actually does (e.g. macos)
glow ~/.oh-my-zsh/plugins/macos/README.md   # or `bat` / `cat`

# Add zsh-autosuggestions + syntax-highlighting (edit in the repo)
$EDITOR ~/dotfiles/zsh/.zshrc
# change: plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
omz reload
```

## Further reading

- [oh-my-zsh wiki](https://github.com/ohmyzsh/ohmyzsh/wiki) — plugin and theme catalogue.
- [The Z Shell manual](https://zsh.sourceforge.io/Doc/) — when you actually need to learn zsh itself.
