#!/usr/bin/env zsh
# =============================================================================
# ZSH Environment Configuration (.zshenv)
# =============================================================================
# This file is loaded by ALL ZSH sessions (interactive and non-interactive)
# It should contain environment variables and PATH configurations that need
# to be available system-wide, including in scripts and automation.

# =============================================================================
# DEBUGGING (Remove in production)
# =============================================================================
# Uncomment the line below to see when .zshenv loads
# echo 'Hello from .zshenv'

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================
# These variables should be available in all ZSH sessions

# Set default pager to bat (enhanced cat command)
# This makes bat the default for programs that need to display text
export NULLCMD=bat

# Node.js version management with 'n' tool
# These tell the 'n' tool where to install Node.js versions
export N_PREFIX="$HOME/.n"     # Directory where 'n' installs Node versions
export PREFIX="$N_PREFIX"      # Alternative variable some tools use

# Starship prompt configuration
# Tells Starship where to find its configuration file
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# Carapace completion engine configuration
# Enables better completions for various shells and tools
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'

# =============================================================================
# PATH CONFIGURATION
# =============================================================================
# The PATH variable tells the shell where to look for executable programs
# This should be in .zshenv so scripts and automation can access these paths

# Use typeset -U to make path array unique (no duplicates)
# This prevents the same directory from being added to PATH multiple times
typeset -U path

# Define the PATH in order of priority (first directories are checked first)
path=(
  "$N_PREFIX/bin"  # Node.js binaries from 'n' tool (highest priority)
  $path            # Existing PATH directories (preserves system paths)
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"  # VS Code CLI
)

# =============================================================================
# HELPER FUNCTIONS
# =============================================================================
# Functions that should be available in all ZSH sessions (including scripts)

# Check if a command exists
# Usage: exists command_name
function exists() {
  # `command -v` is similar to `which`
  # http://stackoverflow.com/a/677212/1341838
  command -v $1 >/dev/null 2>&1
}

# Show all directories in PATH (useful for debugging)
function show_path() {
  echo "PATH directories:"
  echo ${(F)path}
}

# =============================================================================
# COMPLETION SYSTEM SETUP
# =============================================================================
# Set up completion system for all ZSH sessions

# Add Homebrew completions to FPATH
# Hardcoded path for Apple Silicon (avoids slow `brew --prefix` call ~30-50ms)
if [[ -d "/opt/homebrew/share/zsh/site-functions" ]]; then
  FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
elif [[ -d "/usr/local/share/zsh/site-functions" ]]; then
  # Intel Mac fallback
  FPATH="/usr/local/share/zsh/site-functions:${FPATH}"
fi

# =============================================================================
# END OF ENVIRONMENT CONFIGURATION
# =============================================================================