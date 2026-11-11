#!/bin/bash
# macOS preferences, captured from the current Mac with `defaults read`.
# Only settings that had an explicit value are listed. Opt-in: run
# ./macos/defaults.sh on a new machine (not run by install.sh).
set -e

# --- Typing -----------------------------------------------------------------
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true   # double space types "."

# --- Trackpad and scrolling -------------------------------------------------
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true         # natural scrolling
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false           # tap to click off

# --- Dock and Spaces --------------------------------------------------------
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock tilesize -int 53
defaults write com.apple.dock mru-spaces -bool false                            # keep Spaces in a fixed order

# --- Finder -----------------------------------------------------------------
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"             # list view

# Apply
for app in Finder Dock; do
    killall "$app" >/dev/null 2>&1 || true
done
echo "Done. Some settings (typing, trackpad) apply after logging out and back in."
