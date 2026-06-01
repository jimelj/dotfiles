#!/usr/bin/env zsh
# =============================================================================
# ZSH setup: register Homebrew zsh and make it the login shell
# =============================================================================

# Shared helpers (guarantees brew is on PATH).
source "${0:A:h}/lib.zsh"

echo "\n<<< Starting ZSH Setup >>>\n"

# zsh itself is installed by the core Brewfile.

# Path to Homebrew's zsh. lib.zsh already put brew on PATH and set
# HOMEBREW_PREFIX, so this resolves to /opt/homebrew on Apple Silicon and
# /usr/local on Intel. Fall back to the Apple Silicon location if unset.
BREW_ZSH="${HOMEBREW_PREFIX:-/opt/homebrew}/bin/zsh"

# GUARD: never point the login shell at a binary that isn't there. Running
# chsh against a missing zsh makes Terminal fail to launch any shell
# ("login: .../zsh: No such file or directory") and locks you out. If Homebrew's
# zsh isn't installed yet, skip this step instead of bricking the shell.
if [[ ! -x "$BREW_ZSH" ]]; then
  echo "Homebrew zsh not found at $BREW_ZSH - skipping login-shell setup."
  echo "  Install it first (it's in the Brewfile; run ./install), then re-run this."
  exit 0
fi

# Register Homebrew's zsh in /etc/shells so chsh will accept it.
# https://stackoverflow.com/a/4749368/1341838
if grep -Fxq "$BREW_ZSH" '/etc/shells'; then
  echo "$BREW_ZSH already exists in /etc/shells"
else
  echo "Enter superuser (sudo) password to edit /etc/shells"
  echo "$BREW_ZSH" | sudo tee -a '/etc/shells' >/dev/null
fi

# Make Homebrew's zsh the login shell.
if [ "$SHELL" = "$BREW_ZSH" ]; then
  echo "\$SHELL is already $BREW_ZSH"
else
  echo "Enter user password to change login shell"
  chsh -s "$BREW_ZSH"
fi
