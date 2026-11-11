#!/bin/bash
# macOS preferences. Opt-in: review and edit, then run ./macos/defaults.sh.
# Not run by install.sh. Some changes need a logout to take full effect.
set -e

# --- Keyboard ---------------------------------------------------------------
# Fastest key repeat that System Settings allows (lower = faster)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Hold a key to repeat it instead of showing the accent picker
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# --- Finder -----------------------------------------------------------------
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"   # list view
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# No .DS_Store files on network shares and USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# --- Dialogs ----------------------------------------------------------------
# Expanded save dialog by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# --- Dock -------------------------------------------------------------------
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

# Apply
for app in Finder Dock; do
    killall "$app" >/dev/null 2>&1 || true
done
echo "Done. Log out and back in for keyboard changes to apply everywhere."
