#!/usr/bin/env zsh

echo "\n<<< Starting macOS Setup >>>\n"

osascript -e 'tell application "System Preferences" to quit'

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true

# # Finder > Preferences > General > New Finder windows show:
# defaults write com.apple.finder NewWindowTarget -string 'PfLo'
# defaults write com.apple.finder NewWindowTargetPath -string "file://$HOME/.dotfiles"

# System Preferences > Dock
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 45
defaults write com.apple.dock largesize -int 60
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.25
defaults write com.apple.dock autohide-delay -float 0.1

# System Preferences > Accessibility > Pointer Control > Mouse & Trackpad > Trackpad Options > Enable Dragging > Three Finger Drag (NOTE: The GUI doesn't update)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false

# Mouse trackpad
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write -g com.apple.swipescrolldirection -boolean NO
# Trackpad: map bottom right corner to right-click
# defaults write com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults write com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick 1

#Desktop 
defaults write com.apple.finder CreateDesktop false

# Finish macOS Setup
killall Finder
killall Dock
echo "\n<<< macOS Setup Complete.
    A logout or restart might be necessary. >>>\n"
