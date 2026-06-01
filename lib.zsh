#!/usr/bin/env zsh
# =============================================================================
# Shared helpers for the setup_*.zsh scripts
# =============================================================================
# Source this at the top of each setup script:  source "${0:A:h}/lib.zsh"
# It guarantees Homebrew is on PATH (even on the very first run, before a new
# login shell has picked up ~/.zprofile) and provides small prompt helpers.

# Make sure Homebrew is on PATH for THIS process. zshenv normally handles this,
# but sourcing here makes each setup script self-contained and order-independent.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"     # Apple Silicon
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"        # Intel Mac fallback
fi

# Check whether a command exists (mirrors the helper in zshenv, in case zshenv
# was not sourced for this shell).
if ! typeset -f exists >/dev/null 2>&1; then
  function exists() { command -v "$1" >/dev/null 2>&1 }
fi

# Ask a yes/no question. Defaults to "no" unless the user types y/Y.
# Returns 0 for yes, 1 for no. Non-interactive (no TTY) always returns "no".
function confirm() {
  local prompt="$1"
  if [[ ! -t 0 ]]; then
    echo "  (non-interactive: skipping '$prompt')"
    return 1
  fi
  local answer
  read "answer?$prompt [y/N] "
  [[ "$answer" == [yY] ]]
}
