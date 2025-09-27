#!/usr/bin/env zsh
# =============================================================================
# ZSH Configuration - Enhanced and Optimized
# =============================================================================
# This file configures your ZSH shell with performance optimizations,
# useful options, aliases, functions, and integrations with external tools.
# The configuration is organized into logical sections for easy maintenance.

# =============================================================================
# PERFORMANCE OPTIMIZATION
# =============================================================================
# This section optimizes shell startup time and completion performance

# Enable completion caching for faster startup
# This is the ZSH completion system - it handles tab completion for commands
autoload -Uz compinit

# Smart completion caching:
# - If completion cache is older than 24 hours, regenerate it (slower but fresh)
# - Otherwise, use cached completions (much faster startup)
# This prevents slow startup while keeping completions up-to-date
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit  # Regenerate cache (slower but fresh)
else
  compinit -C  # Use cached completions (faster)
fi

# =============================================================================
# ZSH OPTIONS - CORE SHELL BEHAVIOR
# =============================================================================
# These options control how ZSH behaves. Each setopt enables a feature.

# HISTORY CONFIGURATION
# Controls how command history is stored and managed
HISTSIZE=10000        # Maximum number of commands to keep in memory
SAVEHIST=10000        # Maximum number of commands to save to history file
HISTFILE=~/.zsh_history  # File where history is stored

# History behavior options:
setopt SHARE_HISTORY          # Share history between all open terminal sessions
                              # (commands from one terminal appear in another)
setopt HIST_EXPIRE_DUPS_FIRST # When history gets full, delete duplicates first
setopt HIST_IGNORE_DUPS       # Don't save the same command twice in a row
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate when saving new duplicate
setopt HIST_FIND_NO_DUPS      # When searching history, don't show duplicates
setopt HIST_SAVE_NO_DUPS      # Don't write duplicate commands to history file
setopt HIST_REDUCE_BLANKS     # Remove extra spaces before saving commands
setopt HIST_VERIFY            # Show expanded history command before running it
                              # (useful for commands like !! or !$)

# NAVIGATION OPTIONS
# Controls how directory navigation works
setopt AUTO_CD                # Type a directory name and press Enter to cd into it
                              # (e.g., typing "Documents" will cd to Documents/)
setopt AUTO_PUSHD             # Every time you cd, push the old directory onto stack
                              # (allows you to use 'popd' to go back)
setopt PUSHD_IGNORE_DUPS      # Don't push the same directory multiple times
setopt PUSHD_SILENT          # Don't print directory stack after pushd/popd
setopt CDABLE_VARS            # Allow 'cd $VARIABLE' where VARIABLE contains a path
                              # (e.g., if you set MYDIR="/Users/me", you can 'cd $MYDIR')

# COMPLETION OPTIONS
# Controls how tab completion works
setopt ALWAYS_TO_END          # After completing, move cursor to end of word
setopt AUTO_LIST              # Show completion options when ambiguous
setopt AUTO_MENU              # Show menu of options when you press tab multiple times
setopt COMPLETE_IN_WORD       # Allow completion in the middle of words
setopt GLOB_COMPLETE          # Don't expand globs (*) during completion

# OTHER USEFUL OPTIONS
setopt CORRECT                # Try to correct spelling of commands
                              # (e.g., if you type 'sl' it might suggest 'ls')
setopt CORRECT_ALL            # Try to correct spelling of all arguments too
setopt NO_CASE_GLOB           # Make filename matching case-insensitive
                              # (e.g., 'ls *.TXT' will match 'file.txt')
setopt NUMERIC_GLOB_SORT      # Sort numbered files numerically (file1, file2, file10)
setopt EXTENDED_GLOB           # Enable advanced pattern matching
                              # (allows patterns like file<1-10>.txt)

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================
# These set up variables that programs can use

# Set default pager to bat (your enhanced cat command)
# When programs need to display text, they'll use bat instead of less/more
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
# ALIASES - SHORTCUTS FOR COMMANDS
# =============================================================================
# Aliases let you create shortcuts for longer commands

# FILE OPERATION ALIASES
alias ls='eza -lahF --git'    # Enhanced ls with git info, human-readable sizes
alias ll='eza -lahF --git'    # Same as ls (common alternative)
alias la='eza -lahF --git'    # Same as ls (another common alternative)
alias lt='eza --tree --level=2'        # Show directory tree (2 levels deep)
alias lta='eza --tree --level=2 -a'   # Show directory tree including hidden files
alias man='batman'            # Use bat for manual pages (better formatting)
alias rm='trash'              # Use trash instead of rm (safer deletion)
alias cp='cp -i'              # Ask before overwriting files
alias mv='mv -i'              # Ask before overwriting files

# NAVIGATION ALIASES
alias ..='cd ..'              # Go up one directory
alias ...='cd ../..'          # Go up two directories
alias ....='cd ../../..'      # Go up three directories
alias .....='cd ../../../..' # Go up four directories
alias tmp='cd /private/tmp'   # Quick access to temp directory

# DEVELOPMENT ALIASES
alias bbd='brew bundle dump --force --describe'  # Update Brewfile with current packages
alias trail='<<<${(F)path}'   # Show all directories in PATH (one per line)

# THEFUCK ALIASES - Command correction tool
# These create aliases for correcting typos in commands
eval $(thefuck --alias)       # Creates 'f' alias for thefuck
eval $(thefuck --alias fuck)  # Creates 'fuck' alias for thefuck
# Usage: Type a command with a typo, then type 'f' or 'fuck' to correct it

# =============================================================================
# FUNCTIONS - CUSTOM COMMANDS
# =============================================================================
# These are custom commands you can use

# Create directory and cd into it
# Usage: mkcd new_folder
mkcd() {
  mkdir -p "$@" && cd "$_"  # Create directory(ies) and cd to the last one
}

# Change directory and list contents
# Usage: cx Documents
cx() { 
  cd "$@" && ls  # Change directory and show contents
}

# Quick directory creation and navigation (alternative to mkcd)
# Usage: mcd new_folder
mcd() {
  mkdir -p "$1" && cd "$1"  # Create single directory and cd into it
}

# Extract various archive formats
# Usage: extract file.zip
extract() {
  if [ -f "$1" ] ; then  # Check if file exists
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;  # Extract tar.bz2 files
      *.tar.gz)    tar xzf "$1"     ;;  # Extract tar.gz files
      *.bz2)       bunzip2 "$1"     ;;  # Extract bz2 files
      *.rar)       unrar e "$1"     ;;  # Extract rar files
      *.gz)        gunzip "$1"      ;;  # Extract gz files
      *.tar)       tar xf "$1"      ;;  # Extract tar files
      *.tbz2)      tar xjf "$1"     ;;  # Extract tbz2 files
      *.tgz)       tar xzf "$1"     ;;  # Extract tgz files
      *.zip)       unzip "$1"       ;;  # Extract zip files
      *.Z)         uncompress "$1"  ;;  # Extract Z files
      *.7z)        7z x "$1"        ;;  # Extract 7z files
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find and kill process by name
# Usage: killp chrome (kills all Chrome processes)
killp() {
  ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
  # ps aux: list all processes
  # grep "$1": find processes matching the name
  # grep -v grep: exclude the grep command itself
  # awk '{print $2}': get the process ID (second column)
  # xargs kill -9: kill the processes with force
}

# =============================================================================
# COMPLETION SYSTEM - TAB COMPLETION ENHANCEMENTS
# =============================================================================
# These settings make tab completion better and more colorful

# Completion styling - makes completions look better
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'  # Gray text for completion messages
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # Use LS_COLORS for file colors
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'  # Smart matching
zstyle ':completion:*' menu select                         # Show menu for multiple options
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s  # Menu prompt
zstyle ':completion:*' use-compctl false                   # Use new completion system
zstyle ':completion:*' verbose true                        # Show descriptions for completions

# Case insensitive completion - you can type in any case
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# =============================================================================
# ADVANCED COMPLETION ENHANCEMENTS
# =============================================================================
# These add even more powerful completion features

# Enable completion for partial words (e.g., 'git sta' completes to 'git status')
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

# Group completions by type (files, directories, commands, etc.)
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# Cache completions for better performance
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Better completion for specific commands
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

# Completion for kill command (show process names)
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# SSH host completion
zstyle ':completion:*:ssh:*' hosts
zstyle ':completion:*:ssh:*' users

# Better file completion
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' file-list all

# Completion for man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-sections true
zstyle ':completion:*:man:*' menu yes select

# =============================================================================
# TOOL-SPECIFIC COMPLETION ENHANCEMENTS
# =============================================================================
# Enhanced completions for tools you have installed

# Brew completion (if you have Homebrew)
if command -v brew &> /dev/null; then
  # Enable brew completions
  if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
  fi
fi

# Git completion enhancements
if command -v git &> /dev/null; then
  # Better git branch completion
  zstyle ':completion:*:*:git:*' branch-names
  zstyle ':completion:*:*:git:*' remote-branches
  zstyle ':completion:*:*:git:*' tags
  zstyle ':completion:*:*:git:*' stashes
fi

# Node.js and npm completion
if command -v npm &> /dev/null; then
  # Enable npm completions
  source <(npm completion)
fi

# Docker completion (if you have Docker)
if command -v docker &> /dev/null; then
  # Docker completions are usually auto-loaded, but we can enhance them
  zstyle ':completion:*:*:docker:*' option-stacking yes
  zstyle ':completion:*:*:docker-*:*' option-stacking yes
fi

# VS Code completion
if command -v code &> /dev/null; then
  # Enable VS Code CLI completions
  zstyle ':completion:*:*:code:*' file-patterns '*.{js,ts,jsx,tsx,py,java,cpp,c,go,rs,php,rb,swift}'
fi

# =============================================================================
# EXTERNAL TOOLS INITIALIZATION
# =============================================================================
# These sections initialize external tools that enhance your shell experience

# Initialize carapace (completion engine)
# Carapace provides better completions for many command-line tools
if command -v carapace &> /dev/null; then  # Check if carapace is installed
  source <(carapace _carapace)  # Load carapace completions
fi

# Initialize fzf (fuzzy finder)
# FZF provides fuzzy searching for files, history, processes, etc.
if command -v fzf &> /dev/null; then  # Check if fzf is installed
  source <(fzf --zsh)  # Load fzf key bindings and completions
fi

# Initialize zoxide (smart cd)
# Zoxide learns your directory usage and provides smart cd suggestions
if command -v zoxide &> /dev/null; then  # Check if zoxide is installed
  eval "$(zoxide init --cmd cd zsh)"  # Initialize zoxide with 'cd' command
fi

# Initialize starship prompt
# Starship provides a fast, customizable shell prompt
if command -v starship &> /dev/null; then  # Check if starship is installed
  eval "$(starship init zsh)"  # Initialize starship prompt
fi

# =============================================================================
# STARTUP COMMANDS
# =============================================================================
# Commands that run when you start a new shell session

# Show system info on new terminal (only in interactive shells)
# This prevents fastfetch from running when sourcing .zshrc
if [[ $- == *i* ]]; then  # Check if this is an interactive shell
  # Only run fastfetch if we're in a new terminal session
  # (not when sourcing .zshrc manually)
  if [[ -z "$ZSH_LOADED" ]]; then  # Check if this is the first time loading
    fastfetch  # Show system information
    export ZSH_LOADED=1  # Mark that we've loaded the config
  fi
fi

# =============================================================================
# PLUGINS (Optional - uncomment if you want to add them)
# =============================================================================
# These are optional ZSH plugins that add extra functionality

# Uncomment these if you want to add ZSH plugins
# You'll need to install them first: brew install zsh-syntax-highlighting zsh-autosuggestions

# Syntax highlighting (install: brew install zsh-syntax-highlighting)
# This highlights commands as you type them (green for valid, red for invalid)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Auto-suggestions (install: brew install zsh-autosuggestions)
# This suggests commands based on your history (gray text you can accept with right arrow)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# =============================================================================
# END OF CONFIGURATION
# =============================================================================