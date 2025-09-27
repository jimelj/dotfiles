#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

if exists brew; then
  echo "Brew exist, skipping install"
else 
  echo "Brew doesn't exist, continuing with install"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> /Users/jimelj/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jimelj/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"

# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/jimelj/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"

fi

echo "\n<<< Starting TMUX Plugin Manager >>>\n"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

brew bundle --verbose
