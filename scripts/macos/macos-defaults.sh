#!/usr/bin/env bash
#
# macOS defaults — captured from the host's current state.
# Regenerate with:
#   ./scripts/macos/capture-defaults.sh > scripts/macos/macos-defaults.sh
#
set -euo pipefail

osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

echo "Configuring macOS defaults..."

# === Keyboard & input ===
# Hold-key repeats instead of opening accent menu (baseline — always emitted)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain AppleKeyboardUIMode -int 0
# Auto-correct / smart-quotes / smart-dashes / auto-cap all OFF (annoying in code)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain WebAutomaticSpellingCorrectionEnabled -bool false

# === Trackpad ===
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFiveFingerPinchGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 2

# === UI & Windows ===
# NSGlobalDomain NSAutomaticWindowAnimationsEnabled: unset
# NSGlobalDomain NSWindowShouldDragOnGesture: unset
defaults write NSGlobalDomain AppleWindowTabbingMode -string manual
# NSGlobalDomain AppleActionOnDoubleClick: unset
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false
# NSGlobalDomain CGDisableCursorLocationMagnification: unset

# === Dock ===
defaults write com.apple.dock autohide -bool true
# com.apple.dock autohide-delay: unset
# com.apple.dock orientation: unset
# com.apple.dock tilesize: unset
defaults write com.apple.dock largesize -int 128
# com.apple.dock magnification: unset
# com.apple.dock minimize-to-application: unset
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock expose-group-apps -bool false
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
# com.apple.dock showDesktopGestureEnabled: unset
# com.apple.dock showLaunchpadGestureEnabled: unset
# com.apple.dock showMissionControlGestureEnabled: unset
# com.apple.dock enterMissionControlByTopWindowDrag: unset

# === Hot corners ===
# com.apple.dock wvous-tl-corner: unset
# com.apple.dock wvous-tl-modifier: unset
# com.apple.dock wvous-tr-corner: unset
# com.apple.dock wvous-tr-modifier: unset
# com.apple.dock wvous-bl-corner: unset
# com.apple.dock wvous-bl-modifier: unset
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

# === Window Manager (Stage Manager + native tiling — Aerospace requirements) ===
# These are baseline requirements for Aerospace and are always set,
# regardless of host state at capture time.
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager HideDesktop -bool true

# === Finder ===
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Search the current folder by default, not the whole Mac
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Folders sort to the top, then files
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Don't litter network shares / USB drives with .DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# === Menu bar clock ===
defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock IsAnalog -bool false
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false

# === Screenshots ===
defaults write com.apple.screencapture target -string clipboard

# === Mos (mouse-only scroll customization) ===
# Mos affects mouse wheel only; trackpad keeps macOS's natural-scroll setting.
defaults write com.caldis.Mos reverse -bool true
defaults write com.caldis.Mos reverseHorizontal -bool true
defaults write com.caldis.Mos reverseVertical -bool true
defaults write com.caldis.Mos smooth -bool true
defaults write com.caldis.Mos smoothHorizontal -bool true
defaults write com.caldis.Mos smoothVertical -bool true
defaults write com.caldis.Mos smoothSimTrackpad -bool false
defaults write com.caldis.Mos speed -float 2.7
defaults write com.caldis.Mos step -float 33.6
defaults write com.caldis.Mos duration -float 2
defaults write com.caldis.Mos deadZone -float 1
defaults write com.caldis.Mos allowlist -bool false
defaults write com.caldis.Mos hideStatusItem -bool false
defaults write com.caldis.Mos updateCheckOnAppStart -bool false
defaults write com.caldis.Mos updateIncludingBetaVersion -bool false
# Hotkey-binding blobs (block/dash/toggle/applications/buttonBindings) are stored
# as embedded JSON and not captured here — leave them at Mos defaults.
# Register Mos as a login item (idempotent).
if [[ -d /Applications/Mos.app ]]; then
  if ! osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null | tr ',' '\n' | grep -qE '^[[:space:]]*Mos[[:space:]]*$'; then
    osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Mos.app", hidden:true}' >/dev/null 2>&1 || true
  fi
fi

# === Aerospace-required: disable Ctrl+1/2/3 Mission Control space-switching ===
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 120 '{ enabled = 0; }'

echo "Restarting affected applications..."
for app in Dock Finder SystemUIServer cfprefsd; do
  killall "$app" 2>/dev/null || true
done
echo "Done."
