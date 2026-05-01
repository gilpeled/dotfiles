# Aerospace

**A keyboard-driven tiling window manager for macOS.**

Aerospace organizes your windows into **workspaces** (think virtual desktops, but better). Each workspace contains windows arranged as **tiles** — non-overlapping rectangles that fill the screen automatically. You move focus and reshuffle tiles with the keyboard. Windows never get lost behind other windows; you never click-and-drag to resize.

It's modeled on i3wm (Linux) and yabai. The big advantage over yabai: Aerospace doesn't need SIP disabled. It uses macOS's built-in Mission Control spaces under the hood.

This repo's `aerospace/.config/aerospace/aerospace.toml` is fully configured. Below is your cheat sheet for the bindings already set there.

## Why you'll like it

- Never alt-tab through 30 windows again. Each project lives in its own workspace; switch with one keypress.
- Splits and resizes are deterministic — the layout is a tree, not a pile.
- All keyboard. The mouse becomes optional, not required.
- Reload config without quitting — edit `aerospace.toml`, hit your reload binding, done.
- Plays well with the rest of macOS — full-screen apps, menu bar, AirDrop, etc., all still work.

## Install

If installed via the dotfiles Brewfile, no action. After install you must:

1. Launch Aerospace once manually.
2. **System Settings → Privacy & Security → Accessibility** → enable Aerospace.
3. Quit and relaunch. Now keybindings work.

Otherwise: `brew install --cask nikitabobko/tap/aerospace`.

## Mental model

- **Workspaces** = numbered virtual desktops (`1` through `9`, plus letters `a..f` for secondary monitors). Each workspace holds some windows arranged in a tiling layout. You see exactly one workspace at a time per monitor.
- **Layout tree** = within a workspace, windows are arranged as a tree of horizontal and vertical splits. Most of the time you don't think about it; you just see "this one is on the left, that one is on the right."
- **Modes** = your keyboard normally is in `main` mode. Press `alt-shift-;` to enter `service` mode, where keys like `f` (toggle floating), `r` (flatten), `backspace` (close all but current) live. Esc returns you to main.

## The 80% you'll actually use (this repo's bindings)

### Focus / movement (vi-style, `alt + hjkl`)

| Keys | What it does |
| --- | --- |
| `alt-h` / `alt-j` / `alt-k` / `alt-l` | Focus window left / down / up / right (wraps around). |
| `alt-shift-h` / `alt-shift-j` / `alt-shift-k` / `alt-shift-l` | Move focused window in that direction. |
| `alt-tab` | Toggle between current and previous workspace (back-and-forth). |

### Workspaces

| Keys | What it does |
| --- | --- |
| `alt-1` … `alt-9` | Switch to workspace 1..9. |
| `alt-shift-1` … `alt-shift-9` | Send focused window to workspace 1..9 AND follow it. |
| `ctrl-alt-1` … `ctrl-alt-6` | Switch to workspaces `a..f` (intended for second monitor). |
| `ctrl-alt-shift-1` … `ctrl-alt-shift-6` | Send window to `a..f`. |
| `alt-shift-tab` | Move current workspace to the next monitor. |

### Resize / layout

| Keys | What it does |
| --- | --- |
| `alt-minus` / `alt-equal` | Smart-resize the focused window (config does asymmetric pair via `unresize.sh`). |
| `ctrl-alt-minus` / `ctrl-alt-equal` | Plain smart-resize ±50px. |
| `alt-slash` | Toggle layout: tiles ↔ horizontal/vertical orientation. |
| `ctrl-alt-up` | Toggle "fullscreen" for focused window (with custom border script). |

### Apps (single-key launcher)

| Keys | What it does |
| --- | --- |
| `alt-g` | Open Chrome. |
| `alt-t` | Open iTerm (existing window). |
| `alt-shift-t` | Open iTerm in `~`. |
| `alt-m` | Open Spotify. |
| `alt-v` | Open WhatsApp. |
| `alt-s` | Open Slack. |
| `alt-y` | Open YouTube. |
| `alt-f` | Open Finder. |

### Service mode (`alt-shift-;` then a key)

| Keys (after `alt-shift-;`) | What it does |
| --- | --- |
| `esc` | Reload config and exit service mode. |
| `r` | Flatten the workspace tree (reset layout). |
| `f` | Toggle focused window between floating and tiling. |
| `shift-f` | Toggle fullscreen-with-borders. |
| `backspace` | Close every window in the workspace EXCEPT the focused one. |
| `alt-shift-b` | Re-sync borders (jankyborders/sketchybar refresh). |

### Other

| Keys | What it does |
| --- | --- |
| `alt-shift-s` | Screenshot — interactive selection, copies to clipboard. |
| `alt-shift-g` | Enter "join" mode: next `h/j/k/l` joins focused window into the neighbor in that direction. |

## Gotchas / tips

- **macOS still owns full-screen apps.** Apps that go true-fullscreen (Cmd-Ctrl-F) leave the tiling system. Use `ctrl-alt-up` (Aerospace fullscreen) instead — it stays inside the workspace.
- **Some apps misbehave** (Slack huddles, video calls, dialogs). The config currently has no `[[on-window-detected]]` rules; consider adding them later for apps you want to always float (System Settings, 1Password, calculator). See the bottom of `aerospace.toml` for where they go.
- **Workspace numbers are global**, not per-monitor. Workspace 1 is the same workspace whether you focus it from the laptop or the external. Use the letter workspaces (`a..f`) for monitor-specific stuff if you wire them up.
- **After editing `aerospace.toml`**, reload via service mode: `alt-shift-;` then `esc`. The `esc` binding is `reload-config`. No restart needed.
- **Service-mode prefix**: this repo uses `alt-shift-;` (semicolon). Some i3 muscle memory wants `mod+r`; you don't have that here. Re-bind in `aerospace.toml` if you care.

## Try it now

```bash
# 1. Make sure Aerospace is running and Accessibility is granted
open -a AeroSpace

# 2. Open a few apps to give yourself something to tile
open -a 'Google Chrome'
open -a iTerm
open -a Slack

# 3. Practice the core moves:
#    - alt-1 → workspace 1.
#    - alt-shift-2: send focused window to workspace 2 and follow it.
#    - alt-h / alt-j / alt-k / alt-l: change focus.
#    - alt-shift-h / -j / -k / -l: move the focused window inside the layout.
#    - alt-tab: jump back and forth between two workspaces.

# 4. Edit the config and reload
$EDITOR ~/dotfiles/aerospace/.config/aerospace/aerospace.toml
# Press alt-shift-;  then  esc   → reload-config

# 5. Try service mode
#    alt-shift-;  → status bar shows "service" mode
#    r  → flatten layout
#    backspace  → keep only focused window in the workspace
#    esc        → exit service mode
```

## Further reading

- [Aerospace guide](https://nikitabobko.github.io/AeroSpace/guide) — the official tour.
- [Aerospace commands reference](https://nikitabobko.github.io/AeroSpace/commands) — every command you can bind.
