# powerlevel10k

**The fastest, prettiest zsh prompt you'll ever use.**

Powerlevel10k (p10k) is a zsh theme that shows a context-rich prompt — current dir, git status, last command's exit code, Python venv, node version, etc. — without the slow startup that usually plagues fancy prompts. It uses an **instant prompt** trick that renders the prompt before the rest of `.zshrc` finishes loading, so your shell feels snappy even with lots of plugins.

This repo's `.zshrc` already sets `ZSH_THEME="powerlevel10k/powerlevel10k"`, and the `.p10k.zsh` config is checked in.

## Why you'll like it

- Renders in <50ms. Slow prompts ruin the shell experience; this one doesn't.
- `p10k configure` is a one-time interview that builds the whole config for you (icons? two lines? rainbow? lean?). No reading docs.
- Shows git status (branch, ahead/behind, dirty, stash) inline without a separate `git status`.
- "Transient prompt" mode: previous prompts collapse to a single line as you scroll up, keeping the screen clean.
- Asynchronous segments — slow checks (k8s context, AWS profile) never block the prompt.

## Install

If installed via the dotfiles `install.sh`, no action — it clones p10k into `$ZSH_CUSTOM/themes/powerlevel10k`. Otherwise:

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Then set `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`.

## The 80% you'll actually use

| Command / setting | What it does |
| --- | --- |
| `p10k configure` | The interactive setup wizard. Run any time to re-skin the prompt. |
| Edit `~/.p10k.zsh` | All settings live here. Heavily commented. |
| `POWERLEVEL9K_LEFT_PROMPT_ELEMENTS` | Array of segments shown on the left. Edit, restart shell. |
| `POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS` | Same but right side. |
| `POWERLEVEL9K_INSTANT_PROMPT=verbose` | Default. Shows warnings if `.zshrc` does something instant-prompt-incompatible. |
| `p10k display -a` | Toggle visibility of every segment to learn what's what. |

## Gotchas / tips

- **Instant prompt requires that `~/.zshrc` produce no console output before p10k loads.** That's why the file has the cryptic block at the very top:

  ```zsh
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  ```

  Anything that prints (e.g. `nvm` showing a "now using node X" message) must go *above* this block, or be silenced. If you see "Console output during instant prompt" warnings, that's the cause.
- **Icons need a Nerd Font.** This repo's Brewfile installs `font-meslo-lg-nerd-font`. iTerm2 must be configured to use it (Profiles → Text → Font).
- `~/.p10k.zsh` is checked in via the `zsh` stow package. If you re-run `p10k configure`, it will overwrite it — commit the change in the repo or it'll feel weird.
- The "lean" style is a great default if you don't want a lot of color. The "rainbow" / "classic" styles look great on a black iTerm. Try a few.

## Try it now

```bash
# Re-customize the prompt — this is the killer command
p10k configure

# Cycle through every segment to learn what's available
p10k display -a

# See timing — should be <50ms
time zsh -i -c exit

# Look at the (heavily commented) config
$EDITOR ~/dotfiles/zsh/.p10k.zsh

# After editing .p10k.zsh, reload the shell to see changes
exec zsh
```

## Further reading

- [Powerlevel10k README](https://github.com/romkatv/powerlevel10k) — also covers the FAQ ("why is my prompt slow", "how do I add a custom segment").
- [Nerd Fonts](https://www.nerdfonts.com/) — if you want a different patched font.
