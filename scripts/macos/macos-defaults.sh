#!/usr/bin/env bash
#
# macOS defaults — minimal opinionated subset.
#
# Three categories of settings only:
#   1. Required by Aerospace (Stage Manager off, native tiling off,
#      Ctrl+1/2/3 Mission Control shortcuts off).
#   2. Dev-friendly keyboard (fast repeat, no auto-correct, etc.).
#   3. Universally good Finder + screenshot ergonomics.
#
# Does NOT touch: dock placement / auto-hide, gestures, scroll
# direction, hot corners, window animations, cursor behavior,
# Cmd+M minimize. If you want those, copy from Anatoli's:
#   https://github.com/anatoli-tsinovoy/dotfiles/blob/main/scripts/macos/macos-defaults.sh
#
set -euo pipefail

osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

echo "Configuring macOS defaults (minimal)..."

###############################################################################
# Keyboard & Input — dev-friendly                                             #
###############################################################################

# Disable press-and-hold for accents (so holding a key repeats it)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 35

# Tab through all UI elements
defaults write NSGlobalDomain AppleKeyboardUIMode -int 1

# Disable auto-correct, smart quotes, dashes, periods
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# Three-finger tap → look up (other multi-finger gestures left at macOS default)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 2

###############################################################################
# Required by Aerospace                                                       #
###############################################################################

# Stage Manager off
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Native tiling off (Aerospace owns tiling)
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false

# Disable Ctrl+1/2/3 Mission Control space-switching shortcuts
# (collide with terminal / IDE shortcuts)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 120 '{ enabled = 0; }'

###############################################################################
# Finder — universally useful                                                 #
###############################################################################

defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Screenshots                                                                 #
###############################################################################

# Save screenshots to file rather than clipboard
defaults write com.apple.screencapture target -string "file"

###############################################################################
# Apply                                                                       #
###############################################################################

echo "Restarting affected applications..."
for app in Dock Finder SystemUIServer cfprefsd; do
  killall "$app" 2>/dev/null || true
done

echo "Done."
