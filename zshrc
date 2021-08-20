echo 'Hello from .zshrc'

# Set Variables
#export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat
export N_PREFIX="$HOME/.n"
export PREFIX="$N_PREFIX"


# Change ZSH Options


# Create Aliases
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias man=batman
alias bbd='brew bundle dump --force --describe'
alias trail='<<<${(F)path}'
alias rm=trash

# Customize Prompt(s)  (original = %n@%m %1~ %#)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Location to $PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:$N_PREFIX/bin"


# Write Handy Functions 
function mkcd() {
  mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins 


# ... and Other Surprises

