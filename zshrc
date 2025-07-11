echo 'Hello from .zshrc'

# Set Variables
#export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat
export N_PREFIX="$HOME/.n"
export PREFIX="$N_PREFIX"


# Change ZSH Options


# Create Aliases
alias ls='eza -lahF --git'
alias eza='eza -lahF --git'
alias man=batman
alias bbd='brew bundle dump --force --describe'
alias trail='<<<${(F)path}'
alias rm=trash
alias tmp="cd /private/tmp"

# Thefuck aliases 
eval $(thefuck --alias)
eval $(thefuck --alias fuck)


# Customize Prompt(s)  (original = %n@%m %1~ %#)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Location to $path Array Variable
# export PATH="$N_PREFIX/bin:$PATH"
# export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

typeset -U path 

path=(
  "$N_PREFIX/bin"
  $path
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
)



# Write Handy Functions 
function mkcd() {
  mkdir -p "$@" && cd "$_";
}


# Use ZSH Plugins 


# ... and Other Surprises
fastfetch
