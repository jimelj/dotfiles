echo 'Hello from .zshrc'

# Set Variables
#export HOMEBREW_CASK_OPTS="--no-quarantine"  
# Change ZSH Options


# Create Aliases
#alias ls='ls -lAFh'
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias man=batman
alias bbd='brew bundle dump --force --describe'
alias trail='<<<${(F)path}'

# Customize Prompt(s)  (original = %n@%m %1~ %#)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Location to $PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Write Handy Functions 
function mkcd() {
  mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins 


# ... and Other Surprises

