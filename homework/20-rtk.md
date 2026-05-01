# rtk (Rust Token Killer)

**A transparent token-compressor for AI coding agents.**

`rtk` sits between an AI agent (Claude Code, opencode, Cursor's CLI bridge) and its model API. It compresses repetitive context — large file reads, long shell outputs, structured tool results — so the model sees fewer tokens for the same information. Net effect: faster turns, lower cost, and longer effective context windows. After setup it is invisible. You don't change how you prompt; you don't run `rtk` directly during normal use.

This dotfiles setup wires it up automatically: `install.sh` runs `rtk telemetry disable && rtk init -g --opencode` once.

This is mostly relevant on the **new Mac**. On a working machine where opencode/Claude already hit the model directly, you only notice rtk via faster responses and the occasional log.

## Why you'll like it

- Drops cost meaningfully on long sessions (especially ones that read lots of source files).
- Zero workflow change — same `opencode` / `claude` commands, same prompts.
- Configures globally so it works for every agent project, not per-repo.
- `rtk telemetry disable` opts out of analytics by default in the dotfiles install.

## Install

If installed via the dotfiles Brewfile and `install.sh` ran successfully, no action. The relevant lines in `install.sh`:

```bash
rtk telemetry disable
rtk init -g --opencode
```

Otherwise:

```bash
brew install anomalyco/tap/rtk
rtk telemetry disable
rtk init -g --opencode    # `-g` = global; `--opencode` = wire opencode plugin
```

## The 80% you'll actually use

Most of the time: **nothing**. Set it once, forget it.

| Command | What it does |
| --- | --- |
| `rtk init -g --opencode` | One-time global setup. Idempotent. |
| `rtk status` | Verify rtk is installed and active. |
| `rtk telemetry disable` | Opt out of telemetry (already done by `install.sh`). |
| `rtk telemetry status` | Confirm telemetry state. |
| `rtk --help` | Subcommand reference. |
| `rtk --version` | What's installed. |

## How to verify it's working

1. **Confirm the binary is on PATH:**
   ```bash
   which rtk
   rtk --version
   ```
2. **Confirm opencode integration:**
   ```bash
   ls ~/.config/opencode      # plugin/config files should be present
   ```
3. **Run an agent and watch.** With opencode or Claude Code in a real project, observe in token counts / latency that responses come back quickly. There's no "rtk loading..." banner — invisible-by-design.

## Gotchas / tips

- **It's a one-time setup tool.** You don't keep running `rtk init`. The dotfiles `install.sh` calls it once; rerunning `install.sh` is safe but a no-op.
- If you uninstall opencode, `rtk init -g --opencode` may be a no-op or warn. Re-run after re-installing the agent.
- Compression is opportunistic — small prompts won't see savings, large ones will. Don't be surprised if a 5k-token chat looks the same with and without rtk.
- This is third-party tooling for a third-party-API workflow. If you ever stop using AI agents, you can `brew uninstall rtk` and lose nothing.

## Try it now

```bash
# Confirm everything is in place
which rtk
rtk --version
rtk telemetry status         # should report "disabled"

# Re-run init (idempotent — safe to confirm setup)
rtk init -g --opencode

# See available subcommands
rtk --help
```

## Further reading

- [rtk on GitHub](https://github.com/anomalyco/rtk) — see the README for the latest feature list and supported agents.
