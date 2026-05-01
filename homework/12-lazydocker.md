# lazydocker

**A keyboard-driven TUI for Docker (and Podman).**

`lazydocker` is a terminal interface for managing containers, images, volumes, and logs. It replaces a lot of `docker ps`, `docker logs`, `docker stats`, `docker exec -it` invocations with arrow keys and one-letter actions in a single screen. You see all your containers, click into one, watch its logs stream live, exec a shell — all without leaving the terminal.

This dotfiles setup uses **podman** as the container engine, with a `docker → podman` shim under `~/dotfiles/shims/`. `lazydocker` calls the `docker` binary, so it transparently works against your podman containers.

## Why you'll like it

- One screen for: containers, services, images, volumes, networks. Arrow keys to navigate.
- Live logs without `docker logs -f --tail 100 <id>`. Just hover and read.
- Exec into a container with `E`. No pasting container IDs.
- Stats (CPU/RAM) update in-place. Replaces `docker stats`.
- `Ctrl-c` cleanly removes/stops/restarts; `?` shows all keybindings inline.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install lazydocker`.

For podman: ensure `podman machine` is running:

```bash
podman machine init     # one-time
podman machine start    # each boot (or set up a launchctl)
```

The shim at `~/.local/bin/docker` forwards to podman; `lazydocker` will pick that up via your `$PATH`.

## The 80% you'll actually use

Inside lazydocker (after launching with `lazydocker`):

| Key | What it does |
| --- | --- |
| `Tab` / arrow keys | Move between panes (Containers, Images, Volumes, ...). |
| `↑` / `↓` | Move within a pane. |
| `Enter` | Open the focused item; show its details/logs/etc. |
| `?` | Show all keybindings for the current context. |
| `d` | Remove the focused item (with confirmation). |
| `s` | Stop a running container. |
| `r` | Restart. |
| `R` | Remove (force). |
| `E` | Exec a shell into the focused container. |
| `+` / `-` | Increase/decrease log scroll speed. |
| `/` | Filter the list. |
| `q` or `Esc` | Back out / quit. |

## Gotchas / tips

- If `lazydocker` shows no containers but you know there are some, your `docker` binary may be talking to a stopped engine. Check `docker info` (or `podman machine list`).
- It writes a small config to `~/Library/Application Support/jesseduffield/lazydocker/config.yml`. Most people never touch it.
- Logs auto-tail by default, which is usually what you want. Stop tailing with `Ctrl-c` inside the logs pane to scroll back.
- For multi-engine Mac users: the env var `DOCKER_HOST` controls which engine `docker`/`lazydocker` connects to. The shim handles this for you here.

## Try it now

```bash
# Start podman if you haven't (one time per boot)
podman machine list
podman machine start || true

# Spin up a throwaway container so you have something to look at
docker run -d --name hello-nginx -p 8080:80 nginx
docker run -d --name hello-redis redis

# Open lazydocker
lazydocker

# Inside: arrow to hello-nginx, press Enter for logs, press E for a shell.
# Then `q` out, press `d` on each container to remove them.
```

## Further reading

- [lazydocker on GitHub](https://github.com/jesseduffield/lazydocker) — full keybindings + screenshots.
