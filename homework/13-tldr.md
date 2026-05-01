# tldr

**Examples-first man pages.**

`man tar` is a wall of text that explains every flag in alphabetical order. `tldr tar` shows you the five things people actually do with `tar`, with example commands you can copy. It's the page you wished `man` was.

This repo installs `tlrc` (a Rust client for the TLDR pages corpus) and exposes it as `tldr`.

## Why you'll like it

- Every page is the same shape: one-line description, then 5–10 example commands. You're done in 30 seconds.
- Crowd-sourced examples cover real workflows, not edge cases.
- Works offline after the first `tldr --update`.
- Pages exist for git subcommands too: `tldr git rebase`, `tldr git bisect`.

## Install

If installed via the dotfiles Brewfile, no action — `tlrc` is the package, `tldr` is the binary.

Otherwise:

```bash
brew install tlrc
tldr --update
```

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `tldr tar` | Examples for `tar`. |
| `tldr git rebase` | Examples for `git rebase`. (Subcommand pages exist for git/docker/kubectl/etc.) |
| `tldr --update` | Refresh the local cache. Run occasionally. |
| `tldr --list` | List every available page. Useful when you forget a tool's name. |
| `tldr -p osx tar` | Force the macOS-flavored page if there are platform variants. |

That's basically it. `tldr` is a one-trick tool and the trick is a great trick.

## Gotchas / tips

- It's not a replacement for `man` when you genuinely need flag-by-flag detail (`man rsync` if you really need to know what `--inplace --partial --append-verify` interact like). It IS a replacement for "I don't remember the ssh tunnel flag" or "what's the right `find -exec` syntax."
- First run downloads ~3MB of pages. If you're behind a VPN/firewall and it fails, retry without the VPN.
- Pages are versioned per-platform. Specify `-p osx` or `-p common` if a tool's defaults differ from Linux.
- New tools (rare ones, just-released ones) may not have pages yet — fall back to `--help` or `man`.

## Try it now

```bash
# The classic test
tldr tar
tldr find
tldr ssh

# Git subcommand pages
tldr git rebase
tldr git bisect
tldr git worktree

# Tools you've just installed
tldr fd
tldr rg
tldr fzf

# Refresh cache
tldr --update
```

## Further reading

- [tldr-pages project](https://tldr.sh/) — browse all pages online, contribute new ones.
- [tlrc client](https://github.com/tldr-pages/tlrc) — the Rust client this repo uses.
