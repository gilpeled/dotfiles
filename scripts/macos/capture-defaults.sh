#!/usr/bin/env bash
#
# capture-defaults.sh — read this Mac's current state for every relevant
# macOS preference and emit a complete `macos-defaults.sh` script that
# would recreate it on a fresh Mac.
#
# USAGE
#   1. Open System Settings, set things how you want them (dock, gestures,
#      scroll direction, hot corners, etc.).
#   2. Run:
#         ./scripts/macos/capture-defaults.sh > scripts/macos/macos-defaults.sh
#   3. `git diff` to review, then commit and push.
#
# Read-only — never writes preferences. Re-runnable.
#
set -euo pipefail

emit_bool() {
  local dom="$1" key="$2" v
  v=$(defaults read "$dom" "$key" 2>/dev/null) || { echo "# $dom $key: unset"; return 0; }
  case "$v" in
    0|false|FALSE|NO) echo "defaults write $dom $key -bool false" ;;
    1|true|TRUE|YES)  echo "defaults write $dom $key -bool true" ;;
    *) echo "# $dom $key = $v (unexpected, skipping)" ;;
  esac
}
emit_int() {
  local dom="$1" key="$2" v
  v=$(defaults read "$dom" "$key" 2>/dev/null) || { echo "# $dom $key: unset"; return 0; }
  echo "defaults write $dom $key -int $v"
}
emit_float() {
  local dom="$1" key="$2" v
  v=$(defaults read "$dom" "$key" 2>/dev/null) || { echo "# $dom $key: unset"; return 0; }
  echo "defaults write $dom $key -float $v"
}
emit_string() {
  local dom="$1" key="$2" v
  v=$(defaults read "$dom" "$key" 2>/dev/null) || { echo "# $dom $key: unset"; return 0; }
  printf 'defaults write %s %s -string %q\n' "$dom" "$key" "$v"
}

cat <<'HEADER'
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
HEADER

echo
echo "# === Keyboard & input ==="
emit_bool   NSGlobalDomain ApplePressAndHoldEnabled
emit_int    NSGlobalDomain KeyRepeat
emit_int    NSGlobalDomain InitialKeyRepeat
emit_int    NSGlobalDomain AppleKeyboardUIMode
emit_bool   NSGlobalDomain NSAutomaticCapitalizationEnabled
emit_bool   NSGlobalDomain NSAutomaticDashSubstitutionEnabled
emit_bool   NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled
emit_bool   NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled
emit_bool   NSGlobalDomain NSAutomaticSpellingCorrectionEnabled
emit_bool   NSGlobalDomain WebAutomaticSpellingCorrectionEnabled

echo
echo "# === Trackpad ==="
emit_bool   NSGlobalDomain com.apple.swipescrolldirection
emit_bool   NSGlobalDomain com.apple.trackpad.forceClick
for ns in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  emit_int  "$ns" TrackpadThreeFingerTapGesture
  emit_int  "$ns" TrackpadFourFingerHorizSwipeGesture
  emit_int  "$ns" TrackpadFourFingerVertSwipeGesture
  emit_int  "$ns" TrackpadFourFingerPinchGesture
  emit_int  "$ns" TrackpadFiveFingerPinchGesture
  emit_int  "$ns" TrackpadThreeFingerHorizSwipeGesture
  emit_int  "$ns" TrackpadThreeFingerVertSwipeGesture
done

echo
echo "# === UI & Windows ==="
emit_bool   NSGlobalDomain NSAutomaticWindowAnimationsEnabled
emit_bool   NSGlobalDomain NSWindowShouldDragOnGesture
emit_string NSGlobalDomain AppleWindowTabbingMode
emit_string NSGlobalDomain AppleActionOnDoubleClick
emit_bool   NSGlobalDomain AppleMiniaturizeOnDoubleClick
emit_bool   NSGlobalDomain CGDisableCursorLocationMagnification

echo
echo "# === Dock ==="
emit_bool   com.apple.dock autohide
emit_float  com.apple.dock autohide-delay
emit_string com.apple.dock orientation
emit_int    com.apple.dock tilesize
emit_int    com.apple.dock largesize
emit_bool   com.apple.dock magnification
emit_bool   com.apple.dock minimize-to-application
emit_bool   com.apple.dock mru-spaces
emit_bool   com.apple.dock show-recents
emit_bool   com.apple.dock expose-group-apps
emit_bool   com.apple.dock showAppExposeGestureEnabled
emit_bool   com.apple.dock showDesktopGestureEnabled
emit_bool   com.apple.dock showLaunchpadGestureEnabled
emit_bool   com.apple.dock showMissionControlGestureEnabled
emit_bool   com.apple.dock enterMissionControlByTopWindowDrag

echo
echo "# === Hot corners ==="
for c in tl tr bl br; do
  emit_int  com.apple.dock "wvous-${c}-corner"
  emit_int  com.apple.dock "wvous-${c}-modifier"
done

echo
echo "# === Window Manager (Stage Manager + native tiling — Aerospace requirements) ==="
emit_bool   com.apple.WindowManager GloballyEnabled
emit_bool   com.apple.WindowManager EnableStandardClickToShowDesktop
emit_bool   com.apple.WindowManager EnableTiledWindowMargins
emit_bool   com.apple.WindowManager EnableTilingByEdgeDrag
emit_bool   com.apple.WindowManager EnableTilingOptionAccelerator
emit_bool   com.apple.WindowManager EnableTopTilingByEdgeDrag
emit_bool   com.apple.WindowManager HideDesktop

echo
echo "# === Finder ==="
emit_bool   com.apple.finder ShowPathbar
emit_bool   com.apple.finder ShowStatusBar
emit_string com.apple.finder FXDefaultSearchScope
emit_bool   com.apple.finder FXEnableExtensionChangeWarning
emit_bool   com.apple.finder _FXShowPosixPathInTitle
emit_bool   com.apple.finder _FXSortFoldersFirst
emit_bool   com.apple.desktopservices DSDontWriteNetworkStores
emit_bool   com.apple.desktopservices DSDontWriteUSBStores

echo
echo "# === Menu bar clock ==="
emit_bool   com.apple.menuextra.clock Show24Hour
emit_int    com.apple.menuextra.clock ShowDate
emit_bool   com.apple.menuextra.clock ShowDayOfWeek
emit_bool   com.apple.menuextra.clock IsAnalog
emit_bool   com.apple.menuextra.clock FlashDateSeparators

echo
echo "# === Screenshots ==="
emit_string com.apple.screencapture target

echo
echo "# === Aerospace-required: disable Ctrl+1/2/3 Mission Control space-switching ==="
echo "defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 '{ enabled = 0; }'"
echo "defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 '{ enabled = 0; }'"
echo "defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 120 '{ enabled = 0; }'"

echo
cat <<'FOOTER'
echo "Restarting affected applications..."
for app in Dock Finder SystemUIServer cfprefsd; do
  killall "$app" 2>/dev/null || true
done
echo "Done."
FOOTER
