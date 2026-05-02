#!/usr/bin/env bash
#
# One-shot revert of macOS preferences that the previous (broader)
# macos-defaults.sh applied — restores dock layout, gestures, scroll
# direction, etc. to macOS defaults.
#
# Run once on the new Mac after a bootstrap that picked up Anatoli's
# original preferences. Idempotent — re-runs are no-ops.
#
# This script is temporary; the manager will remove it from the repo
# after confirming it ran.
#
set -euo pipefail

echo "Restoring macOS defaults that were overridden by the prior macos-defaults.sh..."

# --- Dock: back to bottom, no auto-hide, normal sizes -----------------------
defaults delete com.apple.dock autohide 2>/dev/null || true
defaults delete com.apple.dock autohide-delay 2>/dev/null || true
defaults delete com.apple.dock orientation 2>/dev/null || true
defaults delete com.apple.dock magnification 2>/dev/null || true
defaults delete com.apple.dock tilesize 2>/dev/null || true
defaults delete com.apple.dock largesize 2>/dev/null || true
defaults delete com.apple.dock minimize-to-application 2>/dev/null || true
defaults delete com.apple.dock mru-spaces 2>/dev/null || true
defaults delete com.apple.dock expose-group-apps 2>/dev/null || true
defaults delete com.apple.dock showAppExposeGestureEnabled 2>/dev/null || true
defaults delete com.apple.dock showDesktopGestureEnabled 2>/dev/null || true
defaults delete com.apple.dock showLaunchpadGestureEnabled 2>/dev/null || true
defaults delete com.apple.dock showMissionControlGestureEnabled 2>/dev/null || true
defaults delete com.apple.dock enterMissionControlByTopWindowDrag 2>/dev/null || true

# --- Hot corners: clear all four to default no-op ---------------------------
for c in tl tr bl br; do
  defaults delete com.apple.dock "wvous-${c}-corner" 2>/dev/null || true
  defaults delete com.apple.dock "wvous-${c}-modifier" 2>/dev/null || true
done

# --- Multi-finger trackpad gestures (3/4/5-finger H/V/Pinch) ---------------
for ns in com.apple.AppleMultitouchTrackpad com.apple.driver.AppleBluetoothMultitouch.trackpad; do
  for k in TrackpadFourFingerHorizSwipeGesture TrackpadFourFingerVertSwipeGesture \
           TrackpadFourFingerPinchGesture TrackpadFiveFingerPinchGesture \
           TrackpadThreeFingerHorizSwipeGesture TrackpadThreeFingerVertSwipeGesture; do
    defaults delete "$ns" "$k" 2>/dev/null || true
  done
done

# --- General UX: scroll direction, force click, cursor shake, animations ---
defaults delete NSGlobalDomain com.apple.swipescrolldirection 2>/dev/null || true
defaults delete NSGlobalDomain com.apple.trackpad.forceClick 2>/dev/null || true
defaults delete NSGlobalDomain CGDisableCursorLocationMagnification 2>/dev/null || true
defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null || true
defaults delete NSGlobalDomain NSWindowShouldDragOnGesture 2>/dev/null || true
defaults delete NSGlobalDomain AppleActionOnDoubleClick 2>/dev/null || true
defaults delete NSGlobalDomain AppleMiniaturizeOnDoubleClick 2>/dev/null || true

# --- Cmd+M minimize (was remapped to null) ---------------------------------
defaults delete -g NSUserKeyEquivalents 2>/dev/null || true

# --- Reduce-motion / transparency ------------------------------------------
defaults delete com.apple.universalaccess reduceMotion 2>/dev/null || true
defaults delete com.apple.universalaccess reduceTransparency 2>/dev/null || true

# --- WindowManager hide-desktop --------------------------------------------
defaults delete com.apple.WindowManager HideDesktop 2>/dev/null || true

# --- Apply -----------------------------------------------------------------
echo "Restarting affected apps..."
killall Dock Finder SystemUIServer cfprefsd 2>/dev/null || true

echo "Done. Dock should be back at the bottom and gestures should work."
echo "(Note: the new minimal macos-defaults.sh in this repo will not re-apply Anatoli's preferences on subsequent install.sh runs.)"
