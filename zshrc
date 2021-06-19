echo 'Hello from .zshrc'

# set Variables


# Change ZSH Options


# Create Aliases
alias ls='ls -lAFh'

# Customize Prompt(s)  (original = %n@%m %1~ %#)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Location to $PATH Variable


# Write Handy Functions 
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

# Use ZSH Plugins


# ... and Other Surprises
