# mas

**The Mac App Store, from the command line.**

`mas` lets you list, install, and update apps from the Mac App Store from a terminal. Most useful application: making your `Brewfile` capture the App Store apps you've installed (Xcode, Slack-from-MAS, etc.), so a fresh-Mac bootstrap installs them automatically.

This matters mostly when **setting up a new Mac** — once you have your apps, you'll rarely run `mas` interactively. But the IDs in your Brewfile won't fill themselves in.

## Why you'll like it

- One command (`brew bundle install`) brings up CLI tools, casks, AND App Store apps. No "now go open the App Store and click Get on these 8 things."
- `mas list` gives you the app IDs you need to add to a `Brewfile`.
- `mas upgrade` runs all available App Store updates without opening the App Store app.

## Install

If installed via the dotfiles Brewfile, no action. Otherwise: `brew install mas`.

You **must** be signed in to the Mac App Store first (it's an Apple-ID-bound thing — `mas` can no longer sign in for you). Open the App Store app once, sign in, then `mas` will work.

## The 80% you'll actually use

| Command | What it does |
| --- | --- |
| `mas list` | Apps installed from the Mac App Store, with their IDs. **The command you want when filling out a Brewfile.** |
| `mas search <name>` | Find an app's ID. e.g. `mas search xcode`. |
| `mas info <id>` | Details for a specific app. |
| `mas install <id>` | Install (must be signed in; app must be free or already purchased on this Apple ID). |
| `mas upgrade` | Install all pending App Store updates. |
| `mas outdated` | List apps with available updates. |
| `mas account` | Show the signed-in Apple ID. |

## Gotchas / tips

- **Apple ID required.** `mas install` for paid apps only works if the same Apple ID has previously purchased them on any Mac.
- New macOS releases sometimes break `mas` for a few weeks until the maintainers catch up. If `mas list` returns garbage, `brew upgrade mas`.
- App IDs are stable but not guessable. Always copy them from `mas list` after first install rather than typing.
- `mas` cannot do "Get" prompts that need 2FA approvals — easiest to install manually once, then run `mas list` to capture the ID.

## The Brewfile workflow (the actual reason mas exists)

This repo's `Brewfile` already has:

```ruby
mas "Xcode", id: 497799835
# TODO: fill in MAS ids after first install. Run `mas list` and add:
# mas "Copilot for Xcode", id: ?
# mas "SwiftFormat for Xcode", id: ?
```

After you've installed your favorite App Store apps once on the new Mac:

```bash
mas list
# 1450874784 Transmit 5         (5.10.2)
# 497799835  Xcode               (15.4)
# 1487937127 Craft               (3.2.0)
# ...
```

Edit `~/dotfiles/Brewfile` and add lines like:

```ruby
mas "Transmit 5", id: 1450874784
```

Or regenerate the whole Brewfile:

```bash
brew bundle dump --describe --mas --force --file=~/dotfiles/Brewfile
```

Now `brew bundle install` on a fresh Mac will pull these too.

## Try it now

```bash
# Confirm sign-in
mas account

# What App Store apps do you currently have?
mas list

# Find Xcode's ID (it's 497799835)
mas search xcode | head

# Run pending App Store updates without opening App Store
mas outdated
mas upgrade

# Capture into Brewfile (review the diff before committing!)
brew bundle dump --describe --mas --force --file=~/dotfiles/Brewfile.new
diff ~/dotfiles/Brewfile ~/dotfiles/Brewfile.new
```

## Further reading

- [mas on GitHub](https://github.com/mas-cli/mas) — current feature list and macOS-version compatibility table.
