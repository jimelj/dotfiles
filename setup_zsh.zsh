#!/usr/bin/env zsh
# =============================================================================
# ZSH setup: register Homebrew zsh and make it the login shell
# =============================================================================

# Shared helpers (guarantees brew is on PATH).
source "${0:A:h}/lib.zsh"

echo "\n<<< Starting ZSH Setup >>>\n"

# zsh itself is installed by the core Brewfile.

# Register Homebrew's zsh in /etc/shells so chsh will accept it.
# https://stackoverflow.com/a/4749368/1341838
if grep -Fxq '/opt/homebrew/bin/zsh' '/etc/shells'; then
  echo '/opt/homebrew/bin/zsh already exists in /etc/shells'
else
  echo "Enter superuser (sudo) password to edit /etc/shells"
  echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi

# Make Homebrew's zsh the login shell.
if [ "$SHELL" = '/opt/homebrew/bin/zsh' ]; then
  echo '$SHELL is already /opt/homebrew/bin/zsh'
else
  echo "Enter user password to change login shell"
  chsh -s '/opt/homebrew/bin/zsh'
fi
