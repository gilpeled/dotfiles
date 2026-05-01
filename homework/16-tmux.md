# tmux

**Persistent, splittable terminal sessions.**

tmux is a "terminal multiplexer." It does three things that, together, change how you use the terminal:

1. **Splits.** One terminal window, many panes. Run a server in one, edit in another, watch logs in a third.
2. **Windows.** Multiple "tabs" inside a single tmux session. Switch with `Ctrl-b 1`, `Ctrl-b 2`, etc.
3. **Detach + reattach.** This is the killer feature. You start a tmux session, run a long process, close iTerm — process keeps running. Open iTerm tomorrow, `tmux attach`, and you're exactly where you left off.

You don't need tmux to be productive. But for "I left an SSH session running and my laptop slept and now everything died" scenarios, and for keeping a structured layout across days, it's hard to beat.

This repo's `~/.tmux.conf` uses the **default prefix `Ctrl-b`**. Some configs remap to `Ctrl-a` — yours doesn't.

## Why you'll like it

- Detach (`Ctrl-b d`) and reattach (`tmux attach`) — work survives terminal crashes, reboot-less laptop closing, SSH disconnects.
- Splits are scriptable: `tmux split-window -h -c ~/gitRepos/SimplyPiano` sets up a layout for a project.
- This repo's config sets `mouse on`, so you can click panes / resize with the mouse if you want — but the keys work the same.
- Vi-mode copy: `Ctrl-b [` enters scroll/copy mode, `v` selects, `y` yanks to system clipboard.
- Window bars at the bottom show what's running where.

## Install

If installed via the dotfiles Brewfile, no action. The repo's `tmux/.tmux.conf` is already stowed at `~/.tmux.conf`.

Otherwise: `brew install tmux`.

## The 80% you'll actually use

Everything in tmux starts with the **prefix key**: `Ctrl-b`. Press it, release, then press the next key.

### Sessions

| Command | What it does |
| --- | --- |
| `tmux` | Start a new unnamed session. |
| `tmux new -s work` | Start a session named "work". |
| `tmux ls` | List running sessions. |
| `tmux attach` (or `tmux a`) | Attach to the most recent. |
| `tmux a -t work` | Attach to "work". |
| `tmux kill-session -t work` | Stop a session. |

### Inside a session

| Keys | What it does |
| --- | --- |
| `Ctrl-b d` | **Detach.** Process keeps running. |
| `Ctrl-b ?` | Show all keybindings. |
| `Ctrl-b c` | New window (tab). |
| `Ctrl-b 1` / `2` / `3` | Switch to window 1, 2, 3. |
| `Ctrl-b ,` | Rename current window. |
| `Ctrl-b w` | List/pick windows interactively. |
| `Ctrl-b \|` | Vertical split (this repo's binding). |
| `Ctrl-b -` | Horizontal split (this repo's binding). |
| `Ctrl-b h` / `j` / `k` / `l` | Move pane (this repo's vi-style bindings). |
| `Ctrl-b H` / `J` / `K` / `L` | Resize pane in 5-cell steps. |
| `Ctrl-b z` | Zoom focused pane to fullscreen. Same key un-zooms. |
| `Ctrl-b x` | Kill focused pane (asks). |
| `Ctrl-b [` | Enter scroll/copy mode. `q` to exit. |
| `Ctrl-b R` | Reload `~/.tmux.conf` (this repo's binding). |

## Gotchas / tips

- **The prefix is a chord, not a hold.** `Ctrl-b d` means: hold Ctrl, tap b, release Ctrl, then tap d. Beginners hold Ctrl through the whole thing — that breaks.
- Detach is **not** quit. `Ctrl-b d` leaves the session running. To actually kill it, `tmux kill-session` or `exit` every shell inside.
- Inside copy mode (`Ctrl-b [`), this repo uses **vi keys**: `h/j/k/l` to move, `v` to start selection, `y` to copy. Outside copy mode, it's still your normal shell.
- Splits inherit the cwd of the parent pane (this repo configures `-c "#{pane_current_path}"`). So splitting in `~/gitRepos/SimplyPiano` opens the new pane there.
- iTerm2 already has tabs and splits — feels redundant at first. The point of tmux is **persistence**: iTerm splits die when iTerm dies; tmux splits survive.

## A 5-minute first session

Try this once. It's the fastest way to get the muscle memory.

```bash
# 1. Start a named session
tmux new -s scratch

# Now you're inside tmux. The bottom bar shows "scratch" on the left.

# 2. Split horizontally (left/right)
#    Press: Ctrl-b |        (the | key, not "and")
#    You should see two panes.

# 3. Move between panes
#    Press: Ctrl-b h    then    Ctrl-b l

# 4. In the right pane, run a long command
top
#    (or `htop`, or `btop`, or `tail -f /tmp/foo`)

# 5. Detach
#    Press: Ctrl-b d
#    You're back in plain iTerm. `top` is still running inside tmux.

# 6. Confirm the session is alive
tmux ls
# scratch: 1 windows (created ...) (attached)

# 7. Close iTerm entirely. Open a new iTerm. Re-attach:
tmux a -t scratch
# top is still running, exactly where you left it.

# 8. Kill it for real when done
#    inside tmux:  Ctrl-b x  (close the pane), or:
exit            # in each pane
```

After that one walkthrough, the remaining keys (`c` for new window, `[` for scroll mode) are easy to add one at a time.

## Further reading

- [tmux 2: Productive Mouse-Free Development](https://pragprog.com/titles/bhtmux2/tmux-2/) — a short book; you'll be done in two hours and know everything.
- [tmux man page](https://man.openbsd.org/tmux) — terse, complete.
