# btop

**Activity Monitor for the terminal, but pretty.**

`btop` is a real-time system monitor showing CPU (per-core), memory, disk I/O, network I/O, and processes — all in one pane, updated several times per second, navigable with the keyboard or mouse. It replaces `top`, `htop`, and a lot of trips to Activity Monitor when you just want to see "what's eating CPU?"

## Why you'll like it

- One screen, everything visible: CPU graphs (per core), RAM/swap bars, disk read/write graphs, network in/out graphs, and a process list.
- Process tree view (`t`) so you can see who spawned what.
- Sort by CPU/RAM/PID/etc. with one keypress.
- Kill a process with `k`. Filter the list with `f`. Search with `/`.
- GPU support (Apple Silicon shows up with `+` to add the GPU box).

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install btop`.

## The 80% you'll actually use

Run with `btop`. Inside:

| Key | What it does |
| --- | --- |
| `q` | Quit. |
| `↑` / `↓` / `j` / `k` | Move in the process list. |
| `Enter` | Show full info for the focused process. |
| `t` | Toggle tree view (parent → children). |
| `f` | Filter processes by string. |
| `/` | Search. |
| `k` | Kill the focused process. (Confirms first.) |
| `space` | Pause auto-refresh. |
| `+` / `-` | Add/remove a panel (GPU, network, disk). |
| `1` / `2` / `3` / `4` | Toggle the four main panels (CPU, mem, net, processes). |
| `Esc` then `o` | Open the options menu (theme, refresh rate, columns). |
| `e` | Sort by CPU. (Cycles columns: CPU → MEM → PID → ...) |

## Gotchas / tips

- On macOS, btop reads CPU/disk stats via `/usr/bin/top`-style APIs — totally fine, no special perms. Killing a process owned by another user does need `sudo btop`.
- Default theme is dark; presets are under `~/.config/btop/themes/`. Run `btop` then `Esc → options → theme` to flip through.
- Refresh rate defaults to 2000ms. Crank it down for live debugging (`Esc → options → update ms`); leave high to save battery.
- If you want to monitor a specific process tree, `f`-filter by binary name and switch to tree view.

## Try it now

```bash
# Just open it
btop

# Inside btop:
#   - press `t` to see the process tree
#   - press `e` to sort by CPU
#   - press `f`, type "Xcode", Enter — filter to Xcode processes
#   - arrow up/down to a process, press Enter to see its detail
#   - q to quit

# After: kick off something CPU-heavy in another tab and watch it light up
yes > /dev/null & btop      # don't forget to `kill %1` when done
```

## Further reading

- [btop on GitHub](https://github.com/aristocratos/btop) — full key reference, themes, troubleshooting.
